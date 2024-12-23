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

    private var characterImageUrl: [String] = []
    
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
        
        bindViewModel()
        setupStyle()
        setupAction()
    }
    
    private func bindViewModel() {
        viewModel?.getAllCharacter()
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { vc, result in
                vc.characterImageUrl = result.map { $0.imageURL }
                vc.characterSettingView.bindImageURL(imageURL: result.map { $0.imageURL })
            }).disposed(by: disposeBag)
        
        viewModel?.successRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, success in
                if success {
                    vc.coordinator?.pushToNicknameSettingView()
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchWhite
    }
    
    private func setupAction() {
        characterSettingView.characterSelectButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let selectIndex = vc.characterSettingView.characterPageControl.currentPage
                UserData.shared.characterImageUrl = vc.characterImageUrl[selectIndex]
                UserData.shared.characterIndex = selectIndex
                vc.viewModel?.updateCharacter(characterID: UserData.shared.characterIndex + 1)
            }).disposed(by: disposeBag)
    }
}
