//
//  RegistrationViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 04.11.2022.
//

import UIKit

class SignUpViewController: SetUpKeyboardViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let isUserRegistered = RealmDataStore.shared.isUserRegistered(with: loginTextField.text ?? "")
        if textField == loginTextField && isUserRegistered {
            showAlert(alertText: "Sorry", alertMessage: "Unfortunately, this login is busy", completion: nil)
        }
    }

    private var isNotEmpty: Bool {
        let nameValue = nameTextField.text
        let loginValue = loginTextField.text
        let passwordValue = passwordTextField.text
        if let nameValue = nameValue,
            let loginValue = loginValue,
            let passwordValue = passwordValue  {
            if !nameValue.isEmpty && !loginValue.isEmpty && !passwordValue.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

    @IBAction private func tappedCreateAccountButton() {
        if isNotEmpty {
            registerUser()
            showAlert(alertText: "Thank you!", alertMessage: "Account was created.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
        }} else {
            showAlert(alertText: "Error", alertMessage: "Please fill in all the forms", completion: nil)
        }
    }

    @IBAction private func tappedBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    private func registerUser() {
        let isUserSaved = RealmDataStore.shared.addUser(name: nameTextField.text ?? "",
            login: loginTextField.text ?? "",
            password: passwordTextField.text ?? "")
        if !isUserSaved {
            showAlert(alertText: "Something went wrong", alertMessage: "This user is already signed up") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
