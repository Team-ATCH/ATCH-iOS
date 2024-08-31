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
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let chatButtonImageView = UIImageView().then {
        $0.image = .imgButtonBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let chatButtonLabel = UILabel().then {
        $0.text = "채팅하기"
        $0.textColor = .atchShadowGrey
        $0.font = .font(.smallButton)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterImageView.image = nil
    }
   
    private func setLayout() {
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
            $0.width.equalTo(89)
            $0.height.equalTo(139)
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
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(14)
        }
    }
    
    func bindCell(model: MapChatData) {
        if let url = URL(string: model.characterUrl) {
            characterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = model.nickName
        contentLabel.text = model.tag
    }
}