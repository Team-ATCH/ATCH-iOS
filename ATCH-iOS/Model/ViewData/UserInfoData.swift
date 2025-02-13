//
//  UserInfoData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct UserInfoData {
    let userID: Int
    let nickname: String
    let hashTag: [String]
    let latitude: Double
    let longitude: Double
    let characterImageURL: String
    let backgroundImageURL: String
    let items: [UserItem]
}

struct UserItem {
    let itemID: Int
    let itemImageURL: String
    let slotX: Double
    let slotY: Double
}
