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
    
    var mapChatList: [MapChatData] = []
    let mapChatListRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    var locationList: [UserLocationData] = []
    let locationListRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMyLoaction(latitude: Double, longitude: Double) {
        Task {
            do {
                _ = try await homeRepository.patchLocation(latitude: latitude, longitude: longitude)
                getUserList()
            }
        }
    }
    
    func getUserList() {
        Task {
            do {
                let result = try await homeRepository.getUserList()
                let mapChatDataList: [MapChatData] = result.map { data in
                    let mapChatData: MapChatData = .init(userID: String(data.userID),
                                                         characterUrl: data.characterImageURL,
                                                         itemUrl: data.items.map { $0.itemImageURL },
                                                         nickName: data.nickname,
                                                         tag: "#" + data.hashTag.joined(separator: " #"))
                    return mapChatData
                }
                
                mapChatList.append(contentsOf: mapChatDataList)
                mapChatListRelay.accept(!mapChatList.isEmpty)
                
                let locationDataList: [UserLocationData] = result.map { data in
                    let locationData: UserLocationData = .init(latitude: data.latitude,
                                                               longitude: data.longitude)
                    return locationData
                }
                
                locationList.append(contentsOf: locationDataList)
                locationListRelay.accept(!locationList.isEmpty)
                
            }
        }
    }
}
