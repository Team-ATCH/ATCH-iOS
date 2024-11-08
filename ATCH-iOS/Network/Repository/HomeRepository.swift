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
            let response: NetworkResult<EmptyResponse?> = try await networkProvider.request(
                type: .patch,
                baseURL: Config.appBaseURL + "/home/locate",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
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
    
    func getUserList() async throws -> [UserInfoData] {
        do {
            let response: NetworkResult<GetUserListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/home",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
                pathVariables: nil
            )
    
            switch response {
            case .success(let data):
                return data?.mapToMapView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
    
    func getNoticeList() async throws -> [AlarmData] {
        do {
            let response: NetworkResult<GetNoticeListDTO?> = try await networkProvider.request(
                type: .get,
                baseURL: Config.appBaseURL + "/home",
                accessToken: KeychainWrapper.loadToken(forKey: UserData.shared.getAccessTokenType()),
                body: nil,
                pathVariables: nil
            )
    
            switch response {
            case .success(let data):
                return data?.mapToAlarmView() ?? []
            case .failure(let error):
                print("Error Code: \(error.code ?? "No code"), Message: \(error.message ?? "No message")")
                return []
            }
        } catch {
            return []
        }
    }
}
