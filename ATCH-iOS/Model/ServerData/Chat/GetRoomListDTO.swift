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
    let firstFromID: Int
    let firstFromNickname: String
    let firstProfileURL: String
    let secondFromID: Int
    let secondFromNickname: String
    let secondProfileURL: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case firstFromID = "firstFromId"
        case firstProfileURL = "firstFromImage"
        case secondFromID = "secondFromId"
        case secondProfileURL = "secondFromImage"
        case firstFromNickname, secondFromNickname
        case createdAt
    }
}

extension GetRoomListDTO {
    func mapToAllChatView() -> [AllChattingData] {
        let allChatDataList: [AllChattingData] = self.data.map { data in
            let allChatData: AllChattingData = .init(roomID: data.roomID,
                                                     firstProfileURL: data.firstProfileURL,
                                                     secondProfileURL: data.secondProfileURL,
                                                     content: data.content,
                                                     firstFromID: data.firstFromID,
                                                     firstFromNickname: data.firstFromNickname,
                                                     secondFromID: data.secondFromID,
                                                     secondFromNickname: data.secondFromNickname,
                                                     createdAt: data.createdAt)
            return allChatData
        }
        return allChatDataList
    }
    
}
