//
//  UIWindow+.swift
//  ATCH-iOS
//
//  Created by 변희주 on 8/18/24.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    func showToastMessage(message: String) {
        DispatchQueue.main.async {
            let toastLabel = UILabel()
            toastLabel.numberOfLines = 0
            toastLabel.font = .font(.body)
            toastLabel.textColor = .atchWhite
            toastLabel.text = message
            
            let backgroundView = UIView().then {
                $0.backgroundColor = .atchBlack.withAlphaComponent(0.6)
            }
            
            (self.rootViewController as! UINavigationController).topViewController?.view.addSubview(backgroundView)
            backgroundView.addSubview(toastLabel)
            backgroundView.snp.makeConstraints {
                $0.top.equalTo(((self.rootViewController as! UINavigationController).topViewController?.view.safeAreaLayoutGuide)!).offset(12)
                $0.centerX.equalToSuperview()
            }
            
            toastLabel.snp.makeConstraints {
                $0.edges.equalToSuperview().inset(15)
            }
            
            backgroundView.layer.cornerRadius = 8
            
            UIView.animate(withDuration: 2) {
                backgroundView.alpha = 0
            } completion: { _ in
                backgroundView.removeFromSuperview()
            }
        }
    }
    
}
