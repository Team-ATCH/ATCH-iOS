//
//  MapBottomSheetView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/30/24.
//

import UIKit

import SnapKit
import Then

final class MapBottomSheetView: UIView {
        
    private let bottomSheetBar = UIImageView().then {
        $0.image = .icBottomSheetBar
        $0.contentMode = .scaleAspectFill
    }
    
    private let bottomTitleLabel = UILabel().then {
        $0.text = "주변의 사용자에게\n채팅을 보내 보세요."
        $0.numberOfLines = 0
        $0.textColor = .atchBlack
        $0.font = .font(.title)
    }
    
    private let onMapIconImageView = UIImageView().then {
        $0.image = .icOnMap
        $0.contentMode = .scaleAspectFill
    }
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = .init(width: 208, height: 167)
        $0.minimumInteritemSpacing = 12
        $0.minimumLineSpacing = 12
        $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    lazy var chatCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(MapChatCollectionViewCell.self, forCellWithReuseIdentifier: MapChatCollectionViewCell.reuseIdentifier)
    }
        
    init() {
        super.init(frame: .zero)
        
        self.setStyle()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setStyle() {
        self.backgroundColor = .atchYellow
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.atchShadowGrey.cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setLayout() {
        self.addSubviews(bottomSheetBar,
                         bottomTitleLabel,
                         onMapIconImageView,
                         chatCollectionView)
                
        bottomSheetBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(5)
        }
        
        bottomTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(20)
        }
        
        onMapIconImageView.snp.makeConstraints {
            $0.width.equalTo(22)
            $0.height.equalTo(25)
            $0.leading.equalTo(bottomTitleLabel.snp.trailing).offset(6)
            $0.bottom.equalTo(bottomTitleLabel)
        }
        
        chatCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(105)
            $0.bottom.equalToSuperview().inset(17)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}
