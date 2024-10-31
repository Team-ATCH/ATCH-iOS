//
//  RoomResponseDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct RoomResponseDTO: Decodable {
    let roomID, fromID, toID: Int

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case fromID = "fromId"
        case toID = "toId"
    }
}
