//
//  GetItemListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetItemListDTO: Decodable {
    let characterImageURL: String
    let slots: [Slot]
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case characterImageURL = "characterImage"
        case slots, items
    }
}
