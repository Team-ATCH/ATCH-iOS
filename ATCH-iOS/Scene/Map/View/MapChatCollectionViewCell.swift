//
//  MapChatCollectionViewCell.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/31/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MapChatCollectionViewCell: UICollectionViewCell {

    private let characterWidth: Double = 89.0
    private let characterHeight: Double = 139.0
    
    private let backgoundImageView = UIImageView().then {
        $0.image = .imgMapCellBackground
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
    private let characterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let itemImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
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

        backgoundImageView.addSubviews(characterImageView,
                                       itemImageView,
                                       labelStackView,
                                       chatButtonImageView)
        
        characterImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(13)
            $0.width.equalTo(characterWidth)
            $0.height.equalTo(characterHeight)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(80)
        }
        
        chatButtonImageView.snp.makeConstraints {
            $0.width.equalTo(79)
            $0.height.equalTo(37)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        chatButtonImageView.addSubview(chatButtonLabel)
        chatButtonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7.adjustedH)
            $0.leading.equalToSuperview().inset(14.adjustedW)
        }
    }
    
    func bindCell(model: MapChatData) {
        if let url = URL(string: model.characterUrl) {
            characterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = model.nickName
        
        let hashtags = model.tag
        let words = hashtags.split(separator: " ").map { String($0) }
        
        let lineLength = 9
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
        
        contentLabel.text = resultText
        
        model.items.forEach { [weak self] item in
            guard let self else { return }
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let url = URL(string: item.itemImageURL) {
                imageView.kf.setImage(with: url)
            }
            
            characterImageView.addSubview(imageView)
            
            let leadingInset = item.slotX * characterWidth / StandardSize.width.rawValue
            let topInset = item.slotY * characterHeight / StandardSize.height.rawValue
            
            imageView.snp.makeConstraints {
                $0.width.equalTo(22)
                $0.height.equalTo(20)
                $0.leading.equalToSuperview().inset(leadingInset)
                $0.top.equalToSuperview().inset(topInset)
            }
        }
    }
}
