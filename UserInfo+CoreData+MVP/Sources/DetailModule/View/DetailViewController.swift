//
//  DetailViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 13.11.22.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK: - Property

    var user: UserInfo?
    let gender = ["Мужской", "Женский"]
    var isEdit = true

    // MARK: - UIElements

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

    private lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "FullName"
        textField.isEnabled = false
        return textField
    }()

    private let dateOfBirthPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.isEnabled = false
        return datePicker
    }()

    private lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Выберите пол"
        textField.inputView = pickerView
        textField.isEnabled = false
        return textField
    }()

    private let pickerView = UIPickerView()

    private lazy var iconsStackView = createStackView(arrangeSubviews: [userIcon, dateOfBirthIcon, genderIcon],
                                                      aligment: .fill,
                                                      axis: .vertical,
                                                      spacing: 10,
                                                      distribution: .fillProportionally)
    private lazy var infoStackView = createStackView(arrangeSubviews: [userTextField, dateOfBirthPicker, genderTextField],
                                                     aligment: .fill,
                                                     axis: .vertical,
                                                     spacing: 8,
                                                     distribution: .fillProportionally)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        pickerViewConfigure()
        readUser()
    }

    // MARK: - Setups

    private func readUser() {
        if let user = user {
            userTextField.text = user.fullName
            dateOfBirthPicker.date = user.dateOfBirth ?? Date()
            genderTextField.text = user.gender
        }
    }

    private func pickerViewConfigure() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemGray
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.setRightBarButton(UIBarButtonItem(customView: editButton), animated: true)
    }

    private func setupHierarchy() {
        view.addSubview(photoUser)
        view.addSubview(iconsStackView)
        view.addSubview(infoStackView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            photoUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            photoUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoUser.widthAnchor.constraint(equalToConstant: 200),
            photoUser.heightAnchor.constraint(equalToConstant: 200),

            iconsStackView.topAnchor.constraint(equalTo: photoUser.bottomAnchor, constant: 20),
            iconsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            iconsStackView.widthAnchor.constraint(equalToConstant: 45),
            iconsStackView.heightAnchor.constraint(equalToConstant: 130),

            infoStackView.topAnchor.constraint(equalTo: photoUser.bottomAnchor, constant: 20),
            infoStackView.leadingAnchor.constraint(equalTo: iconsStackView.trailingAnchor, constant: 10),
            infoStackView.heightAnchor.constraint(equalToConstant: 120),
            infoStackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc private func editButtonTapped() {
        if isEdit {
            userTextField.isEnabled = true
            dateOfBirthPicker.isEnabled  = true
            genderTextField.isEnabled = true
            editButton.setTitle("Save", for: .normal)
            editButton.setTitleColor(.systemRed, for: .normal)
            isEdit = false
        } else if !isEdit {
            editButton.setTitle("Edit", for: .normal)
            editButton.setTitleColor(.black, for: .normal)
            userTextField.isEnabled = false
            dateOfBirthPicker.isEnabled  = false
            genderTextField.isEnabled = false
            isEdit = true
            if user == nil {
                user = UserInfo()
            }
            if let user = user {
                user.fullName = userTextField.text
                user.dateOfBirth = dateOfBirthPicker.date
                user.gender = genderTextField.text
                CoreDataManager.instance.saveContext()
            }
        }
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIPickerViewDataSource

extension DetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        gender.count
    }
}

// MARK: - UIPickerViewDelegate

extension DetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        gender[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = gender[row]
        genderTextField.resignFirstResponder()
    }
}
