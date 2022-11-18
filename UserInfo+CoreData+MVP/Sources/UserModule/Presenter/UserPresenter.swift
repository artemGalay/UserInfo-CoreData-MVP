//
//  UserPresenter.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 18.11.22.
//

import Foundation
import CoreData

protocol UserPresenterProtocol: AnyObject {
    var user: UserInfo? { get set }
    var fetchResultController: NSFetchedResultsController<NSFetchRequestResult> { get set }
    func perform()
    func addUser()
}

final class UserPresenter: NSObject, UserPresenterProtocol {

    // MARK: - Property

    private weak var view: UserViewProtocol?
    var user: UserInfo?
    var fetchResultController = CoreDataManager.instance.fetchResultController(entityName: "UserInfo", sortName: "fullName")

    // MARK: - Initialization

    init(view: UserViewProtocol) {
        super.init()
        fetchResultController.delegate = self
        self.view = view
    }

    // MARK: - Funcs

    func perform() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
    }

    func addUser() {
        if view?.userTextField.text != "" {
            guard let text = view?.userTextField.text else { return }
            if user == nil {
                user = UserInfo()
            }

            if let user = user {
                user.fullName = text
                CoreDataManager.instance.saveContext()
                view?.userTextField.text = nil
                view?.userTextField.becomeFirstResponder()
                self.user = nil
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension UserPresenter: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.usersTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                view?.usersTableView.insertRows(at: [indexPath], with: .automatic)
            }

        case .update:
            if let indexPath = indexPath {
                let user = fetchResultController.object(at: indexPath) as? UserInfo
                let cell = view?.usersTableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = user?.fullName
            }

        case .move:
            if let indexPath = indexPath {
                view?.usersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                view?.usersTableView.insertRows(at: [indexPath], with: .automatic)
            }

        case .delete:
            if let indexPath = indexPath {
                view?.usersTableView.deleteRows(at: [indexPath], with: .automatic)
            }

        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.usersTableView.endUpdates()
    }
}
