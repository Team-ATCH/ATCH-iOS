//
//  SigninRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class SigninRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()

    private func postLogin(code: String, provider: String) async throws -> SigninResposeDTO? {
        let requestDTO = SigninRequestBody(code: code)
        let response: NetworkResult<SigninResposeDTO?> = try await
            networkProvider.request(
                type: .post,
                baseURL: Config.appBaseURL + "/login",
                accessToken: nil,
                body: requestDTO,
                pathVariables: ["provider": provider]
            )
        
        switch response {
        case .success(let data):
            return data
        case .failure(let error):
            print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
            return nil
        }
    }

    
    // 카카오 로그인
    func postKakaoLogin(code: String) async throws -> SigninResposeDTO? {
        return try await postLogin(code: code, provider: "KAKAO")
    }
    
    // 애플 로그인
    func postAppleLogin(code: String) async throws -> SigninResposeDTO? {
        return try await postLogin(code: code, provider: "APPLE")
    }
}
