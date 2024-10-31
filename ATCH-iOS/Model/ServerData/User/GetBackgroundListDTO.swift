//
//  GetBackgroundListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct BackgroundList: Decodable {
    let itemID: Int
    let itemImageURL: String

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
    }
}

typealias GetBackgroundListDTO = [BackgroundList]

extension GetBackgroundListDTO {
    func mapToBackgroundSelectView() -> [BackgroundData] {
        let backgroundDataList: [BackgroundData] = self.map { data in
            let backgroundData: BackgroundData = .init(itemID: data.itemID,
                                                 itemImageURL: data.itemImageURL)
            return backgroundData
        }
        return backgroundDataList
    }
}
