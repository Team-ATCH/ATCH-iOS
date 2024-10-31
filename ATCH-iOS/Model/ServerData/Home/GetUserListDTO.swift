//
//  GetUserListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

struct UserList: Decodable {
    let userID: Int
    let nickname: String
    let hashTag: [String]
    let latitude, longitude: Double
    let characterImageURL: String
    let slots: [Slot]
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case characterImageURL = "characterImage"
        case nickname, hashTag, latitude, longitude, slots, items
    }
}

struct Item: Decodable {
    let itemID: Int
    let itemImageURL: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
    }
}

struct Slot: Decodable {
    let x, y: Double
}

typealias GetUserListDTO = [UserList]

extension GetUserListDTO {
    func mapToMapView() -> [UserInfoData] {
        let userInfoDataList: [UserInfoData] = self.map { data in
            let userInfoData: UserInfoData = .init(userID: data.userID,
                                                   nickname: data.nickname,
                                                   hashTag: data.hashTag,
                                                   latitude: data.latitude,
                                                   longitude: data.longitude,
                                                   characterImageURL: data.characterImageURL,
                                                   items: data.items.map { item in UserItem(itemID: item.itemID, itemImageURL: item.itemImageURL) },
                                                   slots: data.slots.map { slot in ItemSlot(slotX: slot.x, slotY: slot.y)})
            return userInfoData
        }
        return userInfoDataList
    }
}
