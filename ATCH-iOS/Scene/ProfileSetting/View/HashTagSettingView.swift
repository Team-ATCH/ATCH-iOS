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
    
    var canGoNext: Bool = false
    
    var hashTagArray: [HashTag] = []

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 48
    }
    
    private let allHashTagStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 6
    }

    private let hashTagStackViewOne = UIStackView()
    private let hashTagStackViewTwo = UIStackView()
    private let hashTagStackViewThree = UIStackView()
    private let hashTagStackViewFour = UIStackView()
    private let hashTagStackViewFive = UIStackView()
    
    private let hashTagLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "해시태그를 골라 내 관심사와\n스타일을 소개해 보세요."
        $0.textAlignment = .center
        $0.textColor = .atchBlack
        $0.font = .font(.title3)
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
        
        self.setupHashTagStackView()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setupHashTagStackView() {
        [hashTagStackViewOne, hashTagStackViewTwo, hashTagStackViewThree, hashTagStackViewFour, hashTagStackViewFive].forEach {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fill
            $0.spacing = 4
        }
        
        let hashTags = HashTag.allCases
       
        hashTags[0...3].enumerated().forEach { [weak self] index, hashTag in
            guard let self else { return }
            let button = createButton(hashTag: hashTag, index: index)
            hashTagStackViewOne.addArrangedSubview(button)
        }
        
        hashTags[4...7].enumerated().forEach { [weak self] index, hashTag in
            guard let self else { return }
            let adjustedIndex = index + 4
            let button = createButton(hashTag: hashTag, index: adjustedIndex)
            hashTagStackViewTwo.addArrangedSubview(button)
        }
        
        hashTags[8...11].enumerated().forEach { [weak self] index, hashTag in
            guard let self else { return }
            let adjustedIndex = index + 8
            let button = createButton(hashTag: hashTag, index: adjustedIndex)
            hashTagStackViewThree.addArrangedSubview(button)
        }
        
        hashTags[12...14].enumerated().forEach { [weak self] index, hashTag in
            guard let self else { return }
            let adjustedIndex = index + 12
            let button = createButton(hashTag: hashTag, index: adjustedIndex)
            hashTagStackViewFour.addArrangedSubview(button)
        }
        
        hashTags[15...17].enumerated().forEach { [weak self] index, hashTag in
            guard let self else { return }
            let adjustedIndex = index + 15
            let button = createButton(hashTag: hashTag, index: adjustedIndex)
            hashTagStackViewFive.addArrangedSubview(button)
        }
    }
    
    private func createButton(hashTag: HashTag, index: Int) -> UIImageView {
        let buttonImageView = UIImageView()
        buttonImageView.image = hashTag.hashTagDeSelectedImage
        buttonImageView.contentMode = .scaleAspectFill
        buttonImageView.tag = index
        buttonImageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hashTagButtonTapped(_:)))
        buttonImageView.addGestureRecognizer(tapGesture)
        
        buttonImageView.snp.makeConstraints {
            $0.width.equalTo(hashTag.hashTagWitdh)
            $0.height.equalTo(37)
        }
        
        let buttonLabel = UILabel()
        buttonLabel.text = hashTag.hashTagTitle
        buttonLabel.textColor = .atchBlack
        buttonLabel.font = .font(.smallButton)
        
        buttonImageView.addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(14)
        }
        
        return buttonImageView
    }
    
    @objc 
    private func hashTagButtonTapped(_ sender: UITapGestureRecognizer) {
        if let tappedButton = sender.view as? UIImageView {
            let index = tappedButton.tag
            let hashTag = HashTag.allCases[index] // 탭된 해시태그 가져옴
    
            // 이미지 변경 처리
            let isSelected = tappedButton.image == hashTag.hashTagDeSelectedImage
            tappedButton.image = isSelected ? hashTag.hashTagSelectedImage : hashTag.hashTagDeSelectedImage
            
            makeHashTagArray(hashTag: hashTag, isSelected: isSelected)
        }
    }

    private func makeHashTagArray(hashTag: HashTag, isSelected: Bool) {
        if isSelected {
            hashTagArray.append(hashTag)
        } else {
            hashTagArray.removeAll { $0 == hashTag }
        }
                
        if hashTagArray.isEmpty {
            nextButton.image = .imgBigDisableButton
            nextLabel.textColor = .atchGrey3
            canGoNext = false
        } else {
            nextButton.image = .imgBigButton
            nextLabel.textColor = .atchBlack
            canGoNext = true
            UserData.shared.hashTag = hashTagArray
        }
    }
    
    private func setupLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(hashTagLabel,
                                      allHashTagStackView,
                                      nextButton)
        
        allHashTagStackView.addArrangedSubviews(hashTagStackViewOne,
                                                hashTagStackViewTwo,
                                                hashTagStackViewThree,
                                                hashTagStackViewFour,
                                                hashTagStackViewFive)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0) + 133)
            $0.leading.equalToSuperview().inset(39)
            $0.trailing.equalToSuperview().inset(41)
        }
        
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
}
