//
//  DetailViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 13.11.22.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
    }

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 45)
        button.setTitle("Edit", for: .normal)
        button.layer.borderWidth = 1.5
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(rightButtonItemTapped), for: .touchUpInside)
        return button
    }()

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemGray
        let image = UIImage(systemName: "arrow.left")
        navigationItem.setLeftBarButton(UIBarButtonItem(image: image, style: .done, target: self, action: nil), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: editButton), animated: true)
    }

    private func setupHierarchy() {
    }

    private func setupLayout() {
    }

    @objc private func rightButtonItemTapped() {

    }
}
