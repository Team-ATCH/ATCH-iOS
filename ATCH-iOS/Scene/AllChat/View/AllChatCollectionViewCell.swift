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
    
    private let topLabelStackView = UIStackView().then {
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
    
    private let bottomLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    private let lastTimeLabel = UILabel().then {
        $0.text = "마지막 채팅시간"
        $0.textColor = .atchBlack
        $0.font = .font(.body)
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .atchShadowGrey
        $0.font = .font(.body)
    }
    
    private let chatButtonImageView = UIImageView().then {
        $0.image = .imgButtonBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let chatButtonLabel = UILabel().then {
        $0.text = "보러가기"
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

    private func setupLayout() {
        self.contentView.addSubview(backgoundImageView)
        backgoundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topLabelStackView.addArrangedSubviews(titleLabel, contentLabel)
        bottomLabelStackView.addArrangedSubviews(lastTimeLabel, timeLabel)
        
        backgoundImageView.addSubviews(topLabelStackView,
                                       bottomLabelStackView,
                                       chatButtonImageView)
    
     
        topLabelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(198)
        }
        
        bottomLabelStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(30)
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
    
    func bindCell(model: AllChattingData) {
        titleLabel.text = model.fromNickname
        contentLabel.text = model.content

        timeLabel.text = model.createdAt.toSeoulDateString() ?? ""
    }
}
