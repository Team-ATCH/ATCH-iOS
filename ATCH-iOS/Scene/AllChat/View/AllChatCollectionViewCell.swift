//
//  AllChatCollectionViewCell.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/9/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class AllChatCollectionViewCell: UICollectionViewCell {

    private let backgoundImageView = UIImageView().then {
        $0.image = .imgChatCellBackground
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    private let firstCharacterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    private let secondCharacterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = true
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    private let profileDividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    private let dividingLine = UIView().then {
        $0.backgroundColor = .atchShadowGrey
    }
    
    private let contentLabel = UILabel().then {
        $0.textColor = .atchBlack
        $0.font = .font(.headline)
        $0.numberOfLines = 0
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 1
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    private let participantLabel = UILabel().then {
        $0.textColor = .atchGrey3
        $0.font = .font(.caption)
        $0.text = "채팅 참여자"
    }
    
    private let firstParticipantLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.body)
        $0.numberOfLines = 1
    }
    
    private let secondParticipantLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.body)
        $0.numberOfLines = 1
    }
    
    private let chatButtonImageView = UIImageView().then {
        $0.image = .imgButtonBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let chatButtonLabel = UILabel().then {
        $0.text = "채팅 보기"
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
        
        firstCharacterImageView.image = nil
        secondCharacterImageView.image = nil
    }
   
    private func setupLayout() {
        self.contentView.addSubview(backgoundImageView)
        backgoundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStackView.addArrangedSubviews(participantLabel, firstParticipantLabel, secondParticipantLabel)

        backgoundImageView.addSubviews(dividingLine,
                                       profileDividingLine,
                                       firstCharacterImageView,
                                       secondCharacterImageView,
                                       contentLabel,
                                       labelStackView,
                                       chatButtonImageView)
    
        dividingLine.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(108 * (UIScreen.main.bounds.width - 21 - 19) / 335)
            $0.width.equalTo(1)
        }
        
        profileDividingLine.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(54 * (UIScreen.main.bounds.width - 21 - 19) / 335)
            $0.width.equalTo(1)
        }
        
        firstCharacterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(3)
            $0.leading.equalToSuperview().inset(1)
            $0.trailing.equalTo(profileDividingLine.snp.leading)
        }
        
        secondCharacterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(3)
            $0.leading.equalTo(profileDividingLine.snp.trailing)
            $0.trailing.equalTo(dividingLine.snp.leading)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalTo(dividingLine.snp.trailing).offset(13)
            $0.width.equalTo(198)
            $0.height.equalTo(42)
        }
        
        labelStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13)
            $0.leading.equalTo(dividingLine.snp.trailing).offset(13)
            $0.width.equalTo(198)
        }
        
        chatButtonImageView.snp.makeConstraints {
            $0.width.equalTo(79)
            $0.height.equalTo(37)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(13)
        }
        
        chatButtonImageView.addSubview(chatButtonLabel)
        chatButtonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7.adjustedH)
            $0.leading.equalToSuperview().inset(12.adjustedW)
        }
    }
    
    func bindCell(model: AllChattingData) {
        if let url = URL(string: model.firstProfileURL) {
            firstCharacterImageView.kf.setImage(with: url)
        }
        
        if let url = URL(string: model.secondProfileURL) {
            secondCharacterImageView.kf.setImage(with: url)
        }
        
        contentLabel.text = model.content
                
        firstParticipantLabel.text = model.firstFromNickname
        secondParticipantLabel.text = model.secondFromNickname
    }
}
