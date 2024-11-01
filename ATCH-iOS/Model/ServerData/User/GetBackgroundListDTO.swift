//
//  GetBackgroundListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetBackgroundListDTO: Decodable {
    let data: [BackgroundList]
}
struct BackgroundList: Decodable {
    let itemID: Int
    let itemImageURL: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
    }
}

extension GetBackgroundListDTO {
    func mapToBackgroundSelectView() -> [BackgroundData] {
        let backgroundDataList: [BackgroundData] = self.data.map { data in
            let backgroundData: BackgroundData = .init(itemID: data.itemID,
                                                 itemImageURL: data.itemImageURL)
            return backgroundData
        }
        return backgroundDataList
    }
}
