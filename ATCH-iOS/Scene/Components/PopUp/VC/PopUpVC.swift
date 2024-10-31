//
//  PopUpVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class PopUpVC: UIViewController {
    
    private let coordinator: PopUpCoordinator?
    var viewModel: PopUpViewModel?
    
    private let disposeBag: DisposeBag = DisposeBag()
        
    private var type: PopUpType = .back
    
    let popupView: PopUpView = PopUpView()
    
    init(coordinator: PopUpCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = popupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupAction()
    }
    
    func bindPopUpData(data: PopUpData) {     
        type = data.type
        popupView.bindViewData(data: data)
    }
    
    private func bindViewModel() {
       
    }
    
    private func setupAction() {
        popupView.oneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in     
                switch vc.type {
                case .logout:
                    // 로그아웃 서버통신
                    vc.dismiss(animated: false)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController?.dismiss(animated: false, completion: nil)
                        window.rootViewController?.navigationController?.popToRootViewController(animated: true)

                        let navigationController = UINavigationController()
                        navigationController.navigationBar.isHidden = true
                        window.rootViewController = navigationController
                      
                        let coordinator = SplashCoordinator(navigationController)
                        coordinator.start()
                    }
                case .withdraw:
                    vc.dismiss(animated: false)
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController?.dismiss(animated: false, completion: nil)
                        window.rootViewController?.navigationController?.popToRootViewController(animated: true)

                        let navigationController = UINavigationController()
                        navigationController.navigationBar.isHidden = true
                        window.rootViewController = navigationController
                      
                        let coordinator = SplashCoordinator(navigationController)
                        coordinator.start()
                    }
                case .back:
                    break
                }
            }).disposed(by: disposeBag)
        
        popupView.dimView.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                if vc.type != .withdraw {
                    vc.dismiss(animated: false)
                }
            }).disposed(by: disposeBag)
    }
}
