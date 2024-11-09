//
//  MyChatViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/9/24.
//

import Foundation

import RxSwift
import RxRelay

final class MyChatViewModel: NSObject {
    private let chatRepository: ChatRepository = ChatRepository()
    
    var chatList: [MyChatData] = []
    let chatListRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    
    private var lastID: Int = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getChatList() {
        chatList.removeAll()
        Task {
            do {
                let result = try await chatRepository.getMyChattingRoomList(limit: String(10), lastID: String(lastID))
                chatList.append(contentsOf: result)
                chatListRelay.accept(!chatList.isEmpty)
            }
        }
    }
}
