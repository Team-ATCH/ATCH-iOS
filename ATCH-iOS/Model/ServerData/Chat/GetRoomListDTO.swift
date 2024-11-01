//
//  GetRoomListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetRoomListDTO: Decodable {
    let data: [RoomList]
}

struct RoomList: Decodable {
    let roomID: Int
    let content: String
    let fromID: Int
    let fromNickname, createdAt: String
    let read: Bool

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case fromID = "fromId"
        case fromNickname, createdAt, read
    }
}

extension GetRoomListDTO {
    func mapToAllChatView() -> [AllChattingData] {
        let allChatDataList: [AllChattingData] = self.data.map { data in
            let allChatData: AllChattingData = .init(roomID: data.roomID,
                                                     content: data.content,
                                                     fromID: data.fromID,
                                                     fromNickname: data.fromNickname,
                                                     createdAt: data.createdAt,
                                                     read: data.read)
            return allChatData
        }
        return allChatDataList
    }
    
}
