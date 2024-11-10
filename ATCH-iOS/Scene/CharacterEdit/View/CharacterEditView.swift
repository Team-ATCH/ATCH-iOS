//
//  CharacterEditView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/4/24.
//

import UIKit

import Kingfisher
import RxSwift
import SnapKit
import Then

final class CharacterEditView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let characterWidth: Double = 233.adjustedW
    private let characterHeight: Double = 365.adjustedH
    
    private var userCharacters: [CharacterData] = [] // 전체 캐릭터
    private var userItems: [MyPageUserItem] = [] // 전체 아이템
    private var userBackgrounds: [BackgroundData] = [] // 전체 배경

    private var currentCharacterID: Int = 0 // 지금 착용하고 있는 캐릭터
    private var currentItemIDs: [Int?] = [nil] // 지금 착용하고 있는 아이템
    private var currentBackgroundID: Int = 0 // 지금 착용하고 있는 배경
    
    private var selectingItem: Bool = false // 아이템 고르는 중
    private var selectingCharacter: Bool = false // 캐릭터 고르는 중
    private var selectingBackground: Bool = false // 배경 고르는 중
    
    var selectedItems: [SelectedItemData] = []
    
    private let characterImageView = UIImageView()
    private let characterBackgroundImageView = UIImageView()

    let itemButton = UIButton().then {
        $0.setTitle("아이템", for: .normal)
        $0.isSelected = true
    }
    
    let characterButton = UIButton().then {
        $0.setTitle("캐릭터", for: .normal)
    }
    
    let backgroundButton = UIButton().then {
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
    
    func bindItemData(data: ItemData, inUseIDs: [Int?]) {
        userItems = data.items
        
        currentCharacterID = data.characterID
        currentItemIDs =  inUseIDs
        
        if let url = URL(string: data.characterImageURL) {
            characterImageView.kf.setImage(with: url)
        }
                
        data.items.forEach { [weak self] item in
            guard let self else { return }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let url = URL(string: item.itemImageURL) {
                imageView.kf.setImage(with: url)
            }
            
            let leadingInset = item.slotX * characterWidth / StandardSize.width.rawValue
            let topInset = item.slotY * characterHeight / StandardSize.height.rawValue
            
            if currentItemIDs.contains(item.itemID) {
                characterImageView.addSubview(imageView)
            
                imageView.snp.makeConstraints {
                    $0.width.equalTo(58)
                    $0.height.equalTo(52)
                    $0.leading.equalToSuperview().inset(leadingInset)
                    $0.top.equalToSuperview().inset(topInset)
                }
            }
        }
        
        setImageToItem()
    }
    
    func bindCharacterData(data: [CharacterData]) {
        userCharacters = data
    }
    
    func bindBackgroundData(data: [BackgroundData], inUseID: Int) {
        userBackgrounds = data
        currentBackgroundID = inUseID
        
        if let index = userBackgrounds.firstIndex(where: { $0.itemID == currentBackgroundID }),
           let url = URL(string: userBackgrounds[index].itemProfileImageURL) {
            characterBackgroundImageView.kf.setImage(with: url)
        }
        
    }
    
    func setImageToItem() {
        let itemBackgrounds = [itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive]
        itemBackgrounds.forEach {
            $0.removeAllSubViews()
        }
        
        for (index, item) in userItems.enumerated() {
            guard index < itemBackgrounds.count else { break }

            let itemImageView = UIImageView()
            itemImageView.contentMode = .scaleAspectFit

            if let url = URL(string: item.itemImageURL) {
                itemImageView.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor(cornerRadius: 20)), .transition(.fade(0.2))]) { 
                    [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let value):
                        itemImageView.image = value.image.withRenderingMode(.alwaysOriginal)
                        if !currentItemIDs.contains(item.itemID) {
                            itemImageView.alpha = 0.4
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }

            itemBackgrounds[index].addSubview(itemImageView)
            
            itemImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(9)
                $0.size.equalTo(40)
            }
        }
    }
    
    func setImageToCharacter() {
        let itemBackgrounds = [itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive]
        itemBackgrounds.forEach {
            $0.removeAllSubViews()
        }
        
        for (index, data) in userCharacters.enumerated() {
            guard index < itemBackgrounds.count else { break }

            let itemImageView = UIImageView()
            itemImageView.contentMode = .scaleAspectFit

            if let url = URL(string: data.imageURL) {
                itemImageView.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor(cornerRadius: 20)), .transition(.fade(0.2))])
                { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let value):
                        itemImageView.image = value.image.withRenderingMode(.alwaysOriginal)
                        if data.characterID != currentCharacterID {
                            itemImageView.alpha = 0.4
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }

            itemBackgrounds[index].addSubview(itemImageView)
            
            itemImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(9)
                $0.size.equalTo(40)
            }
        }
    }
    
    func setImageToBackground() {
        let itemBackgrounds = [itemBackgroundOne, itemBackgroundTwo, itemBackgroundThree, itemBackgroundFour, itemBackgroundFive]
        itemBackgrounds.forEach {
            $0.removeAllSubViews()
        }
        
        for (index, data) in userBackgrounds.enumerated() {
            guard index < itemBackgrounds.count else { break }

            let itemImageView = UIImageView()
            itemImageView.contentMode = .scaleAspectFit

            if let url = URL(string: data.itemImageURL) {
                itemImageView.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor(cornerRadius: 20)), .transition(.fade(0.2))]) 
                { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let value):
                        itemImageView.image = value.image.withRenderingMode(.alwaysOriginal)
                        if data.itemID != currentBackgroundID {
                            itemImageView.alpha = 0.4
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }

            itemBackgrounds[index].addSubview(itemImageView)
            
            itemImageView.snp.makeConstraints {
                $0.top.leading.equalToSuperview().inset(9)
                $0.size.equalTo(40)
            }
        }
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
        self.addSubviews(characterBackgroundImageView,
                         characterImageView,
                         allItemBackground,
                         itemButton, characterButton, backgroundButton,
                         itemButtonBottomLine, characterButtonBottomLine, backgroundButtonBottomLine,
                         itemBackgroundStackView,
                         saveButton)
        
        characterBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(characterWidth)
            $0.height.equalTo(characterHeight)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(characterWidth)
            $0.height.equalTo(characterHeight)
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
