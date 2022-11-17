//
//  UserViewController.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 12.11.22.
//

import UIKit
import CoreData

class UserViewController: UIViewController {

    var user: UserInfo?

    var fetchResultController = CoreDataManager.instance.fetchResultController(entityName: Constants.entity, sortName: Constants.sortName)

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

    lazy var usersTableView: UITableView = {
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
        fetchResultController.delegate = self
        setupNavigationController()
        setupHierarchy()
        setupLayout()
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
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


    @objc private func pressButtonTapped() {
        if userTextField.text != "" {
            guard let text = userTextField.text else { return }
            // Создаем объект
            if user == nil {
                user = UserInfo()
            }

            if let user = user {
                user.fullName = text
                CoreDataManager.instance.saveContext()
                userTextField.text = nil
                userTextField.becomeFirstResponder()
                self.user = nil
            }
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

    func numberOfSections(in tableView: UITableView) -> Int {
        fetchResultController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell, for: indexPath)
        let user = fetchResultController.object(at: indexPath) as! UserInfo
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = user.fullName
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let user = fetchResultController.object(at: indexPath) as! UserInfo
            CoreDataManager.instance.context.delete(user)
            CoreDataManager.instance.saveContext()
        }
    }
}

extension UserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        let user = fetchResultController.object(at: indexPath) as! UserInfo
        viewController.user = user
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UserViewController: NSFetchedResultsControllerDelegate {

    // Информирует о начале изменения данных
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        usersTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                usersTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let user = fetchResultController.object(at: indexPath) as! UserInfo
                let cell = usersTableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = user.fullName
            }
        case .move:
            if let indexPath = indexPath {
                usersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                usersTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                usersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }

    // Информирует о окончании изменении данных
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        usersTableView.endUpdates()
    }
}

extension UserViewController {
    struct Constants {
        static let entity = "UserInfo"
        static let sortName = "fullName"
        static let cell = "cell"
    }
}
