//
//  HomeRepository.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/30/24.
//

import Foundation

final class HomeRepository {
    
    private let networkProvider: NetworkServiceType = NetworkService()

    func patchLocation(latitude: Double, longitude: Double) async throws -> Bool {
        let requestDTO = LocationRequestBody(latitude: latitude,
                                             longitude: longitude)
        do {
            let response: NetworkResult<EmptyResponse> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/home/locate",
                accessToken: KeychainWrapper.loadToken(forKey: .accessToken),
                body: requestDTO,
                pathVariables: nil
            )
    
            switch response {
            case .success:
                return true
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return false
            }
        } catch {
            return false
        }
    }
}
