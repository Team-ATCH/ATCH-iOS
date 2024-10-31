//
//  GetMyRoomListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

struct GetMyRoomList: Codable {
    let roomID: Int
    let content: String
    let fromID: Int
    let fromNickname: String
    let hashTag: [String]
    let image, createdAt: String

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case fromID = "fromId"
        case fromNickname, hashTag, image, createdAt
    }
}

typealias GetMyRoomListDTO = [GetMyRoomList]
