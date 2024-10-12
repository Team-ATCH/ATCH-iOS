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

    init(coordinator: NicknameSettingCoordinator) {
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
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchWhite
        print(UserData.shared.characterIndex)
    }
    
    private func setupLayout() {
        
    }
    
    private func setupAction() {
    }
}
