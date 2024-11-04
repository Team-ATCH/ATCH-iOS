//
//  CharacterEditView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 11/4/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CharacterEditView: UIView {
    
    private let characterImageView = UIImageView()
    
    private let itemButton = UIButton().then {
        $0.setTitle("아이템", for: .normal)
        $0.isSelected = true
    }
    
    private let characterButton = UIButton().then {
        $0.setTitle("캐릭터", for: .normal)
    }
    
    private let backgroundButton = UIButton().then {
        $0.setTitle("배경", for: .normal)
    }

    init() {
        super.init(frame: .zero)
        
        self.setupStyle()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupStyle() {
        [itemButton, characterButton, backgroundButton].forEach {
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.atchShadowGrey.cgColor
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .font(.smallButton)
            $0.backgroundColor = .atchGrey1
            $0.setTitleColor(.atchBlack, for: .selected)
            $0.setTitleColor(.atchGrey4, for: .normal)
        }
    }
    
    private func setupLayout() {
       
    }
}
