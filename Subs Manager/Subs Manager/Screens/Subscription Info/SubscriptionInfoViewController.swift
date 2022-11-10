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

    private let pickerView = ToolbarPickerView()
    private let realmDataStore = RealmDataStore.shared

    private var subscriptionType: SubscriptionEnum?
    private var currentSelectedTextFieldType: PickerTypeEnum = .currency

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpPicker()
        setUpDatePicker()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        addUserSubscription()
        showAlert(alertText: "Thank you!", alertMessage: "Subscription was created.") { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    func setUp(with type: SubscriptionEnum) {
        subscriptionType = type
    }

    private func setUpView() {
        subscriptionNameLabel.text = subscriptionType?.rawValue
        subscriptionImageView.image = subscriptionType?.image
    }

    private func setUpPicker() {
        [currencyTextField, remindMeTextField, paymentCycleTextField].forEach { texField in
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
                                                                         paymentDate: paymentDateTextField.text ?? "")
        
        if !isUserSubscriptionSaved {
            showAlert(alertText: "Something went wrong", alertMessage: "This user is not signed in") { [weak self] in
                let storyBoard = UIStoryboard(name: "SignInScreen", bundle: nil)
                let viewController = storyBoard.instantiateViewController(withIdentifier: "SignInScreen")
                self?.view.window?.rootViewController = viewController
                self?.view.window?.makeKeyAndVisible()
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
        default:
            break
        }
        pickerView.reloadAllComponents()
        return true
    }
}
