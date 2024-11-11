//
//  GetBackgroundListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetBackgroundListDTO: Decodable {
    let inUseId: Int?
    let data: [BackgroundList]
}
struct BackgroundList: Decodable {
    let itemID: Int
    let itemImageURL: String
    let itemProfileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemImageURL = "itemImage"
        case itemProfileImageURL = "itemProfileImage"
    }
}

extension GetBackgroundListDTO {
    func mapToBackgroundSelectView() -> [BackgroundData] {
        let backgroundDataList: [BackgroundData] = self.data.map { data in
            let backgroundData: BackgroundData = .init(itemID: data.itemID,
                                                       itemImageURL: data.itemImageURL, 
                                                       itemProfileImageURL: data.itemProfileImageURL ?? "")
            return backgroundData
        }
        return backgroundDataList
    }
}
