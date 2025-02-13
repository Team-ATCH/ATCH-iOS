//
//  GetMyRoomListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetMyRoomListDTO: Decodable {
    let data: [MyRoomList]
}

struct MyRoomList: Decodable {
    let roomID: Int
    let content: String
    let opponentID: Int?
    let opponentNickname: String
    let hashTag: [String]?
    let imageURL: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case opponentID = "opponentId"
        case opponentNickname, hashTag, createdAt
        case imageURL = "image"
    }
}

extension GetMyRoomListDTO {
    func mapToMyChatView() -> [MyChatData] {
        let myChatDataList: [MyChatData] = self.data.map { data in
            let myChatData: MyChatData = .init(characterUrl: data.imageURL ?? "",
                                               id: String(data.opponentID ?? 0),
                                               nickName: data.opponentNickname,
                                               content: data.content,
                                               tag: data.hashTag == nil ? "" : "#" + (data.hashTag?.joined(separator: " #") ?? ""),
                                               roomID: data.roomID)
            return myChatData
        }
        return myChatDataList
    }
}
