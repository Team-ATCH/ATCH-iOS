//
//  GetCharacterListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct GetCharacterListDTO: Decodable {
    let data: [CharacterList]
}
struct CharacterList: Decodable {
    let characterID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case characterID = "characterId"
        case imageURL = "image"
    }
}

extension GetCharacterListDTO {
    func mapToCharacterSelectView() -> [CharacterData] {
        let characterDataList: [CharacterData] = self.data.map { data in
            let characterData: CharacterData = .init(characterID: data.characterID,
                                                     imageURL: data.imageURL)
            return characterData
        }
        return characterDataList
    }
}
