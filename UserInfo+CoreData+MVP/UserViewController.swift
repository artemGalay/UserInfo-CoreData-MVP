//
//  UserViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 12.11.22.
//

import UIKit

class UserViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var userName = [UserInfo]()

    private lazy var userTextField: UITextField = {
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

    private lazy var usersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationController()
        setupHierarchy()
        setupLayout()
        getUser()
    }

    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Users"
    }

    private func setupHierarchy() {
        view.addSubview(userTextField)
        view.addSubview(pressButton)
        view.addSubview(usersTableView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userTextField.heightAnchor.constraint(equalToConstant: 50),

            pressButton.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 20),
            pressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pressButton.heightAnchor.constraint(equalToConstant: 50),

            usersTableView.topAnchor.constraint(equalTo: pressButton.bottomAnchor, constant: 20),
            usersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            usersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    //MARK: - Funcs CoreData

    func getUser() {
        do {
            userName = try context.fetch(UserInfo.fetchRequest())
            usersTableView.reloadData()
        } catch
            let error {
            print(error.localizedDescription)
        }
    }

    func createUser(name: String) {
        let newUser = UserInfo(context: context)
        newUser.fullName = name

        do {
            try context.save()
            getUser()
        } catch
            let error {
            print(error.localizedDescription)
        }
    }

    func deleteUser(user: UserInfo) {
        context.delete(user)

        do {
            try context.save()
            getUser()
        } catch
            let error {
            print(error.localizedDescription)
        }
    }

    @objc private func pressButtonTapped() {
        if userTextField.text != "" {
            guard let text = userTextField.text else { return }
            createUser(name: text)
        } else {
            let alert = UIAlertController(
                title: "Nothing was written",
                message: "Please enter the name",
                preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }
        usersTableView.reloadData()
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = userName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = user.fullName
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            tableView.beginUpdates()
            let user = userName[indexPath.row]
            deleteUser(user: user)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        //        viewController.userTextField.text = userName[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}


