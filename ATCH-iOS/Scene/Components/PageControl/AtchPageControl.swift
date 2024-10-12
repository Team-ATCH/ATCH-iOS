//
//  AtchPageControl.swift
//  ATCH-iOS
//
//  Created by 변희주 on 10/12/24.
//

import UIKit

final class AtchPageControl: UIStackView {

    @IBInspectable var currentPageImage: UIImage = .icCurrentPageIndicator
    @IBInspectable var pageImage: UIImage = .icPageIndicator

    var numberOfPages = 0 {
        didSet {
            layoutIndicators()
        }
    }

    var currentPage = 0 {
        didSet {
            setCurrentPageIndicator()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        axis = .horizontal
        distribution = .fill
        alignment = .center

        layoutIndicators()
    }

    private func layoutIndicators() {

        for i in 0..<numberOfPages {

            let imageView: UIImageView

            if i < arrangedSubviews.count {
                imageView = arrangedSubviews[i] as! UIImageView
            } else {
                imageView = UIImageView()
                addArrangedSubview(imageView)
                setCustomSpacing(8, after: imageView)
            }

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }

        let subviewCount = arrangedSubviews.count
        if numberOfPages < subviewCount {
            for _ in numberOfPages..<subviewCount {
                arrangedSubviews.last?.removeFromSuperview()
            }
        }
    }

    private func setCurrentPageIndicator() {

        for i in 0..<arrangedSubviews.count {

            let imageView = arrangedSubviews[i] as! UIImageView

            if i == currentPage {
                imageView.image = currentPageImage
            } else {
                imageView.image = pageImage
            }
        }
    }
}
