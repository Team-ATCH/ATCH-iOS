//
//  GetChatListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

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

extension GetChatListDTO {
    func mapToChattingRoomView() -> [ChattingData] {
        let chattingDataList: [ChattingData] = self.map { data in
            let chattingData: ChattingData = .init(sender: Sender(senderId: String(data.fromID), displayName: data.fromNickname),
                                                   content: data.content,
                                                   sendDate: data.createdAt.convertToDate() ?? Date())
            return chattingData
        }
        return chattingDataList
    }
}
