//
//  HashTagSettingView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/13/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class HashTagSettingView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    var canGoNext: Bool = false
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 48
    }
    
    private let allHashTagStackView = HashTagStackView()
    
    private let hashTagLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "해시태그를 골라 내 관심사와\n스타일을 소개해 보세요."
        $0.textAlignment = .center
        $0.textColor = .atchBlack
        $0.font = .font(.title3)
    }
    
    let nextButton = UIImageView().then {
        $0.image = .imgBigDisableButton
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = false
    }
    
    private let nextLabel = UILabel().then {
        $0.text = "다음"
        $0.textColor = .atchGrey3
        $0.font = .font(.bigButton)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupHashTag()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupHashTag() {
        UserData.shared.hashTagRelay
            .withUnretained(self)
            .subscribe(onNext: { view, value in
                if value.isEmpty {
                    view.nextButton.image = .imgBigDisableButton
                    view.nextLabel.textColor = .atchGrey3
                    view.canGoNext = false
                } else {
                    view.nextButton.image = .imgBigButton
                    view.nextLabel.textColor = .atchBlack
                    view.canGoNext = true
                }
            }).disposed(by: disposeBag)
       
    }
    
    private func setupLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(hashTagLabel,
                                      allHashTagStackView,
                                      nextButton)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0) + 133)
            $0.leading.equalToSuperview().inset(39)
            $0.trailing.equalToSuperview().inset(41)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(53)
        }
        
        nextButton.addSubview(nextLabel)
        nextLabel.snp.makeConstraints {
            $0.top.equalTo(14.adjustedW)
            $0.leading.equalTo(131.adjustedW)
        }
    }
}
