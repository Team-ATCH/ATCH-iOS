//
//  CharacterSettingView.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class CharacterSettingView: UIView {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let characterlabel = UILabel().then {
        $0.text = "나만의 캐릭터를 골라보세요."
        $0.textColor = .atchBlack
        $0.font = .font(.title3)
    }
    
    private let characterScrollView = UIScrollView().then {
        $0.isScrollEnabled = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let characterImageStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .center
    }
    
    private let characterImageViewOne = UIImageView().then {
        $0.image = .imgBigCharacterOne
    }
    
    private let characterImageViewTwo = UIImageView().then {
        $0.image = .imgBigCharacterTwo
    }
    
    private let characterImageViewThree = UIImageView().then {
        $0.image = .imgBigCharacterThree
    }
    
    private let characterImageViewFour = UIImageView().then {
        $0.image = .imgBigCharacterFour
    }
    
    private let characterImageViewFive = UIImageView().then {
        $0.image = .imgBigCharacterFive
    }
    
    let characterPageControl = AtchPageControl().then {
        $0.numberOfPages = 5
    }
    
    private let characterLeftButton = UIButton().then {
        $0.setImage(.icArrowLeft, for: .normal)
        $0.isHidden = true
    }
    
    private let characterRightButton = UIButton().then {
        $0.setImage(.icArrowRight, for: .normal)
    }
    
    let characterSelectButton = UIImageView().then {
        $0.image = .imgBigButton
        $0.contentMode = .scaleAspectFill
        $0.isUserInteractionEnabled = true
    }
    
    private let characterSelectLabel = UILabel().then {
        $0.text = "선택완료"
        $0.textColor = .atchBlack
        $0.font = .font(.bigButton)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.setupDelegate()
        self.setupStyle()
        self.setupLayout()
        self.setupAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupDelegate() {
        characterScrollView.delegate = self
    }
    
    private func setupStyle() {
        [characterImageViewOne, characterImageViewTwo, characterImageViewThree, characterImageViewFour, characterImageViewFive].forEach {
            $0.contentMode = .scaleAspectFit
        }
    }

    private func setupLayout() {
        self.addSubviews(characterlabel,
                         characterScrollView,
                         characterPageControl,
                         characterSelectButton,
                         characterLeftButton,
                         characterRightButton)
                
        characterlabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.top ?? 0) + 52)
            $0.centerX.equalToSuperview()
        }
        
        characterScrollView.snp.makeConstraints {
            $0.top.equalTo(characterlabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 124)
        }
        
        characterScrollView.addSubview(characterImageStackView)
        characterImageStackView.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 5)
            $0.edges.equalToSuperview()
        }
        
        [characterImageViewOne, characterImageViewTwo, characterImageViewThree, characterImageViewFour, characterImageViewFive].forEach {
            characterImageStackView.addArrangedSubview($0)
            $0.snp.makeConstraints {
                $0.height.equalTo(556)
            }
        }
        
        characterLeftButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(characterImageStackView)
            $0.size.equalTo(64)
        }
        
        characterRightButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(characterImageStackView)
            $0.size.equalTo(64)
        }
        
        characterSelectButton.snp.makeConstraints {
            $0.width.equalTo(295)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset((UIWindow.key?.safeAreaInsets.bottom ?? 0) + 31)
        }
        
        characterSelectButton.addSubview(characterSelectLabel)
        characterSelectLabel.snp.makeConstraints {
            $0.top.equalTo(14)
            $0.leading.equalTo(114)
        }
        
        characterPageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(characterSelectButton.snp.top).offset(-30)
        }
    }
    
    private func setupAction() {
        characterLeftButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                if view.characterPageControl.currentPage <= 0 {
                    return
                }
                view.characterPageControl.currentPage -= 1
                view.characterScrollView.setContentOffset(CGPoint(x: Int(UIScreen.main.bounds.width) * (view.characterPageControl.currentPage), y: 0), animated: true)
            }).disposed(by: disposeBag)
        
        characterRightButton.rx.tapGesture().when(.recognized)
            .asObservable()
            .withUnretained(self)
            .subscribe(onNext: { view, _ in
                if view.characterPageControl.currentPage >= 4 {
                    return
                }
                view.characterPageControl.currentPage += 1
                view.characterScrollView.setContentOffset(CGPoint(x: Int(UIScreen.main.bounds.width) * (view.characterPageControl.currentPage), y: 0), animated: true)
            }).disposed(by: disposeBag)
    }
}

extension CharacterSettingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      self.characterPageControl.currentPage = Int(round(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        switch characterPageControl.currentPage {
        case 0:
            characterLeftButton.isHidden = true
            characterRightButton.isHidden = false
        case 4:
            characterLeftButton.isHidden = false
            characterRightButton.isHidden = true
        default:
            characterLeftButton.isHidden = false
            characterRightButton.isHidden = false
        }
    }
  }
