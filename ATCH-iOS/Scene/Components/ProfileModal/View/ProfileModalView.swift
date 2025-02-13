//
//  ProfileModalView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/13/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class ProfileModalView: UIView {

    private let characterWidth: Double = 178.adjustedW
    private let characterHeight: Double = 278.adjustedW
    
    private let dimView = UIView().then {
        $0.backgroundColor = .atchBlack
        $0.alpha = 0.4
    }
    
    private let modalBackground = UIImageView().then {
        $0.image = .imgProfileModalBackground
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    let closeButton = UIButton().then {
        $0.setImage(.icClose, for: .normal)
    }
    
    private let profileNicknameLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.title2)
    }
    
    private let profileHashTagLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.smallButton)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private let profileBackgroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    let bottomButton = UIImageView().then {
        $0.image = .imgMediumButton
        $0.contentMode = .scaleAspectFill
    }
    
    private let profileEditLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.bigButton)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func bindViewData(data: ProfileModalData) {
        profileNicknameLabel.text = data.nickname
        profileHashTagLabel.text = data.hashTag
        setupHashTag()
        if let profileURL = data.profileURL,
           let url = URL(string: profileURL) {
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UserData.shared.characterImage()
        }
        
        if let backgroundURL = data.backgroundURL,
           let url = URL(string: backgroundURL) {
            profileBackgroundImageView.kf.setImage(with: url)
        }
        
        profileEditLabel.text = data.buttonString
        
        data.items?.forEach { [weak self] item in
            guard let self else { return }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let url = URL(string: item.itemImageURL) {
                imageView.kf.setImage(with: url)
            }
            
            profileImageView.addSubview(imageView)
            
            let leadingInset = item.slotX * characterWidth / StandardSize.width.rawValue
            let topInset = item.slotY * characterHeight / StandardSize.height.rawValue
            
            imageView.snp.makeConstraints {
                $0.size.equalTo(40)
                $0.leading.equalToSuperview().inset(leadingInset)
                $0.top.equalToSuperview().inset(topInset)
            }
        }
    }
    
    private func setupHashTag() {
        if let hashtags = profileHashTagLabel.text {
            let words = hashtags.split(separator: " ").map { String($0) }
            
            let lineLength = 11
            var resultText = ""
            var currentLine = ""
            
            for word in words {
                if (currentLine + " " + word).count > lineLength {
                    resultText += currentLine.trimmingCharacters(in: .whitespaces) + "\n"
                    currentLine = word
                } else {
                    currentLine += (currentLine.isEmpty ? "" : " ") + word
                }
            }
            
            resultText += currentLine
            
            profileHashTagLabel.text = resultText
        }
    }
    
    private func setupLayout() {
        self.addSubviews(dimView,
                         modalBackground)
        
        modalBackground.addSubviews(closeButton,
                                    profileNicknameLabel,
                                    profileHashTagLabel,
                                    profileBackgroundImageView,
                                    profileImageView,
                                    bottomButton)
        
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        modalBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(110.adjustedH)
            $0.width.equalTo(263.adjustedW)
            $0.height.equalTo(464.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        profileNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
        }
        
        profileHashTagLabel.snp.makeConstraints {
            $0.top.equalTo(profileNicknameLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
        }
            
        bottomButton.snp.makeConstraints {
            $0.width.equalTo(231)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        bottomButton.addSubview(profileEditLabel)
        profileEditLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        profileBackgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.width.equalTo(characterWidth)
            $0.height.equalTo(characterHeight)
            $0.centerX.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(115)
            $0.width.equalTo(characterWidth)
            $0.height.equalTo(characterHeight)
            $0.centerX.equalToSuperview()
        }
    }
}

