//
//  PopUpViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/31/24.
//

import Foundation

import RxRelay
import RxSwift

final class PopUpViewModel: NSObject {
    
    private let userRepository: UserRepository = UserRepository()
    
    let successRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
