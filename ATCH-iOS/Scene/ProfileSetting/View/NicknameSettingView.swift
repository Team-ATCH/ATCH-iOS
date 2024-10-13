//
//  NicknameSettingView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class NicknameSettingView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
    }
    
    private let characterImageView = UIImageView().then {
        $0.image = UserData.shared.characterImage()
        $0.contentMode = .scaleAspectFill
    }
    
    private let nicknameLabel = UILabel().then {
        $0.text = "어울리는 닉네임을 지어주세요."
        $0.textColor = .atchBlack
        $0.font = .font(.bigButton)
    }
    
    private let nicknameSettingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
        $0.spacing = 8
    }
    
    private let nicknameTitleLabel = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .atchBlack
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
    
    let nextButton = UIImageView().then {
        $0.image = .imgBigDisableButton
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
    }
    
    private let nextLabel = UILabel().then {
        $0.text = "다음"
        $0.textColor = .atchGrey3
        $0.font = .font(.bigButton)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
        self.setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(characterImageView,
                                      nicknameLabel,
                                      nicknameSettingStackView,
                                      nextButton)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0) + 72)
            $0.leading.equalToSuperview().inset(39)
            $0.trailing.equalToSuperview().inset(41)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(89)
            $0.height.equalTo(139)
        }
        
        stackView.setCustomSpacing(16, after: characterImageView)
        stackView.setCustomSpacing(48, after: nicknameLabel)

        nicknameSettingStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        nicknameSettingStackView.addArrangedSubviews(nicknameTitleLabel,
                                                     nicknameTextFiled,
                                                     nicknameUnderLine)
        
        nicknameTextFiled.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        nicknameUnderLine.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        stackView.setCustomSpacing(32, after: nicknameSettingStackView)
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        nextButton.addSubview(nextLabel)
        nextLabel.snp.makeConstraints {
            $0.top.equalTo(14.adjustedW)
            $0.leading.equalTo(131.adjustedW)
        }

    }
    
    private func setupAction() {
        nicknameTextFiled.rx.text.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { view, text in
                if let changedText = text {
                    if changedText.count > 0 && changedText.count < 11 {
                        view.nextButton.image = .imgBigButton
                        view.nextButton.isUserInteractionEnabled = true
                        view.nextLabel.textColor = .atchBlack
                        UserData.shared.nickname = changedText
                    } else {
                        view.nextButton.image = .imgBigDisableButton
                        view.nextButton.isUserInteractionEnabled = false
                        view.nextLabel.textColor = .atchGrey3
                    }
                }
            }).disposed(by: disposeBag)
    }
    
}
