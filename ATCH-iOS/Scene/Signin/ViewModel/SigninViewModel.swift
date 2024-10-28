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
    
    private let networkProvider: NetworkServiceType = NetworkService()

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
    
    func performAppleLogin() {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    private func handleKakaoLoginResult(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
        } else if let authorizationCode = oauthToken?.idToken {
            print(authorizationCode)
            Task {
                do {
                    let result = try await self.postKakaoLogin(code: authorizationCode)
                    guard let accessToken = result?.accessToken else { return }
                    KeychainWrapper.saveToken(accessToken, forKey: "accessToken")
                    print(accessToken)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func postKakaoLogin(code: String) async throws -> SigninResposeDTO? {
        let requestDTO = SigninRequestBody(code: code)
        do {
            let data: SigninResposeDTO? = try await self.networkProvider.network(
                type: .post,
                baseURL: Config.appBaseURL + "/login",
                accessToken: nil,
                body: requestDTO,
                pathVariables: ["provider":"KAKAO"])
            
            return data
        }
        catch {
            print(error.localizedDescription)
            return nil
       }
    }
    
    func postAppleLogin(code: String) async throws -> SigninResposeDTO? {
        let requestDTO = SigninRequestBody(code: code)
        do {
            let data: SigninResposeDTO? = try await self.networkProvider.network(
                type: .post,
                baseURL: Config.appBaseURL + "/login",
                accessToken: nil,
                body: requestDTO,
                pathVariables: ["provider":"APPLE"])
            
            return data
        }
        catch {
            print(error.localizedDescription)
            return nil
       }
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
                    let result = try await self.postAppleLogin(code: token)
                    guard let accessToken = result?.accessToken else { return }
                    KeychainWrapper.saveToken(accessToken, forKey: "accessToken")
                    print(accessToken)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
