//
//  HashTagSettingVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class HashTagSettingVC: UIViewController {
    
    var viewModel: ProfileSettingViewModel?
    let coordinator: HashTagSettingCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let hashTagSettingView = HashTagSettingView()

    init(coordinator: HashTagSettingCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = hashTagSettingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupAction()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchWhite
    }
    
    private func setupAction() {
        hashTagSettingView.nextButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                if vc.hashTagSettingView.canGoNext {
                    vc.coordinator?.pushToMainView()
                }
            }).disposed(by: disposeBag)
    }
}
