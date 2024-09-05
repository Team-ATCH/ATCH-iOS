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
    
    var viewModel: AlarmViewModel?
    let coordinator: AlarmCoordinator?
    private let disposeBag: DisposeBag = DisposeBag()

    private let alarmNavigationView = NavigationView(title: "알림함", iconHidden: false, backButtonHidden: false, backButtonTitle: "지도")
    private let alarmView = AlarmView()
    private let alarmList: [AlarmData] = [AlarmData(type: .item, title: "‘피곤한 홍대생의 과잠’ 아이템 도착!", content: "(알림 내용) 홍익대학교 캠퍼스 내에서 앱 1회 실행 완료! ㅇㅇㅇ님을 위한 특별한 아이템이 도착했어요. 우측 하단의 아이템 받기 버튼을 클릭하고 ’피곤한 홍대생의 과잠’을 장착해 보세요."),
                                          AlarmData(type: .notice, title: "시스템 정기점검", content: "시스템 정기점검을 위해 5/30 (목) 하루 동안 서비스가 중단됩니다. 5/31 (금)에 다시 만나요!"),
                                          AlarmData(type: .item, title: "‘피곤한 홍대생의 과잠’ 아이템 도착!", content: "(알림 내용) 홍익대학교 캠퍼스 내에서 앱 1회 실행 완료! ㅇㅇㅇ님을 위한 특별한 아이템이 도착했어요. 우측 하단의 아이템 받기 버튼을 클릭하고 ’피곤한 홍대생의 과잠’을 장착해 보세요."),
                                          AlarmData(type: .notice, title: "시스템 정기점검", content: "시스템 정기점검을 위해 5/30 (목) 하루 동안 서비스가 중단됩니다. 5/31 (금)에 다시 만나요!"),
                                          AlarmData(type: .item, title: "‘피곤한 홍대생의 과잠’ 아이템 도착!", content: "(알림 내용) 홍익대학교 캠퍼스 내에서 앱 1회 실행 완료! ㅇㅇㅇ님을 위한 특별한 아이템이 도착했어요. 우측 하단의 아이템 받기 버튼을 클릭하고 ’피곤한 홍대생의 과잠’을 장착해 보세요."),
                                          AlarmData(type: .notice, title: "시스템 정기점검", content: "시스템 정기점검을 위해 5/30 (목) 하루 동안 서비스가 중단됩니다. 5/31 (금)에 다시 만나요!"),
                                          AlarmData(type: .item, title: "‘피곤한 홍대생의 과잠’ 아이템 도착!", content: "(알림 내용) 홍익대학교 캠퍼스 내에서 앱 1회 실행 완료! ㅇㅇㅇ님을 위한 특별한 아이템이 도착했어요. 우측 하단의 아이템 받기 버튼을 클릭하고 ’피곤한 홍대생의 과잠’을 장착해 보세요."),
                                          AlarmData(type: .notice, title: "시스템 정기점검", content: "시스템 정기점검을 위해 5/30 (목) 하루 동안 서비스가 중단됩니다. 5/31 (금)에 다시 만나요!")]
    
    
    init(coordinator: AlarmCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupDelegate()
        setupLayout()
        setupAction()
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
        return alarmList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.reuseIdentifier, for: indexPath) as? AlarmCollectionViewCell else {return UICollectionViewCell()}
        cell.bindCell(model: alarmList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch alarmList[indexPath.item].type {
        case .item:
            return CGSize(width: Int(UIScreen.main.bounds.width) - 19 - 18, height:  167 * (Int(UIScreen.main.bounds.width) - 19 - 18) / 338)
        case .notice:
            return CGSize(width: Int(UIScreen.main.bounds.width) - 19 - 18, height:  99 * (Int(UIScreen.main.bounds.width) - 19 - 18) / 338)
        }
    }
}

