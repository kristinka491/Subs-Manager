//
//  SubscriptionInfoViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 07.11.2022.
//

import UIKit

class SubscriptionInfoViewController: UIViewController {

    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var subscriptionCurrencyLabel: UILabel!
    @IBOutlet weak var subscriptionAmountTextField: UITextField!
    @IBOutlet weak var subscriptionPaymentDateLabel: UILabel!
    @IBOutlet weak var subscriptionRemindMeLabel: UILabel!

    private var picker: UIPickerView?
    private let currencyArray: [String] = ["USD($)", "EUR(€)", "GBP(£)", "CNY(¥)", "PLN(zł)", "CAD($)"]
    private var subscriptionModel: Subscription?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpPicker()
    }

    func setUp(with model: Subscription) {
        subscriptionModel = model
    }

    private func setUpView() {
        subscriptionNameLabel.text = subscriptionModel?.name
        subscriptionImageView.image = subscriptionModel?.image
    }

    private func setUpPicker() {
        picker = UIPickerView(frame: CGRect(x: 0, y: view.bounds.height - 100, width: self.view.bounds.width, height: 100))
        if let picker = picker {
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = true
            view.addSubview(picker)
        }

        let tapRound = UITapGestureRecognizer(target: self,
                                              action: #selector(self.handleTap(_:)))
        subscriptionCurrencyLabel.addGestureRecognizer(tapRound)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        picker?.isHidden = false
    }
}

// MARK: -
// MARK: - UIPickerViewDelegate

extension SubscriptionInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            subscriptionCurrencyLabel.text = currencyArray[row]
            self.view.endEditing(true)
        }
}
