//
//  MyChatCollectionViewCell.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MyChatCollectionViewCell: UICollectionViewCell {

    private let backgoundImageView = UIImageView().then {
        $0.image = .imgChatCellBackground
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.headline)
        $0.numberOfLines = 0
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.subtitle)
        $0.numberOfLines = 1
    }
    
    private let tagLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.body)
        $0.numberOfLines = 0
    }
    
    private let chatButtonImageView = UIImageView().then {
        $0.image = .imgButtonBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let chatButtonLabel = UILabel().then {
        $0.text = "채팅하기"
        $0.textColor = .atchBlack
        $0.font = .font(.smallButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImageView.image = nil
    }
   
    private func setupLayout() {
        self.contentView.addSubview(backgoundImageView)
        backgoundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStackView.addArrangedSubviews(titleLabel, contentLabel)

        backgoundImageView.addSubviews(dividingLine,
                                       characterImageView,
                                       labelStackView,
                                       tagLabel,
                                       chatButtonImageView)
    
        dividingLine.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(108 * (UIScreen.main.bounds.width - 21 - 19) / 335)
            $0.width.equalTo(1)
        }
        
        characterImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(4)
            $0.trailing.equalTo(dividingLine.snp.leading)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalTo(dividingLine.snp.trailing).offset(13)
            $0.width.equalTo(198)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(18)
            $0.leading.equalTo(labelStackView)
            $0.width.equalTo(116)
        }
        
        chatButtonImageView.snp.makeConstraints {
            $0.width.equalTo(79)
            $0.height.equalTo(37)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        chatButtonImageView.addSubview(chatButtonLabel)
        chatButtonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(14)
        }
    }
    
    func bindCell(model: MyChatData) {
        if let url = URL(string: model.characterUrl) {
            characterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = model.nickName
        contentLabel.text = model.content
                
        let hashtags = model.tag
        let words = hashtags.split(separator: " ").map { String($0) }
        
        let lineLength = 13
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
        
        tagLabel.text = resultText
    }
}
