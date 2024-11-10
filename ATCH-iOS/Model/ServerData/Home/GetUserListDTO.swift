//
//  GetUserListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

struct GetUserListDTO: Decodable {
    let data: [UserList]
}

struct UserList: Decodable {
    let userID: Int
    let nickname: String
    let hashTag: [String]
    let latitude, longitude: Double
    let characterImageURL: String
    let backgroundImageURL: String?
    let slots: [Slot]
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case characterImageURL = "characterImage"
        case backgroundImageURL = "backgroundImage"
        case nickname, hashTag, latitude, longitude, slots, items
    }
}

struct Item: Decodable {
    let itemID: Int?
    let itemImageURL: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
    }
}

struct Slot: Decodable {
    let x, y: Double
}

extension GetUserListDTO {
    func mapToMapView() -> [UserInfoData] {
        let userInfoDataList: [UserInfoData] = self.data.map { data in
            let itemsWithSlots = zip(data.items, data.slots).map { (item, slot) in
                return UserItem(itemID: item.itemID ?? 0,
                                itemImageURL: item.itemImageURL ?? "",
                                slotX: slot.x,
                                slotY: slot.y)
            }
            
            let userInfoData: UserInfoData = .init(userID: data.userID,
                                                   nickname: data.nickname,
                                                   hashTag: data.hashTag,
                                                   latitude: data.latitude,
                                                   longitude: data.longitude,
                                                   characterImageURL: data.characterImageURL,
                                                   backgroundImageURL: data.backgroundImageURL ?? "",
                                                   items: itemsWithSlots)
            return userInfoData
        }
        return userInfoDataList
    }
}
