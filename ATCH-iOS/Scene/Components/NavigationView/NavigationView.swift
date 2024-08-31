//
//  BaseNavigationView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import SnapKit
import Then

final class NavigationView: UIView {
    
    let navigationBackButton = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let navigationBackButtonImageView = UIImageView().then {
        $0.image = .icArrowBack
        $0.contentMode = .scaleAspectFill
    }
    
    private let navigationBackButtonTitle = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.caption)
    }
    
    private let navigationTitle = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.chat)
        $0.textAlignment = .center
    }
    
    private let navigationIcon = UIImageView().then {
        $0.image = .icAlarm
        $0.contentMode = .scaleAspectFill
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    init(title: String = "", iconHidden: Bool = true, backButtonHidden: Bool = true, backButtonTitle: String = "") {
        navigationTitle.text = title
        navigationIcon.isHidden = iconHidden
        navigationBackButton.isHidden = backButtonHidden
        navigationBackButtonTitle.text = backButtonTitle
        
        super.init(frame: .zero)
        
        self.setupStyle()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func changeTitle(title: String) {
        navigationTitle.text = title
    }
    
    private func setupStyle() {
        self.backgroundColor = .atchWhite
    }
    
    private func setupLayout() {
        navigationBackButton.addArrangedSubviews(navigationBackButtonImageView, navigationBackButtonTitle)
        navigationBackButtonImageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        
        self.addSubviews(navigationBackButton,
                         navigationTitle,
                         navigationIcon,
                         dividingLine)
        
        navigationBackButton.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(16)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        navigationIcon.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(9)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(42)
        }
        
        dividingLine.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

