//
//  ItemData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

enum StandardSize: Double {
    case width = 178.0
    case height = 278.0
}

struct ItemData {
    let characterID: Int
    let characterImageURL: String
    let items: [MyPageUserItem]
}

struct MyPageUserItem {
    let itemID: Int
    let itemImageURL: String
    let itemProfileImageURL: String
    let slotX: Double
    let slotY: Double
}
