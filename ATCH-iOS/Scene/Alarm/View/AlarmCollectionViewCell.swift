//
//  AlarmCollectionViewCell.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class AlarmCollectionViewCell: UICollectionViewCell {

    private let backgoundImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
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
    
    private let itemGetButtonImageView = UIImageView().then {
        $0.image = .imgButtonBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private let itemGetButtonLabel = UILabel().then {
        $0.text = "아이템 받기"
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
        
    }
   
    private func setupLayout() {
        self.contentView.addSubview(backgoundImageView)
        backgoundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        labelStackView.addArrangedSubviews(titleLabel, contentLabel)

        backgoundImageView.addSubviews(labelStackView,
                                       itemGetButtonImageView)
        
        labelStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(21)
        }
        
        itemGetButtonImageView.snp.makeConstraints {
            $0.width.equalTo(94)
            $0.height.equalTo(37)
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(19)
        }
        
        itemGetButtonImageView.addSubview(itemGetButtonLabel)
        itemGetButtonLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.leading.equalToSuperview().inset(14)
        }
    }
    
    func bindCell(model: AlarmData) {
        switch model.type {
        case .item:
            backgoundImageView.image = .imgAlarmLongCellBackground
            itemGetButtonImageView.isHidden = false
        case .notice:
            backgoundImageView.image = .imgAlarmShortCellBackground
            itemGetButtonImageView.isHidden = true
        }
            
        titleLabel.text = model.title
        contentLabel.text = model.content
    }
}
