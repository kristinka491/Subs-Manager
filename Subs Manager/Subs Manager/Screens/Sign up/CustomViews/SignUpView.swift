//
//  SignUpView.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

class SignUpView: UIView {

    let kCONTENT_XIB_NAME = "SignUpView"
    @IBOutlet weak var signUpView: UIView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    @IBAction func tappedGetOneButton(_ sender: UIButton) {

    }

    @IBAction func tappedSignInButton(_ sender: UIButton) {

    }

    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        signUpView.setUpSignUpView(self)
    }
}

extension UIView {
    func setUpSignUpView(_ container: UIView) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
