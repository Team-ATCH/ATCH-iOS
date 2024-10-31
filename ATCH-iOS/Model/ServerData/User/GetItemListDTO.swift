//
//  GetItemListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct ItemList: Decodable {
    let characterImageURL: String
    let slots: [Slot]
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case characterImageURL = "characterImage"
        case slots, items
    }
}

typealias GetItemListDTO = [ItemList]


extension GetItemListDTO {
    func mapToItemSelectView() -> [ItemData] {
        let itemDataList: [ItemData] = self.map { data in
            let itemData: ItemData = .init(characterImageURL: data.characterImageURL, 
                                           items: data.items.map { item in UserItem(itemID: item.itemID, itemImageURL: item.itemImageURL) },
                                           slots: data.slots.map { slot in ItemSlot(slotX: slot.x, slotY: slot.y)})
            return itemData
        }
        return itemDataList
    }
}
