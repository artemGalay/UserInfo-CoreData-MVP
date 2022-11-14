//
//  DetailViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 13.11.22.
//

import UIKit

class DetailViewController: UIViewController {

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 45)
        button.setTitle("Edit", for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(rightButtonItemTapped), for: .touchUpInside)
        return button
    }()

    private let photoUser: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addPhoto")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemGray
        let image = UIImage(systemName: "arrow.left")
        navigationItem.setLeftBarButton(UIBarButtonItem(image: image, style: .done, target: self, action: nil), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(customView: editButton), animated: true)
    }

    private func setupHierarchy() {
        view.addSubview(photoUser)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            photoUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            photoUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoUser.widthAnchor.constraint(equalToConstant: 200),
            photoUser.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    @objc private func rightButtonItemTapped() {

    }
}
