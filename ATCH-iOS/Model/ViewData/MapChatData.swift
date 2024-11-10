//
//  MapChatData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/31/24.
//

import Foundation

struct MapChatData { // 다른 유저들에 대한 정보
    let userID: String
    let characterUrl: String
    let itemUrl: [String]
    let nickName: String
    let tag: String
    let items: [UserItem]
}
