//
//  SettingCell.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class SettingCell: UIView {
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .atchGrey3
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.smallButton)
    }
    
    let nextButton = UIButton().then {
        $0.setImage(.icArrowNext, for: .normal)
    }
    
    init(titleText: String, buttonHidden: Bool) {
        super.init(frame: .zero)
        
        titleLabel.text = titleText
        nextButton.isHidden = buttonHidden
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubviews(dividingLine,
                         titleLabel,
                         nextButton)
        
        dividingLine.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
            $0.centerY.equalToSuperview()
        }
    }
    
}
