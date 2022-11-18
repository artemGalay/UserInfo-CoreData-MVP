//
//  UserViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 12.11.22.
//

import UIKit

protocol UserViewProtocol: AnyObject {
    var usersTableView: UITableView { get set }
    var userTextField: UITextField { get set }
}

final class UserViewController: UIViewController, UserViewProtocol {

    //MARK: - Property

    private var presenter: UserPresenterProtocol?

    // MARK: - UIElements

    lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Print your name here"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var pressButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Press", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pressButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var usersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    init() {
        super.init(nibName: nil, bundle: nil)
        self.presenter = UserPresenter(view: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationController()
        setupHierarchy()
        setupLayout()
        presenter?.perform()
    }

    // MARK: - Setups

    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Constants.title
    }

    private func setupHierarchy() {
        view.addSubview(userTextField)
        view.addSubview(pressButton)
        view.addSubview(usersTableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.offset),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.offset),
            userTextField.heightAnchor.constraint(equalToConstant: 50),

            pressButton.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: Metric.offset),
            pressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.offset),
            pressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.offset),
            pressButton.heightAnchor.constraint(equalToConstant: Metric.pressButtonHeightOffset),

            usersTableView.topAnchor.constraint(equalTo: pressButton.bottomAnchor, constant: Metric.offset),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func pressButtonTapped() {
        presenter?.addUser()
    }
}

// MARK: - UITableViewDataSource

extension UserViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.fetchResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = presenter?.fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        let user = presenter?.fetchResultController.object(at: indexPath) as? UserInfo
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = user?.fullName
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let user = presenter?.fetchResultController.object(at: indexPath) as? UserInfo ?? UserInfo()
            CoreDataManager.instance.context.delete(user)
            CoreDataManager.instance.saveContext()
        }
    }
}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presenterDetail = DetailPresenter()
        let viewController = DetailViewController(presenter: presenterDetail)
        presenterDetail.view = viewController
        tableView.deselectRow(at: indexPath, animated: true)
        let user = presenter?.fetchResultController.object(at: indexPath) as? UserInfo
        viewController.presenter?.user = user
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Constants

extension UserViewController {

    struct Constants {
        static let cell = "cell"
        static let title = "Users"
    }

    struct Metric {
        static let offset: CGFloat = 20
        static let pressButtonHeightOffset: CGFloat = 50
    }
}
