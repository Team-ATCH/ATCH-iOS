//
//  SigninViewModel.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/11/24.
//

import AuthenticationServices
import Foundation

import RxRelay
import RxSwift

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class SigninViewModel: NSObject {
    
    private let signinRepository: SigninRepository = SigninRepository()

    let successRelay: PublishRelay<Bool> = PublishRelay<Bool>()
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func performKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                self?.handleKakaoLoginResult(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
         if let authorizationCode = oauthToken?.idToken {
            Task {
                do {
                    let result = try await signinRepository.postKakaoLogin(code: authorizationCode)
                    if let accessToken = result?.accessToken {
                        KeychainWrapper.saveToken(accessToken, forKey: .accessToken)
                        successRelay.accept(true)
                    } else {
                        successRelay.accept(false)
                    }
                }
            }
        }
    }
    
    func performAppleLogin() {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}

extension SigninViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        if let identifyToken = credential.identityToken,
           let token = String(data: identifyToken, encoding: .utf8) {
            Task {
                do {
                    let result = try await signinRepository.postAppleLogin(code: token)
                    if let accessToken = result?.accessToken {
                        KeychainWrapper.saveToken(accessToken, forKey: .accessToken)
                        successRelay.accept(true)
                    } else {
                        successRelay.accept(false)
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
