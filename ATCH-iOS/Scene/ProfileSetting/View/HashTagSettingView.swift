//
//  HashTagSettingView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/13/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class HashTagSettingView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        
        self.setupStyle()
        self.setupLayout()
        self.setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupStyle() {

    }

    private func setupLayout() {
    
    }
    
    private func setupAction() {
        
    }
    
}
