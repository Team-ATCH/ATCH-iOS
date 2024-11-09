//
//  ProfileEditViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/9/24.
//

import Foundation

import RxRelay
import RxSwift

final class ProfileEditViewModel: NSObject {
    
    private let userRepository: UserRepository = UserRepository()

    let nicknameSuccessRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    let hashTagSuccessRelay: PublishRelay<Bool> = PublishRelay<Bool>()

    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateNickname(nickname: String) {
        Task {
            do {
                let result = try await userRepository.patchUserNickname(nickname: nickname)
                nicknameSuccessRelay.accept(result)
            }
        }
    }
    
    func updateHashTag(hashTag: [String]) {
        Task {
            do {
                let result = try await userRepository.patchUserHashTag(hashTag: hashTag)
                hashTagSuccessRelay.accept(result)
            }
        }
    }
}
