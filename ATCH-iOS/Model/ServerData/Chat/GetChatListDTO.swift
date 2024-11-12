//
//  GetChatListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetChatListDTO: Decodable {
    let myId: Int
    let data: [ChatList]
}

struct ChatList: Decodable {
    let content: String
    let fromID: Int
    let fromNickname: String
    let fromProfileImageURL: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case content
        case fromID = "fromId"
        case fromNickname
        case fromProfileImageURL = "fromProfileImage"
        case createdAt
    }
}

extension GetChatListDTO {
    func mapToChattingRoomView() -> [ChattingData] {
        let chattingDataList: [ChattingData] = self.data.map { data in
            let chattingData: ChattingData = .init(sender: Sender(senderId: String(data.fromID),
                                                                  displayName: data.fromNickname,
                                                                  profileImageUrl: data.fromProfileImageURL ?? ""),
                                                   content: data.content,
                                                   sendDate: data.createdAt.convertToDate() ?? Date())
            return chattingData
        }
        return chattingDataList
    }
}
