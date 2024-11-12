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
    var viewModel: CharacterEditViewModel?
    
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
     
        bindViewModel()
        setupStyle()
        setupLayout()
        setupAction()
    }
    
    private func bindViewModel() {
        viewModel?.itemSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                vc.characterEditView.bindItemData(data: data.1, inUseIDs: data.0)
            }).disposed(by: disposeBag)
        
        viewModel?.characterSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                vc.characterEditView.bindCharacterData(data: data)
            }).disposed(by: disposeBag)
        
        viewModel?.backgroundSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                vc.characterEditView.bindBackgroundData(data: data.1, inUseID: data.0)
            }).disposed(by: disposeBag)
        
        viewModel?.characterSlotSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, data in
                vc.characterEditView.bindCharacterSlotData(data: data)
            }).disposed(by: disposeBag)
        
        viewModel?.itemPatchSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                if vc.characterEditView.selectedCharacter {
                    vc.viewModel?.updateCharacter(characterID: vc.characterEditView.currentCharacterID)
                } else {
                    vc.coordinator?.back()
                }
            }).disposed(by: disposeBag)
        
        viewModel?.characterPatchSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                if vc.characterEditView.selectedBackground {
                    vc.viewModel?.updateBackground(backgroundID: vc.characterEditView.currentBackgroundID)
                } else {
                    vc.coordinator?.back()
                }
            }).disposed(by: disposeBag)
        
        viewModel?.backgroundPatchSuccessRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
        
        viewModel?.getCharacterItems()
        viewModel?.getCharacters()
        viewModel?.getBackgrounds()
        viewModel?.getCharacterSlots()
    }
    
    private func setupStyle() {
        self.view.backgroundColor = .atchGrey1
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
        characterEditNavigationView.navigationBackButton.rx.tapGesture()
            .when(.recognized)
            .withUnretained(self)
            .subscribe(onNext: { (vc, _) in
                vc.coordinator?.back()
            }).disposed(by: disposeBag)
        
        characterEditView.itemButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                characterEditView.setImageToItem()
            })
            .disposed(by: disposeBag)
        
        characterEditView.characterButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                characterEditView.setImageToCharacter()
            })
            .disposed(by: disposeBag)
        
        characterEditView.backgroundButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                characterEditView.setImageToBackground()
            })
            .disposed(by: disposeBag)
        
        characterEditView.saveButton.rx.tapGesture()
            .asObservable().when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                if characterEditView.selectedItem {
                    viewModel?.updateItems(items: characterEditView.currentItemIDs)
                } else {
                    if characterEditView.selectedCharacter {
                        viewModel?.updateCharacter(characterID: characterEditView.currentCharacterID)
                    } else {
                        if characterEditView.selectedBackground {
                            viewModel?.updateBackground(backgroundID: characterEditView.currentBackgroundID)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}
