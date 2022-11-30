//
//  UIPickerView+ViewControllerExtension.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 08.11.2022.
//

import UIKit

protocol ToolbarPickerViewDelegate: AnyObject {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    private(set) var toolbar: UIToolbar?
    weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 50.0))
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc private func doneTapped() {
        toolbarDelegate?.didTapDone()
    }

    @objc private func cancelTapped() {
        toolbarDelegate?.didTapCancel()
    }
}
