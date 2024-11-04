//
//  GetItemListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetItemListDTO: Decodable {
    let data: [ItemList]
}
struct ItemList: Decodable {
    let characterImageURL: String
    let slots: [Slot]
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case characterImageURL = "characterImage"
        case slots, items
    }
}

extension GetItemListDTO {
    func mapToItemSelectView() -> [ItemData] {
        let itemDataList: [ItemData] = self.data.map { data in
            let itemData: ItemData = .init(characterImageURL: data.characterImageURL, 
                                           items: data.items.map { item in UserItem(itemID: item.itemID ?? 0, itemImageURL: item.itemImageURL ?? "") },
                                           slots: data.slots.map { slot in ItemSlot(slotX: slot.x, slotY: slot.y)})
            return itemData
        }
        return itemDataList
    }
}
