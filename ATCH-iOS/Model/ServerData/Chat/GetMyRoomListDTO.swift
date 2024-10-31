//
//  GetMyRoomListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct MyRoomList: Codable {
    let roomID: Int
    let content: String
    let fromID: Int
    let fromNickname: String
    let hashTag: [String]
    let imageURL, createdAt: String

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case content
        case fromID = "fromId"
        case fromNickname, hashTag, createdAt
        case imageURL = "image"
    }
}

typealias GetMyRoomListDTO = [MyRoomList]

extension GetMyRoomListDTO {
    func mapToMyChatView() -> [MyChatData] {
        let myChatDataList: [MyChatData] = self.map { data in
            let myChatData: MyChatData = .init(characterUrl: data.imageURL,
                                               id: String(data.fromID),
                                               nickName: data.fromNickname,
                                               content: data.content,
                                               tag: "#" + data.hashTag.joined(separator: " #"))
            return myChatData
        }
        return myChatDataList
    }
}
