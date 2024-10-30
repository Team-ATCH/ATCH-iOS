//
//  SigninRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class SigninRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()

    func postKakaoLogin(code: String) async throws -> SigninResposeDTO? {
        let requestDTO = SigninRequestBody(code: code)
        do {
            let data: SigninResposeDTO? = try await 
            networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/login",
                accessToken: nil,
                body: requestDTO,
                pathVariables: ["provider":"KAKAO"]
            )
            return data
        }
        catch {
            return nil
       }
    }
    
    func postAppleLogin(code: String) async throws -> SigninResposeDTO? {
        let requestDTO = SigninRequestBody(code: code)
        do {
            let data: SigninResposeDTO? = try await
            networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/login",
                accessToken: nil,
                body: requestDTO,
                pathVariables: ["provider":"APPLE"]
            )
            
            return data
        }
        catch {
            return nil
       }
    }
}
