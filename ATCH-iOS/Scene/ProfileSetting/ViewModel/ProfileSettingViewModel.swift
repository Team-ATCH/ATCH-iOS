//
//  ProfileSettingViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import Foundation

import RxRelay
import RxSwift

final class ProfileSettingViewModel: NSObject {
    
    private let onboardingRepository: OnboardingRepository = OnboardingRepository()

    let successRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getAllCharacter() -> PublishRelay<[CharacterData]> {
        let resultRealy = PublishRelay<[CharacterData]>()
        Task {
            do {
                let result = try await onboardingRepository.getCharacterList()
                resultRealy.accept(result)
            }
        }
        return resultRealy
    }
    
    func updateCharacter(characterID: Int) {
        Task {
            do {
                let result = try await onboardingRepository.postCharacter(characterID: characterID)
                successRelay.accept(result)
            }
        }
    }
    
    func updateNickname(nickname: String) {
        Task {
            do {
                let result = try await onboardingRepository.postNickname(nickname: nickname)
                successRelay.accept(result)
            }
        }
    }
    
    func updateHashTag(hashTag: [String]) {
        Task {
            do {
                let result = try await onboardingRepository.postHashTag(hashTag: hashTag)
                successRelay.accept(result)
            }
        }
    }
    
}
