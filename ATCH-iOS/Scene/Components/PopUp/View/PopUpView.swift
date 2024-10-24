//
//  PopUpView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PopUpView: UIView {
    
    private var type: PopUpType = .oneButton
    
    private let dimView = UIView().then {
        $0.backgroundColor = .atchBlack
        $0.alpha = 0.4
    }
    
    private let popUpBackground = UIImageView().then {
        $0.image = .imgPopupBackground
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.title2)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let verticalDividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    private let oneButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitleColor(.atchBlack3, for: .normal)
        $0.titleLabel?.font = .font(.bigButton)
    }
    
    private let leftButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitleColor(.atchBlack3, for: .normal)
        $0.titleLabel?.font = .font(.bigButton)
    }
    
    private let rightButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitleColor(.atchBlack3, for: .normal)
        $0.titleLabel?.font = .font(.bigButton)
    }
    
    private let horizontalDividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bindViewData(data: PopUpData) {
        self.type = data.type

        oneButton.setTitle(data.oneButtonText, for: .normal)
        leftButton.setTitle(data.leftButtonText, for: .normal)
        rightButton.setTitle(data.rightButtonText, for: .normal)
    }
    
    private func setupLayout() {
        self.addSubviews(dimView,
                         popUpBackground)
        
        popUpBackground.addSubviews(contentLabel,
                                    verticalDividingLine)

        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        popUpBackground.snp.makeConstraints {
            $0.width.equalTo(242.adjustedW)
            $0.height.equalTo(148.adjustedH)
            $0.center.equalToSuperview()
        }
    
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        verticalDividingLine.snp.makeConstraints {
            $0.top.equalToSuperview().inset(82.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }

        switch type {
        case .oneButton:
            popUpBackground.addSubview(oneButton)
            oneButton.snp.makeConstraints {
                $0.top.equalTo(verticalDividingLine.snp.bottom)
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(62.adjustedH)
            }
            
        case .twoButton:
            popUpBackground.addSubviews(horizontalDividingLine,
                                        leftButton,
                                        rightButton)
            
            horizontalDividingLine.snp.makeConstraints {
                $0.top.equalTo(verticalDividingLine.snp.bottom)
                $0.leading.equalToSuperview().inset(120.adjustedW)
                $0.width.equalTo(1)
            }
            
            leftButton.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.trailing.equalTo(horizontalDividingLine.snp.leading)
            }
            
            rightButton.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.leading.equalTo(horizontalDividingLine.snp.trailing)
            }
            
        }

    }
}
