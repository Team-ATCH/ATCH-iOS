//
//  SplashViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import Foundation

import RxRelay
import RxSwift

final class SplashViewModel: NSObject {
    
    let tokenValidRelay = PublishRelay<Bool>()
    
    func checkTokenValid() {
        // 토큰 유효한지 체크
        tokenValidRelay.accept(true)
    }
}