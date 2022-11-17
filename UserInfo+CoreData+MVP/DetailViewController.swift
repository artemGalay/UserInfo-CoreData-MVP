//
//  DetailViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 13.11.22.
//

import UIKit

class DetailViewController: UIViewController {

    var user: UserInfo?
    var isEdit = true

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 45)
        button.setTitle("Edit", for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
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

    lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "FullName"
        textField.isEnabled = false
        return textField
    }()

    private lazy var dateOfBirthPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.isEnabled = false
        return datePicker
    }()

    private lazy var maleButoon: UIButton = {
        let button = UIButton()
        button.setTitle("Male", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 12
//        button.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var femaleButoon: UIButton = {
        let button = UIButton()
        button.setTitle("Female", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 12
//        button.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var userNameStackView = createStackView(arrangeSubviews: [userIcon, userTextField],
                                                         axis: .horizontal,
                                                         spacing: 10,
                                                         distribution: .fillProportionally)
    private lazy var dateOfBirthStackView = createStackView(arrangeSubviews: [dateOfBirthIcon, dateOfBirthPicker],
                                                            axis: .horizontal,
                                                            spacing: 0,
                                                            distribution: .fillProportionally)

    private lazy var genderStackView = createStackView(arrangeSubviews: [genderIcon, maleButoon, femaleButoon],
                                                       axis: .horizontal,
                                                       spacing: 110,
                                                       distribution: .fillEqually)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        // Чтение объекта
        if let user = user {
            userTextField.text = user.fullName
            dateOfBirthPicker.date = user.dateOfBirth ?? Date()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemGray
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.setRightBarButton(UIBarButtonItem(customView: editButton), animated: true)
    }

    private func setupHierarchy() {
        view.addSubview(photoUser)
        view.addSubview(userNameStackView)
        view.addSubview(dateOfBirthStackView)
        view.addSubview(genderStackView)
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
            dateOfBirthStackView.heightAnchor.constraint(equalToConstant: 40),

            genderStackView.topAnchor.constraint(equalTo: dateOfBirthStackView.bottomAnchor, constant: 20),
            genderStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            genderStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            genderStackView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    @objc private func editButtonTapped() {
        if isEdit {
            userTextField.isEnabled = true
            dateOfBirthPicker.isEnabled  = true
            editButton.setTitle("Save", for: .normal)
            editButton.setTitleColor(.systemRed, for: .normal)
            isEdit = false
        } else if !isEdit {
            editButton.setTitle("Edit", for: .normal)
            editButton.setTitleColor(.black, for: .normal)
            userTextField.isEnabled = false
            dateOfBirthPicker.isEnabled  = false
            isEdit = true
            if user == nil {
                user = UserInfo()
            }

            if let user = user {
                user.fullName = userTextField.text
                user.dateOfBirth = dateOfBirthPicker.date
                CoreDataManager.instance.saveContext()
            }
        }
    }


    //@objc private func maleButtonTapped() {
    //    maleButoon.setTitleColor(.white, for: .normal)
    //    maleButoon.backgroundColor = .systemBlue
    //}
    //
    //@objc private func femaleButtonTapped() {
    //    femaleButoon.setTitleColor(.white, for: .normal)
    //    femaleButoon.backgroundColor = .systemRed
    //}
    //
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

