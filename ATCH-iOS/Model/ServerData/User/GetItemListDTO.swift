//
//  GetItemListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetItemListDTO: Decodable {
    let characterID: Int
    let characterImageURL: String
    let slots: [Slot]
    let inUseIDs: [Int?]
    let items: [MyPageItem]
    
    enum CodingKeys: String, CodingKey {
        case characterID = "characterId"
        case characterImageURL = "characterImage"
        case slots, items
        case inUseIDs = "inUseIds"
    }
}

struct MyPageItem: Decodable {
    let itemID: Int?
    let itemImageURL: String?
    let itmeProfileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
        case itmeProfileImageURL = "itemProfileImage"
    }
}

extension GetItemListDTO {
    func mapToItemSelectView() -> ItemData {
        let itemsWithSlots = zip(self.items, self.slots).map { (item, slot) in
            return MyPageUserItem(itemID: item.itemID ?? 0,
                                  itemImageURL: item.itemImageURL ?? "",
                                  itemProfileImageURL: item.itmeProfileImageURL ?? "",
                                  slotX: slot.x,
                                  slotY: slot.y)
        }
        return .init(characterID: self.characterID,
                     characterImageURL: self.characterImageURL,
                     items: itemsWithSlots)
    }
}
