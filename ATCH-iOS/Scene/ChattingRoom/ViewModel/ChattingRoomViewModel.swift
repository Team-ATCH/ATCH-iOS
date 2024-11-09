//
//  ChattingRoomViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import Foundation

import RxRelay
import RxSwift

import StompClientLib

final class ChattingRoomViewModel: NSObject {
    
    private let chatRepository: ChatRepository = ChatRepository()
    private var socketClient = StompClientLib()
    
    private var sender = Sender(senderId: "", displayName: "")
    private var roomID: Int = 0

    var previousMessagesRelay: PublishRelay<[ChattingData]> = PublishRelay<[ChattingData]>()
    var messageRelay: PublishRelay<ChattingData> = PublishRelay<ChattingData>()
    
    
    init(opponent: Sender, roomID: Int) {
        super.init()
        
        self.sender = Sender(senderId: opponent.senderId,
                             displayName: opponent.displayName,
                             profileImageUrl: opponent.profileImageUrl)
        self.roomID = roomID
        
        self.registerSockect()
    }
    
    func getPreviousChattingMessages() {
        Task {
            do {
                let result = try await chatRepository.getChattingList(roomId: roomID)
                previousMessagesRelay.accept(result)
            }
        }
    }
    
    func getAllChattingMessages() {
        Task {
            do {
                let result = try await chatRepository.getChattingList(roomId: roomID)
                previousMessagesRelay.accept(result)
            }
        }
    }
    
    func registerSockect() {
        if let url = URL(string: Config.webSocketURL),
           let accessToken = KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()) {
            socketClient.openSocketWithURLRequest(
                request: NSURLRequest(url: url),
                delegate: self,
                connectionHeaders: [ "Authorization" : "Bearer \(accessToken)" ]
            )
        }
    }
    
    func subscribe() {
        socketClient.subscribe(destination: "/sub/messages/\(roomID)")
    }
    
    func sendMessage(message: ChattingData) {
        let payloadObject : [String : Any] = [ "content" : message.content ]
        
        socketClient.sendJSONForDict(
            dict: payloadObject as AnyObject,
            toDestination: "/pub/messages/\(roomID)")
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
    
}

extension ChattingRoomViewModel: StompClientLibDelegate {
    func stompClient(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: AnyObject?,
        akaStringBody stringBody: String?,
        withHeader header: [String : String]?,
        withDestination destination: String
    ) {

        guard let json = jsonBody as? [String : AnyObject] else { return }
        guard let innerJSON_FromID = json ["fromId"] as? Int else { return }
        guard let innerJSON_Message = json ["content"] as? String else { return }
        
        if innerJSON_FromID == Int(sender.senderId) {
            // 내가 보내는 메세지에 대해선 나에게 pub X
            messageRelay.accept(ChattingData(sender: sender,
                                             content: innerJSON_Message,
                                             sendDate: Date()))
        }
    }
    
    func stompClientJSONBody(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: String?,
        withHeader header: [String : String]?,
        withDestination destination: String
    ) {
        
    }
    
    // Unsubscribe Topic
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Stomp socket is disconnected")
    }
    
    // Subscribe Topic after Connection
    func stompClientDidConnect(client: StompClientLib!) {
        print("Stomp socket is connected")
        
        subscribe()
    }
    
    // Error - disconnect and reconnect socket
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error send : " + description)
        
        socketClient.disconnect()
        registerSockect()
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
}
