//
//  MapViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import Foundation

import RxRelay
import RxSwift

final class MapViewModel: NSObject {
    
    private let homeRepository: HomeRepository = HomeRepository()
    private let chatRepository: ChatRepository = ChatRepository()
    
    var mapChatList: [MapChatData] = []
    let mapChatListRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    var locationList: [UserLocationData] = []
    let locationListRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    let chatRelay: PublishRelay<RoomResponseDTO> = PublishRelay<RoomResponseDTO>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMyLoaction(longitude: Double, latitude: Double) {
        Task {
            do {
                _ = try await homeRepository.patchLocation(longitude: longitude, latitude: latitude)
                getUserList()
            }
        }
    }
    
    func getUserList() {
        mapChatList.removeAll()
        locationList.removeAll()
        
        Task {
            do {
                let result = try await homeRepository.getUserList()
                let mapChatDataList: [MapChatData] = result.map { data in
                    let mapChatData: MapChatData = .init(userID: String(data.userID),
                                                         characterUrl: data.characterImageURL,
                                                         backgroundUrl: data.backgroundImageURL,
                                                         nickName: data.nickname,
                                                         tag: "#" + data.hashTag.joined(separator: " #"),
                                                         items: data.items)
                    return mapChatData
                }
                
                mapChatList.append(contentsOf: mapChatDataList)
                mapChatListRelay.accept(!mapChatList.isEmpty)
                
                let locationDataList: [UserLocationData] = result.map { data in
                    let locationData: UserLocationData = .init(longitude: data.longitude,
                                                               latitude: data.latitude)
                    return locationData
                }
                
                locationList.append(contentsOf: locationDataList)
                locationListRelay.accept(!locationList.isEmpty)
                
            }
        }
    }
    
    func postChattingRoom(userID: Int) {
        Task {
            do {
                let result = try await chatRepository.postChattingRoom(userId: userID)
                if let result = result {
                    chatRelay.accept(result)
                }
            }
        }
    }
}
