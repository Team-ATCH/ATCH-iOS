//
//  HashTagStackView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class HashTagStackView: UIStackView {
    
    var hashTagArray: [HashTag] = []
    
    let hashTagStackViewOne = UIStackView()
    let hashTagStackViewTwo = UIStackView()
    let hashTagStackViewThree = UIStackView()
    let hashTagStackViewFour = UIStackView()
    let hashTagStackViewFive = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        self.setupStyle()
        self.setupLayout()
        self.initializeSelectedTags()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        self.axis = .vertical
        self.alignment = .center
        self.distribution = .fill
        self.spacing = 6

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
            $0.top.equalToSuperview().inset(7.adjustedH)
            $0.leading.equalToSuperview().inset(14.adjustedW)
        }
        
        return buttonImageView
    }
    
    private func initializeSelectedTags() {
        // 이미 저장된 해시태그 불러오기
        let savedTags = UserData.shared.hashTagRelay.value
        
        // 저장된 해시태그들을 찾아 선택된 상태로 설정
        for (index, hashTag) in HashTag.allCases.enumerated() {
            guard let button = findButtonWithTag(index) else { continue }
            if savedTags.contains(hashTag) {
                button.image = hashTag.hashTagSelectedImage
                hashTagArray.append(hashTag)
            }
        }
        
        // hashTagArray 초기 상태를 UserData에 반영
        UserData.shared.hashTagRelay.accept(hashTagArray)
    }

    private func findButtonWithTag(_ tag: Int) -> UIImageView? {
        // 모든 UIStackView에서 해당 태그를 가진 버튼을 찾기
        for stackView in [hashTagStackViewOne, hashTagStackViewTwo, hashTagStackViewThree, hashTagStackViewFour, hashTagStackViewFive] {
            for case let button as UIImageView in stackView.arrangedSubviews {
                if button.tag == tag {
                    return button
                }
            }
        }
        return nil
    }

    @objc
    private func hashTagButtonTapped(_ sender: UITapGestureRecognizer) {
        if let tappedButton = sender.view as? UIImageView {
            let index = tappedButton.tag
            let hashTag = HashTag.allCases[index]
    
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
        
        UserData.shared.hashTagRelay.accept(hashTagArray)
    }
    
    private func setupLayout() {
        self.addArrangedSubviews(hashTagStackViewOne,
                                 hashTagStackViewTwo,
                                 hashTagStackViewThree,
                                 hashTagStackViewFour,
                                 hashTagStackViewFive)
    }
}
