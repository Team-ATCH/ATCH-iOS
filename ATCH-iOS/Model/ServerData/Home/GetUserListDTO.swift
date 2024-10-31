//
//  GetUserListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

struct GetUserListDTO: Decodable {
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
