//
//  SigninVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/11/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class SigninVC: UIViewController {
    
    var viewModel: SigninViewModel?
    let coordinator: SigninCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()
        
    private let atchLogoImageView = UIImageView().then {
        $0.image = .imgAppLogo
        $0.contentMode = .scaleAspectFit
    }
    
    private let atchIntroLabel = UILabel().then {
        $0.text = "실시간 장소정보 공유 플랫폼"
        $0.textColor = .atchBlack
        $0.font = .font(.chat)
    }
    
    private let kakaoLoginButton = UIImageView().then {
        $0.image = .imgKakaoLogin
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    private let appleLoginButton = UIImageView().then {
        $0.image = .imgAppleLogin
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    init(coordinator: SigninCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupLayout()
        setupAction()
        setupAnimation()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchWhite
    }
    
    private func setupLayout() {
        self.view.addSubviews(atchLogoImageView,
                              atchIntroLabel,
                              kakaoLoginButton,
                              appleLoginButton)
        
        atchLogoImageView.snp.makeConstraints {
            $0.width.equalTo(260)
            $0.height.equalTo(110)
            $0.center.equalToSuperview()
        }
        
        atchIntroLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(429.adjustedH)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(221.adjustedH)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(45)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(8)
        }
    }
    
    private func setupAction() {
        kakaoLoginButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.pushToCharacterSettingView()
            }).disposed(by: disposeBag)
        
        appleLoginButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.pushToCharacterSettingView()
            }).disposed(by: disposeBag)

    }
    
    private func setupAnimation() {
        UIView.animate(withDuration: 0.7) {
            self.atchLogoImageView.transform = CGAffineTransform(translationX: 0, y: -101.adjustedH)
        }
    }
}
