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
    @IBOutlet weak var remindMeTextField: UITextField!

    private let pickerView = ToolbarPickerView()

    private var subscriptionModel: Subscription?
    private var currentSelectedTextFieldType: PickerTypeEnum = .currency

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpPicker()
        setUpDatePicker()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {

    }

    func setUp(with model: Subscription) {
        subscriptionModel = model
    }

    private func setUpView() {
        subscriptionNameLabel.text = subscriptionModel?.name
        subscriptionImageView.image = subscriptionModel?.image
    }

    private func setUpPicker() {
        [currencyTextField, remindMeTextField].forEach { texField in
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
        let selectedData = currentSelectedTextFieldType.array[row]
        switch currentSelectedTextFieldType {
        case .currency:
            currencyTextField.text = selectedData
        case .remindMe:
            remindMeTextField.text = selectedData
        }
    }
}


// MARK: -
// MARK: - ToolBarPickerViewDelegate

extension SubscriptionInfoViewController: ToolbarPickerViewDelegate {

    func didTapDone() {
        switch currentSelectedTextFieldType {
        case .currency:
            currencyTextField.resignFirstResponder()
        case .remindMe:
            remindMeTextField.resignFirstResponder()
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
        default:
            break
        }
        pickerView.reloadAllComponents()
        return true
    }
}
