//
//  CharacterEditVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/26/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CharacterEditVC: UIViewController {
    
    private let coordinator: CharacterEditCoordinator?
    private let disposeBag: DisposeBag = DisposeBag()
        
    private let adornCharacterNavigationView = NavigationView(title: "캐릭터 꾸미기", backButtonHidden: false)
    private let adornCharacterView: ProfileEditView = ProfileEditView()
    
    init(coordinator: CharacterEditCoordinator) {
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
    }
    
    private func setupLayout() {
        self.view.addSubviews(adornCharacterNavigationView,
                              adornCharacterView)
        
        adornCharacterNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        adornCharacterView.snp.makeConstraints {
            $0.top.equalTo(adornCharacterNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
        
    private func setupAction() {
  
    }
}
