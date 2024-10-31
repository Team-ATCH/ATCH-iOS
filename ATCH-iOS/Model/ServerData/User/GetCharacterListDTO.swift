//
//  GetCharacterListDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

struct CharacterList: Decodable {
    let characterID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case characterID = "characterId"
        case imageURL = "image"
    }
}

typealias GetCharacterListDTO = [CharacterList]

extension GetCharacterListDTO {
    func mapToCharacterSelectView() -> [CharacterData] {
        let characterDataList: [CharacterData] = self.map { data in
            let characterData: CharacterData = .init(characterID: data.characterID,
                                                     imageURL: data.imageURL)
            return characterData
        }
        return characterDataList
    }
}
