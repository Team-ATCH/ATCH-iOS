//
//  MapBottomView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/30/24.
//

import UIKit

import SnapKit
import Then

final class MapBottomView: UIView {
    
    // MARK: - UI Components
    
    let bottomSheetBar = UIImageView()
    
    // MARK: - Life Cycle
    
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
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setLayout() {
        self.addSubviews(bottomSheetBar)
                
        bottomSheetBar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(5)
        }
    }
}
