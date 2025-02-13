//
//  NicknameSettingVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class NicknameSettingVC: UIViewController {
    
    var viewModel: ProfileSettingViewModel?
    let coordinator: NicknameSettingCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let nicknameSettingView = NicknameSettingView()

    init(coordinator: NicknameSettingCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = nicknameSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupStyle()
        setupAction()
    }
    
    private func bindViewModel() {
        viewModel?.successRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, success in
                if success {
                    vc.coordinator?.pushToHashTagSettingView()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchWhite
    }

    private func setupAction() {
        nicknameSettingView.nextButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                if vc.nicknameSettingView.canGoNext {
                    vc.viewModel?.updateNickname(nickname: UserData.shared.nickname)
                }
            }).disposed(by: disposeBag)
    }
}
