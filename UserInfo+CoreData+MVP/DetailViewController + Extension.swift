//
//  UIView + Extension.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 14.11.22.
//

import UIKit

extension DetailViewController {

    func createIcon(systemName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: systemName)
//        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    func createStackView(arrangeSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangeSubviews)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = distribution
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
