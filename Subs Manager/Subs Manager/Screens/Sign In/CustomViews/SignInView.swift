//
//  SignInView.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

protocol MoveToAnotherScreenDelegate: AnyObject {
    func moveToRegistrationScreen()
    func moveToSubscriptionsScreen(login: String, password: String)
}

class SignInView: UIView {

    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var getOneButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    private weak var delegate: MoveToAnotherScreenDelegate?
    private var buttonActive = false
    private let kCONTENT_XIB_NAME = "SignInView"

    private var isNotEmpty: Bool {
        let loginValue = loginTextField.text
        let passwordValue = passwordTextField.text
        if let loginValue = loginValue,
            let passwordValue = passwordValue  {
            if !loginValue.isEmpty && !passwordValue.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    @IBAction func tappedGetOneButton(_ sender: UIButton) {
        delegate?.moveToRegistrationScreen()
    }

    @IBAction func tappedSignInButton(_ sender: UIButton) {
        delegate?.moveToSubscriptionsScreen(login: loginTextField.text ?? "",
                                            password: passwordTextField.text ?? "")
    }

    @IBAction func tappedRememberMeButton(_ sender: UIButton) {
        if buttonActive {
            rememberMeButton.setImage(UIImage(named: "uncheck"), for: .normal)
        } else {
            rememberMeButton.setImage(UIImage(named: "check"), for: .normal)
        }
        buttonActive = !buttonActive
    }

    func setUpDelegate(delegate: MoveToAnotherScreenDelegate) {
        self.delegate = delegate
    }

    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        signInView.setUpView(self)
    }
}


