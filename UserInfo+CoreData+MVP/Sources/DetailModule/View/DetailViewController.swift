//
//  DetailViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 13.11.22.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    var userTextField: UITextField { get set }
    var dateOfBirthPicker: UIDatePicker { get set }
    var genderTextField: UITextField { get set }
    var editButton: UIButton { get set }
}

final class DetailViewController: UIViewController, DetailViewProtocol {

    //MARK: - Property

    var presenter: DetailPresenterProtocol?

    // MARK: - UIElements

    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 45)
        button.setTitle(Constant.setTitleButton, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()

    private let photoUser: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constant.imageViewName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var userIcon = createIcon(systemName: Constant.userIconName)
    private lazy var dateOfBirthIcon = createIcon(systemName: Constant.dateOfBirthIconName)
    private lazy var genderIcon = createIcon(systemName: Constant.genderIconName)

    lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constant.userTextFieldPlaceholder
        textField.isEnabled = false
        return textField
    }()

    lazy var dateOfBirthPicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.isEnabled = false
        return datePicker
    }()

    lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constant.genderTextFieldPlaceholder
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

    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        pickerViewConfigure()
        presenter?.readUser()
    }
    

    // MARK: - Setups

    private func pickerViewConfigure() {
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .systemGray
        let image = UIImage(systemName: Constant.leftBarButtonImageName)
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
            photoUser.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.photoUserTopOffset),
            photoUser.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoUser.widthAnchor.constraint(equalToConstant: Metric.photoUserLeadTrailOffset),
            photoUser.heightAnchor.constraint(equalToConstant: Metric.photoUserLeadTrailOffset),

            iconsStackView.topAnchor.constraint(equalTo: photoUser.bottomAnchor, constant: Metric.stacksTopLeadOffset),
            iconsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stacksTopLeadOffset),
            iconsStackView.widthAnchor.constraint(equalToConstant: Metric.iconsStackViewWidthOffset),
            iconsStackView.heightAnchor.constraint(equalToConstant: Metric.stactsHeightOffset),

            infoStackView.topAnchor.constraint(equalTo: photoUser.bottomAnchor, constant: Metric.stacksTopLeadOffset),
            infoStackView.leadingAnchor.constraint(equalTo: iconsStackView.trailingAnchor, constant: Metric.stacksTopLeadOffset),
            infoStackView.heightAnchor.constraint(equalToConstant: Metric.stactsHeightOffset),
            infoStackView.widthAnchor.constraint(equalToConstant: Metric.infoStackViewWidthOffset)
        ])
    }

    @objc private func editButtonTapped() {
        presenter?.editUser()
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
        presenter?.gender.count ?? 0
    }
}

// MARK: - UIPickerViewDelegate

extension DetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        presenter?.gender[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = presenter?.gender[row]
        genderTextField.resignFirstResponder()
    }
}

// MARK: - Constants

extension DetailViewController {

    struct Constant {
        static let setTitleButton = "Edit"
        static let imageViewName = "addPhoto"
        static let userIconName = "person"
        static let dateOfBirthIconName = "calendar"
        static let genderIconName = "person.2.circle"
        static let userTextFieldPlaceholder = "FullName"
        static let genderTextFieldPlaceholder = "Выберите пол"
        static let leftBarButtonImageName = "arrow.left"
    }

    struct Metric {
        static let photoUserTopOffset: CGFloat = 80
        static let photoUserLeadTrailOffset: CGFloat = 200
        static let stacksTopLeadOffset: CGFloat = 20
        static let iconsStackViewWidthOffset: CGFloat = 45
        static let stactsHeightOffset: CGFloat = 130
        static let infoStackViewWidthOffset: CGFloat = 300
    }
}
