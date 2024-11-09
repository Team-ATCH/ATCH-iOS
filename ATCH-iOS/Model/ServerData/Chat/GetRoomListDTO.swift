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
    let opponentID: Int
    let opponentNickname, createdAt: String
    let read: Bool

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case opponentID = "opponentId"
        case opponentNickname, createdAt, read
    }
}

extension GetRoomListDTO {
    func mapToAllChatView() -> [AllChattingData] {
        let allChatDataList: [AllChattingData] = self.data.map { data in
            let allChatData: AllChattingData = .init(roomID: data.roomID,
                                                     content: data.content,
                                                     opponentID: data.opponentID,
                                                     opponentNickname: data.opponentNickname,
                                                     createdAt: data.createdAt,
                                                     read: data.read)
            return allChatData
        }
        return allChatDataList
    }
    
}
