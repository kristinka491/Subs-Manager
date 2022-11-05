//
//  GreetingView.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

class GreetingView: UIView {

    @IBOutlet weak var greetingView: UIView!

    private let kCONTENT_XIB_NAME = "GreetingView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        greetingView.setUpView(self)
    }
}

