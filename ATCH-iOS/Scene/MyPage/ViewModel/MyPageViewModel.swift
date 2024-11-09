//
//  MyPageViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

import RxSwift
import RxRelay

final class MyPageViewModel: NSObject {
    
    private let userRepository: UserRepository = UserRepository()

    let successRelay: PublishRelay<Bool> = PublishRelay<Bool>()
        
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func withdraw() {
        Task {
            do {
                let result = try await userRepository.deleteUser()
                successRelay.accept(result)
            }
        }
    }
}
