//
//  CharacterEditView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/4/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CharacterEditView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let characterImageView = UIImageView()
    
    private let itemButton = UIButton().then {
        $0.setTitle("아이템", for: .normal)
        $0.isSelected = true
    }
    
    private let characterButton = UIButton().then {
        $0.setTitle("캐릭터", for: .normal)
    }
    
    private let backgroundButton = UIButton().then {
        $0.setTitle("배경", for: .normal)
    }
    
    private let allItemBackground = UIView().then {
        $0.backgroundColor = .atchWhite
    }
    
    private let itemButtonBottomLine = UIView()
    private let characterButtonBottomLine = UIView()
    private let backgroundButtonBottomLine = UIView()
    
    private let itemBackgroundStackView = UIStackView().then {
        $0.spacing = 6.adjustedW
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }

    private let itemBackgroundOne = UIImageView()
    private let itemBackgroundTwo = UIImageView()
    private let itemBackgroundThree = UIImageView()
    private let itemBackgroundFour = UIImageView()
    private let itemBackgroundFive = UIImageView()
    
    let saveButton = UIImageView().then {
        $0.image = .imgBigButton
        $0.contentMode = .scaleAspectFill
    }
    
    private let saveLabel = UILabel().then {
        $0.text = "저장"
        $0.textColor = .atchBlack
        $0.font = .font(.bigButton)
    }

    init() {
        super.init(frame: .zero)
        
        self.setupStyle()
        self.setupLayout()
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        backgroundButton.addRightBorder(borderColor: .atchShadowGrey, borderWidth: 1)
        
        allItemBackground.addLeftBorder(borderColor: .atchShadowGrey, borderWidth: 1)
        allItemBackground.addRightBorder(borderColor: .atchShadowGrey, borderWidth: 1)
    }
    
    private func setupStyle() {
        [itemButton, characterButton, backgroundButton].forEach {
            $0.layer.borderColor = UIColor.atchShadowGrey.cgColor
            $0.layer.borderWidth = 1
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 12
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.titleLabel?.font = .font(.smallButton)
            $0.backgroundColor = .atchGrey1
            $0.setTitleColor(.atchBlack, for: .selected)
            $0.setTitleColor(.atchGrey4, for: .normal)
        }
        
        [itemButtonBottomLine, characterButtonBottomLine, backgroundButtonBottomLine].forEach {
            $0.backgroundColor = .atchWhite
        }
        
        setInitButtonState()
        
        [itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive].forEach {
            $0.image = .imgItemButtonBackground
            $0.contentMode = .scaleAspectFill
        }
    }
    
    private func setInitButtonState() {
        itemButton.backgroundColor = .atchWhite
        characterButtonBottomLine.isHidden = true
        backgroundButtonBottomLine.isHidden = true
    }

    private func setupLayout() {
        self.addSubviews(characterImageView,
                         allItemBackground,
                         itemButton, characterButton, backgroundButton,
                         itemButtonBottomLine, characterButtonBottomLine, backgroundButtonBottomLine,
                         itemBackgroundStackView,
                         saveButton)
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(233.adjustedW)
            $0.height.equalTo(365.adjustedH)
        }
        
        allItemBackground.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 62)
            $0.height.equalTo(170.adjustedH)
        }
        
        itemButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.height.equalTo(40.adjustedH)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(allItemBackground.snp.top)
        }
        
        itemButtonBottomLine.snp.makeConstraints {
            $0.horizontalEdges.equalTo(itemButton).inset(1)
            $0.bottom.equalTo(itemButton)
            $0.height.equalTo(1)
        }
        
        characterButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.height.equalTo(40.adjustedH)
            $0.leading.equalTo(itemButton.snp.trailing)
            $0.bottom.equalTo(allItemBackground.snp.top)
        }
        
        characterButtonBottomLine.snp.makeConstraints {
            $0.horizontalEdges.equalTo(characterButton).inset(1)
            $0.bottom.equalTo(characterButton)
            $0.height.equalTo(1)
        }
        
        backgroundButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width / 3)
            $0.height.equalTo(40.adjustedH)
            $0.leading.equalTo(characterButton.snp.trailing)
            $0.bottom.equalTo(allItemBackground.snp.top)
        }
        
        backgroundButtonBottomLine.snp.makeConstraints {
            $0.horizontalEdges.equalTo(backgroundButton).inset(1)
            $0.bottom.equalTo(backgroundButton)
            $0.height.equalTo(1)
        }
        
        itemBackgroundStackView.snp.makeConstraints {
            $0.top.equalTo(allItemBackground).offset(20)
            $0.height.equalTo(61)
            $0.centerX.equalToSuperview()
        }
        
        itemBackgroundStackView.addArrangedSubviews(itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive)
        [itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(61)
                $0.height.equalTo(61)
            }
        }
        
        saveButton.snp.makeConstraints {
            $0.width.equalTo(295)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 63 + 19)
        }
        
        saveButton.addSubview(saveLabel)
        saveLabel.snp.makeConstraints {
            $0.top.equalTo(14.adjustedW)
            $0.leading.equalTo(131.adjustedW)
        }
    }
    
    private func setupButton() {
        setupButton(itemButton,
                    selectedBackground: .atchWhite,
                    otherButtons: [characterButton, backgroundButton],
                    bottomLine: itemButtonBottomLine,
                    otherBottomLines: [characterButtonBottomLine, backgroundButtonBottomLine])
        
        setupButton(characterButton,
                    selectedBackground: .atchWhite,
                    otherButtons: [itemButton, backgroundButton],
                    bottomLine: characterButtonBottomLine,
                    otherBottomLines: [itemButtonBottomLine, backgroundButtonBottomLine])
        
        setupButton(backgroundButton,
                    selectedBackground: .atchWhite,
                    otherButtons: [itemButton, characterButton],
                    bottomLine: backgroundButtonBottomLine,
                    otherBottomLines: [itemButtonBottomLine, characterButtonBottomLine])
    }

    private func setupButton(_ button: UIButton, selectedBackground: UIColor, otherButtons: [UIButton], bottomLine: UIView, otherBottomLines: [UIView]) {
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                
                // 현재 버튼 설정
                button.backgroundColor = selectedBackground
                button.isSelected = true
                bottomLine.isHidden = false
                
                // 나머지 버튼 비활성화 설정
                otherButtons.forEach { otherButton in
                    otherButton.backgroundColor = .atchGrey1
                    otherButton.isSelected = false
                }
                otherBottomLines.forEach { otherBottomLine in
                    otherBottomLine.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }

}
