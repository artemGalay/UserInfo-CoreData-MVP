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

    private lazy var userIcon = createIcon(systemName: "person")
    private lazy var dateOfBirthIcon = createIcon(systemName: "calendar")
    private lazy var genderIcon = createIcon(systemName: "person.2.circle")

    private lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "FullName"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var dateOfBirthPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
//        datePicker.isEnabled = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    private lazy var userNameStackView = createStackView(arrangeSubviews: [userIcon, userTextField],
                                                         axis: .horizontal,
                                                         spacing: 10,
                                                         distribution: .fillProportionally)
    private lazy var dateOfBirthStackView = createStackView(arrangeSubviews: [dateOfBirthIcon, dateOfBirthPicker],
                                                            axis: .horizontal,
                                                            spacing: 0,
                                                            distribution: .fillProportionally)

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
        view.addSubview(userNameStackView)
        view.addSubview(dateOfBirthStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            photoUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            photoUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoUser.widthAnchor.constraint(equalToConstant: 200),
            photoUser.heightAnchor.constraint(equalToConstant: 200),

            userNameStackView.topAnchor.constraint(equalTo: photoUser.bottomAnchor, constant: 20),
            userNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            userNameStackView.widthAnchor.constraint(equalToConstant: 250),
            userNameStackView.heightAnchor.constraint(equalToConstant: 40),

            dateOfBirthStackView.topAnchor.constraint(equalTo: userNameStackView.bottomAnchor, constant: 20),
            dateOfBirthStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            dateOfBirthStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dateOfBirthStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func rightButtonItemTapped() {

    }
}
