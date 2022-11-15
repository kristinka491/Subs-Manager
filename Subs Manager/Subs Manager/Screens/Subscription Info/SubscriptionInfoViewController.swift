//
//  SubscriptionInfoViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 07.11.2022.
//

import UIKit

class SubscriptionInfoViewController: SetUpKeyboardViewController {

    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var paymentDateTextField: UITextField!
    @IBOutlet weak var paymentCycleTextField: UITextField!
    @IBOutlet weak var remindMeTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    enum TypeOfController: String {
        case add
        case edit
    }

    private let pickerView = ToolbarPickerView()
    private let realmDataStore = RealmDataStore.shared
    private var currentSelectedTextFieldType: PickerTypeEnum = .currency
    private var typeOfController: TypeOfController = .add
    private var subscriptionType: SubscriptionEnum?
    private var userSubscription: UserSubscription?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpPicker()
        setUpDatePicker()
        setUpTextFields()
        setUpButton()
    }

    private var isEnable: Bool {
        return !currencyTextField.text.isEmptyOrNil && !amountTextField.text.isEmptyOrNil
            && !paymentDateTextField.text.isEmptyOrNil && !paymentCycleTextField.text.isEmptyOrNil
            && !remindMeTextField.text.isEmptyOrNil && !categoryTextField.text.isEmptyOrNil
    }

    private var isChangedData: Bool {
        if typeOfController == .edit {
            if let userSubscription = userSubscription {
                return userSubscription.currency != currencyTextField.text || userSubscription.amount != amountTextField.text
                || userSubscription.paymentDate != paymentDateTextField.text || userSubscription.paymentCycle != paymentCycleTextField.text
                || userSubscription.remindMe != remindMeTextField.text ||  userSubscription.category != categoryTextField.text
            }
            return true
        }
        return true
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        if typeOfController == .add {
            addUserSubscription()
        } else {
            updateUserSubscription()
        }
    }

    func setUp(with type: SubscriptionEnum, typeOfController: TypeOfController) {
        subscriptionType = type
        self.typeOfController = typeOfController
    }

    func setUp(with model: UserSubscription?, typeOfController: TypeOfController) {
        userSubscription = model
        subscriptionType = SubscriptionEnum(rawValue: userSubscription?.subscriptionName ?? "")
        self.typeOfController = typeOfController
    }

    private func setUpTextFields() {
        if typeOfController == .edit {
            if let userSubscription = userSubscription {
                currencyTextField.text = "\(userSubscription.currency)"
                amountTextField.text = "\(userSubscription.amount)"
                paymentDateTextField.text = "\(userSubscription.paymentDate)"
                paymentCycleTextField.text = "\(userSubscription.paymentCycle)"
                remindMeTextField.text = "\(userSubscription.remindMe)"
                categoryTextField.text = "\(userSubscription.category)"
            }
        }
    }

    private func setUpButtonActivity() {
        let isEnable = isEnable && isChangedData
        addButton.isUserInteractionEnabled = isEnable
        addButton.backgroundColor = !isEnable ? .gray : .black
    }

    private func setUpView() {
        subscriptionNameLabel.text = subscriptionType?.rawValue
        subscriptionImageView.image = subscriptionType?.image
    }

    private func setUpButton() {
        addButton.layer.cornerRadius = 20
        addButton.setTitle(typeOfController == .edit ? "Save changes" : "Add",
                                   for: .normal)
    }

    private func setUpPicker() {
        [currencyTextField, remindMeTextField, paymentCycleTextField, categoryTextField].forEach { texField in
            texField?.inputView = pickerView
            texField?.inputAccessoryView = pickerView.toolbar
        }

        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.toolbarDelegate = self
        pickerView.reloadAllComponents()
    }

    private func setUpDatePicker() {
        paymentDateTextField.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
    }

    private func moveToSignInScreen() {
        showAlert(alertText: "Something went wrong", alertMessage: "This user is not signed in") { [weak self] in
            let storyBoard = UIStoryboard(name: "SignInScreen", bundle: nil)
            let viewController = storyBoard.instantiateViewController(withIdentifier: "SignInScreen")
            let navigationViewController = UINavigationController(rootViewController: viewController)
            self?.view.window?.rootViewController = navigationViewController
            self?.view.window?.makeKeyAndVisible()
        }
    }

    @objc func dateSelected() {
           if let datePicker = paymentDateTextField.inputView as? UIDatePicker {
               let dateFormatter = DateFormatter()
               dateFormatter.dateStyle = .medium
               paymentDateTextField.text = dateFormatter.string(from: datePicker.date)
           }
           paymentDateTextField.resignFirstResponder()
    }

    private func addUserSubscription() {
        let isUserSubscriptionSaved = realmDataStore.addUserSubscription(subscriptionName: subscriptionNameLabel.text ?? "",
                                                                         currency: currencyTextField.text ?? "",
                                                                         amount: amountTextField.text ?? "",
                                                                         paymentCycle: paymentCycleTextField.text ?? "",
                                                                         paymentDate: paymentDateTextField.text ?? "",
                                                                         remindMe: remindMeTextField.text ?? "",
                                                                         category: categoryTextField.text ?? "")
        
        if !isUserSubscriptionSaved {
            moveToSignInScreen()
        } else {
            showAlert(alertText: "Thank you!", alertMessage: "Subscription was created.") { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    private func updateUserSubscription() {
        guard let subscriptionId = userSubscription?.id else {
            return
        }

        let userSubscriptionUpdated = realmDataStore.updateSubscription(subscriptionId: subscriptionId,
                                                                        currency: currencyTextField.text ?? "",
                                                                        amount: amountTextField.text ?? "",
                                                                        paymentCycle: paymentCycleTextField.text ?? "",
                                                                        paymentDate: paymentDateTextField.text ?? "",
                                                                        remindMe: remindMeTextField.text ?? "",
                                                                        category: categoryTextField.text ?? "")
        if !userSubscriptionUpdated {
            
        } else {
            showAlert(alertText: "Thank you!", alertMessage: "Changes were saved.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: -
// MARK: - UIPickerViewDelegate

extension SubscriptionInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentSelectedTextFieldType.array.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currentSelectedTextFieldType.array[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       setupTextField(with: row)
    }

    private func setupTextField(with selectedRow: Int) {
        let selectedData = currentSelectedTextFieldType.array[selectedRow]
        switch currentSelectedTextFieldType {
        case .currency:
            currencyTextField.text = selectedData
        case .remindMe:
            remindMeTextField.text = selectedData
        case .paymentCycle:
            paymentCycleTextField.text = selectedData
        case .category:
            categoryTextField.text = selectedData
        }
    }
}


// MARK: -
// MARK: - ToolBarPickerViewDelegate

extension SubscriptionInfoViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        let row = pickerView.selectedRow(inComponent: 0)
        setupTextField(with: row)

        switch currentSelectedTextFieldType {
        case .currency:
            currencyTextField.resignFirstResponder()
        case .remindMe:
            remindMeTextField.resignFirstResponder()
        case .paymentCycle:
            paymentCycleTextField.resignFirstResponder()
        case .category:
            categoryTextField.resignFirstResponder()
        }
    }

    func didTapCancel() {
        switch currentSelectedTextFieldType {
        case .currency:
            currencyTextField.text = nil
            currencyTextField.resignFirstResponder()
        case .remindMe:
            remindMeTextField.text = nil
            remindMeTextField.resignFirstResponder()
        case .paymentCycle:
            paymentCycleTextField.text = nil
            paymentCycleTextField.resignFirstResponder()
        case .category:
            categoryTextField.text = nil
            categoryTextField.resignFirstResponder()
        }
    }
}


// MARK: -
// MARK: - UITextFieldDelegate

extension SubscriptionInfoViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        switch textField {
        case currencyTextField:
            currentSelectedTextFieldType = .currency
        case remindMeTextField:
            currentSelectedTextFieldType = .remindMe
        case paymentCycleTextField:
            currentSelectedTextFieldType = .paymentCycle
        case categoryTextField:
            currentSelectedTextFieldType = .category
        default:
            break
        }
        pickerView.reloadAllComponents()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setUpButtonActivity()
    }
}
