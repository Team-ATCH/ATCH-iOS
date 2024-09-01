//
//  MyChatView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import SnapKit
import Then

final class MyChatView: UIView {
    
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.itemSize = .init(width: UIScreen.main.bounds.width - 21 - 19, height: 119 * (UIScreen.main.bounds.width - 21 - 19) / 335)
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: 13, left: 21, bottom: 13, right: 19)
    }
    
    lazy var chatCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(MyChatCollectionViewCell.self, forCellWithReuseIdentifier: MyChatCollectionViewCell.reuseIdentifier)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubviews(chatCollectionView)
                
        chatCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
