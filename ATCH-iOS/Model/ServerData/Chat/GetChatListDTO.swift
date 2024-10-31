//
//  GetChatListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

struct ChatList: Codable {
    let content: String
    let fromID: Int
    let fromNickname, createdAt: String
    let read: Bool

    enum CodingKeys: String, CodingKey {
        case content
        case fromID = "fromId"
        case fromNickname, createdAt, read
    }
}

typealias GetChatListDTO = [ChatList]
