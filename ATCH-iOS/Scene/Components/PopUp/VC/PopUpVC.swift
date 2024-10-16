//
//  PopUpVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/16/24.
//

import UIKit

import Lottie
import RxSwift
import SnapKit
import Then

final class PopUpVC: UIViewController {
    
    let coordinator: PopUpCoordinator?
    
    private let disposeBag: DisposeBag = DisposeBag()
        
    init(coordinator: PopUpCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
//        self.view = profileModalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAction()
    }
    
    func bindPopUpData(data: PopUpData) {
    }
    
    private func setupAction() {
//        profileModalView.closeButton.rx.tap.asObservable()
//            .withUnretained(self)
//            .subscribe(onNext: { vc, _ in
//                vc.dismiss(animated: false)
//            }).disposed(by: disposeBag)
//        
//        profileModalView.profileEditButton.rx.tapGesture().asObservable()
//            .when(.recognized)
//            .withUnretained(self)
//            .subscribe(onNext: { vc, _ in
//                vc.dismiss(animated: false)
//                vc.coordinator?.pushToMyPage()
//            }).disposed(by: disposeBag)
    }
}
