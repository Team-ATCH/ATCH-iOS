//
//  GetCharacterSlotDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/11/24.
//

import Foundation

struct GetCharacterSlotDTO: Decodable {
    let data: [CharacterSlot]
}

struct CharacterSlot: Decodable {
    let charID: Int
    let slots: [Slot]

    enum CodingKeys: String, CodingKey {
        case charID = "charId"
        case slots
    }
}
