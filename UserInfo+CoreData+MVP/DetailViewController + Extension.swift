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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
