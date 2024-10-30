//
//  SigninResponseDTO.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/27/24.
//

import Foundation

struct SigninResposeDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
    let newUser: Bool
}
