//
//  DetailPresenter.swift
//  UserInfo+CoreData+MVP
//
//  Created by Артем Галай on 18.11.22.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    var user: UserInfo? { get set }
    var gender: [String] { get }
    var isEdit: Bool { get set }

    func readUser()
    func editUser()
}

final class DetailPresenter: DetailPresenterProtocol {

    // MARK: - Property

    weak var view: DetailViewProtocol?
    var gender = [Constant.genderMan, Constant.genderWoman]
    var isEdit = true
    var user: UserInfo?

    // MARK: - Funcs

    func readUser() {
        if let user = user {
            view?.userTextField.text = user.fullName
            view?.dateOfBirthPicker.date = user.dateOfBirth ?? Date()
            view?.genderTextField.text = user.gender
        }
    }

    func editUser() {
        if isEdit {
            view?.userTextField.isEnabled = true
            view?.dateOfBirthPicker.isEnabled  = true
            view?.genderTextField.isEnabled = true
            view?.editButton.setTitle(Constant.setTitleButtonSave, for: .normal)
            view?.editButton.setTitleColor(.systemRed, for: .normal)
            isEdit = false
        } else if !isEdit {
            view?.editButton.setTitle(Constant.setTitleButtonEdit, for: .normal)
            view?.editButton.setTitleColor(.black, for: .normal)
            view?.userTextField.isEnabled = false
            view?.dateOfBirthPicker.isEnabled  = false
            view?.genderTextField.isEnabled = false
            isEdit = true
            if user == nil {
                user = UserInfo()
            }
            if let user = user {
                user.fullName = view?.userTextField.text
                user.dateOfBirth = view?.dateOfBirthPicker.date
                user.gender = view?.genderTextField.text
                CoreDataManager.instance.saveContext()
            }
        }
    }
}

// MARK: - Constants

extension DetailPresenter {
    struct Constant {
        static let genderMan = "Мужской"
        static let genderWoman = "Женский"
        static let setTitleButtonSave = "Save"
        static let setTitleButtonEdit = "Edit"
    }
}
