//
//  Config.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/29/24.
//

import Foundation

enum Config {
    enum Keys {
        enum Plist {
            static let appBaseURL = "APP_BASE_URL"
            static let kakaoAPPKey = "KAKAO_APP_KEY"
            static let webSocketURL = "WEB_SOCKET_URL"
        }
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dictionary = Bundle.main.infoDictionary else {
            fatalError("plist cannot found.")
        }
        return dictionary
    }()
}

extension Config {
    static let appBaseURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.appBaseURL] as? String else {
            fatalError("Base URL is not set in plist for this configuration")
        }
        return key
    }()
    
    static let kakaoAPPKey: String = {
        guard let key = Config.infoDictionary[Keys.Plist.kakaoAPPKey] as? String else {
            fatalError("Kakao App Key is not set in plist for this configuration")
        }
        return key
    }()
    
    static let webSocketURL: String = {
        guard let key = Config.infoDictionary[Keys.Plist.webSocketURL] as? String else {
            fatalError("Web Socket URL is not set in plist for this configuration")
        }
        return key
    }()
}
