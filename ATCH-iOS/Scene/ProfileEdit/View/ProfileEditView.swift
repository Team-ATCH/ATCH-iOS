//
//  ProfileEditView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class ProfileEditView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.spacing = 36
    }
    
    private let nicknameSettingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private let nicknameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .atchShadowGrey
        $0.font = .font(.smallButton)
    }
    
    private let nicknameTextFiled = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임은 최대 10글자",
            attributes: [
                .foregroundColor: UIColor.atchGrey4
            ]
        )
        $0.textColor = .atchBlack
        $0.font = .font(.title2)
    }
    
    private let nicknameUnderLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    private let hashTagSettingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private let hashTagTitleLabel = UILabel().then {
        $0.text = "해시태그"
        $0.textColor = .atchShadowGrey
        $0.font = .font(.smallButton)
    }
    
    private let hashTagStackView = HashTagStackView().then {
        $0.alignment = .leading
    }
    
    let nextButton = UIImageView().then {
        $0.image = .imgBigButton
        $0.contentMode = .scaleAspectFill
    }
    
    private let nextLabel = UILabel().then {
        $0.text = "저장"
        $0.textColor = .atchBlack
        $0.font = .font(.bigButton)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupHashTag()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupHashTag() {
        UserData.shared.hashTagRelay
            .withUnretained(self)
            .subscribe(onNext: { view, value in
                print(value)
            }).disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        self.addSubviews(stackView, 
                         nextButton)

        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalToSuperview().inset(39)
            $0.trailing.equalToSuperview().inset(41)
        }
        
        stackView.addArrangedSubviews(nicknameSettingStackView,
                                      hashTagSettingStackView)
        
        nicknameSettingStackView.addArrangedSubviews(nicknameTitleLabel,
                                                     nicknameTextFiled,
                                                     nicknameUnderLine)
        
        hashTagSettingStackView.addArrangedSubviews(hashTagTitleLabel,
                                                    hashTagStackView)
        
        nicknameSettingStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        nicknameTextFiled.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        nicknameUnderLine.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints {
            $0.width.equalTo(295)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 63 + 29)
        }
        
        nextButton.addSubview(nextLabel)
        nextLabel.snp.makeConstraints {
            $0.top.equalTo(14.adjustedW)
            $0.leading.equalTo(131.adjustedW)
        }
    }
}

