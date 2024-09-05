//
//  AlarmView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/5/24.
//

import UIKit

import SnapKit
import Then

final class AlarmView: UIView {
    
    let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.minimumLineSpacing = 8
        $0.sectionInset = .init(top: 15, left: 19, bottom: 15, right: 18)
    }
    
    lazy var alarmCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout).then {
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = .zero
        $0.backgroundColor = .clear
        $0.clipsToBounds = true
        $0.register(AlarmCollectionViewCell.self, forCellWithReuseIdentifier: AlarmCollectionViewCell.reuseIdentifier)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubviews(alarmCollectionView)
                
        alarmCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
