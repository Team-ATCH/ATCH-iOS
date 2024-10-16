//
//  SplashVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import Lottie
import RxSwift
import SnapKit
import Then

final class SplashVC: UIViewController {
    
    var viewModel: SplashViewModel?
    let coordinator: SplashCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var isValidToken: Bool = false

    private let animationView = LottieAnimationView(name: "atch")
    
    init(coordinator: SplashCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupLayout()
        setupAnimation()
    }
    
    private func bindViewModel() {
        viewModel?.tokenValidRelay
            .withUnretained(self)
            .subscribe(onNext: { vc, valid in
                vc.isValidToken = valid
            }).disposed(by: disposeBag)
        
        viewModel?.checkTokenValid()
    }
    
    private func setupLayout() {
        self.view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupAnimation() {
        animationView.do {
            $0.loopMode = .playOnce
            $0.play { [weak self] (finished) in
                guard let self else { return }
                if finished {
                    if self.isValidToken {
                        self.coordinator?.pushToMainView()
                    } else {
                        self.coordinator?.pushToSignView()
                    }
                }
            }
        }
    }
}
