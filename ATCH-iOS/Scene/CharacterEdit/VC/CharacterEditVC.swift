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
        
    private let characterEditNavigationView = NavigationView(title: "캐릭터 꾸미기", backButtonHidden: false)
    private let characterEditView: CharacterEditView = CharacterEditView()
    
    init(coordinator: CharacterEditCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAction()
    }
    
    private func setupLayout() {
        self.view.addSubviews(characterEditNavigationView,
                              characterEditView)
        
        characterEditNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        characterEditView.snp.makeConstraints {
            $0.top.equalTo(characterEditNavigationView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
        
    private func setupAction() {
  
    }
}
