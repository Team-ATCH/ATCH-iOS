//
//  NSObject+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/31/24.
//

import Foundation

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

extension NSObject: ReuseIdentifier {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
