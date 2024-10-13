//
//  CharacterSettingVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CharacterSettingVC: UIViewController {
    
    var viewModel: ProfileSettingViewModel?
    let coordinator: CharacterSettingCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()

    private let characterSettingView = CharacterSettingView()
    
    init(coordinator: CharacterSettingCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = characterSettingView
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
        characterSettingView.characterSelectButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                UserData.shared.characterIndex = vc.characterSettingView.characterPageControl.currentPage
                vc.coordinator?.pushToNicknameSettingView()
            }).disposed(by: disposeBag)
    }
}
