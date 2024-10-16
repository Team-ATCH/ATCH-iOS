//
//  MyPageView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class MyPageView: UIView {
    
    private let myProfileStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let myProfileTitle = UILabel().then {
        $0.text = "내 프로필"
        $0.textColor = .atchBlack2
        $0.font = .font(.title2)
    }
    let profileEditView = SettingCell(titleText: "프로필 수정", buttonHidden: false)
    let characterEditView = SettingCell(titleText: "캐릭터 꾸미기", buttonHidden: false)
    
    private let accountStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .leading
    }
    
    private let accountTitle = UILabel().then {
        $0.text = "계정 관리"
        $0.textColor = .atchBlack2
        $0.font = .font(.title2)
    }
    let logoutView = SettingCell(titleText: "로그아웃", buttonHidden: true)
    let inquireView = SettingCell(titleText: "문의", buttonHidden: true)
    let withdrawView = SettingCell(titleText: "계정 탈퇴", buttonHidden: true)
    
    init() {
        super.init(frame: .zero)
        
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        self.addSubviews(myProfileStackView, 
                         accountStackView)
        
        myProfileStackView.addArrangedSubviews(myProfileTitle,
                                               profileEditView,
                                               characterEditView)
        myProfileStackView.setCustomSpacing(12, after: myProfileTitle)
        
        accountStackView.addArrangedSubviews(accountTitle,
                                             logoutView,
                                             inquireView,
                                             withdrawView)
        accountStackView.setCustomSpacing(12, after: accountTitle)

        
        myProfileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        
        [profileEditView, characterEditView, logoutView, inquireView, withdrawView].forEach {
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
                $0.height.equalTo(54.adjustedH)
            }
        }
        
        accountStackView.snp.makeConstraints {
            $0.top.equalTo(myProfileStackView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(40)
        }
        
        
    }
}
