//
//  AlarmVC.swift
//  ATCH-iOS
//
//  Created by 변희주 on 9/1/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AlarmVC: UIViewController {
    
    let coordinator: AlarmCoordinator?
    var viewModel: AlarmViewModel?
    private let disposeBag: DisposeBag = DisposeBag()

    private let alarmNavigationView = NavigationView(title: "알림함", iconHidden: false, backButtonHidden: false, backButtonTitle: "지도")
    private let alarmView = AlarmView()
    
    init(coordinator: AlarmCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupStyle()
        setupDelegate()
        setupLayout()
        setupAction()
    }
    
    private func bindViewModel() {
        viewModel?.alarmListRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.alarmView.alarmCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel?.getNoticeList()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchYellow
    }
    
    private func setupDelegate() {
        alarmView.alarmCollectionView.delegate = self
        alarmView.alarmCollectionView.dataSource = self
    }

    private func setupLayout() {
        self.view.addSubviews(alarmNavigationView, 
                              alarmView)
        
        alarmNavigationView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo((UIWindow.key?.safeAreaInsets.top ?? 0) + 51)
        }
        
        alarmView.snp.makeConstraints {
            $0.top.equalTo(alarmNavigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 63)
        }
    }
    
    private func setupAction() {
        alarmNavigationView.navigationBackButton.rx.tapGesture().asObservable()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
    }
}

extension AlarmVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.alarmList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.reuseIdentifier, for: indexPath) as? AlarmCollectionViewCell else {return UICollectionViewCell()}
        if let alarmList = viewModel?.alarmList {
            cell.bindCell(model: alarmList[indexPath.item])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel?.alarmList[indexPath.item].type {
        case .item:
            return CGSize(width: Int(UIScreen.main.bounds.width) - 19 - 18, height:  167 * (Int(UIScreen.main.bounds.width) - 19 - 18) / 338)
        case .notice:
            return CGSize(width: Int(UIScreen.main.bounds.width) - 19 - 18, height:  99 * (Int(UIScreen.main.bounds.width) - 19 - 18) / 338)
        case .none:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushToMyPage()
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: "pushToCharacterEditView"),
            object: nil
        )
    }
}

