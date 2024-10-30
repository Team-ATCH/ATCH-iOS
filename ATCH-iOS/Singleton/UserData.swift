//
//  UserData.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxRelay

final class UserData {
    static var shared = UserData()
    
    var userId: Int = 0
    var characterIndex: Int = 0
    var nickname: String = ""
    var hashTag: [HashTag] = []
    var hashTagRelay: BehaviorRelay<[HashTag]> = BehaviorRelay<[HashTag]>(value: [])
    
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

enum HashTag: CaseIterable {
    case fashion, restaurant, cafe, fan
    case indi, busking, club, vintage
    case performance, hongdae, tourist, people
    case artist, boss, influencer, foreigner
    case hipster, unemployed
        
    var hashTagTitle: String {
        switch self {
        case .fashion:
            return "패션"
        case .restaurant:
            return "맛집"
        case .cafe:
            return "카페"
        case .fan:
            return "덕질"
        case .indi:
            return "인디씬"
        case .busking:
            return "버스킹"
        case .club:
            return "클럽"
        case .vintage:
            return "빈티지"
        case .performance:
            return "공연"
        case .hongdae:
            return "홍대생"
        case .tourist:
            return "관광객"
        case .people:
            return "주민"
        case .artist:
            return "아티스트"
        case .boss:
            return "사장님"
        case .influencer:
            return "인플루언서"
        case .foreigner:
            return "외국인"
        case .hipster:
            return "힙스터"
        case .unemployed:
            return "백수"
        }
    }
    
    var hashTagWitdh: Int {
        switch self {
        case .fashion, .restaurant, .cafe, .fan, .club, .performance, .people, .unemployed:
            return 55
        case .indi, .busking, .vintage, .hongdae, .tourist, .boss, .foreigner, .hipster:
            return 67
        case .artist:
            return 79
        case .influencer:
            return 91
        }
    }
    
    var hashTagSelectedImage: UIImage {
        switch self {
        case .fashion, .restaurant, .cafe, .fan, .club, .performance, .people, .unemployed:
            return .imgXsButton
        case .indi, .busking, .vintage, .hongdae, .tourist, .boss, .foreigner, .hipster:
            return .imgSButton
        case .artist:
            return .imgMButton
        case .influencer:
            return .imgLButton
        }
    }
    
    var hashTagDeSelectedImage: UIImage {
        switch self {
        case .fashion, .restaurant, .cafe, .fan, .club, .performance, .people, .unemployed:
            return .imgXsDisableButton
        case .indi, .busking, .vintage, .hongdae, .tourist, .boss, .foreigner, .hipster:
            return .imgSDisableButton
        case .artist:
            return .imgMDisableButton
        case .influencer:
            return .imgLDisableButton
        }
    }

}
