//
//  UserData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class UserData {
    static var shared = UserData()
    
    var characterIndex: Int = 0
    
    func characterImage() -> UIImage {
        switch self.characterIndex {
        case 0:
            return .imgCharacterOne
        case 1:
            return .imgCharacterTwo
        case 2:
            return .imgCharacterThree
        case 3:
            return .imgCharacterFour
        case 4:
            return .imgCharacterFive
        default:
            return .imgCharacterOne
        }
    }
}
