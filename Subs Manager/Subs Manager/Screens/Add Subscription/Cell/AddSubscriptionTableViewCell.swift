//
//  AddSubscriptionTableViewCell.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 07.11.2022.
//

import UIKit

class AddSubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var subscriptionImage: UIImageView!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var subscriptionView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    func setUpCell(_ subscription: SubscriptionEnum) {
        subscriptionImage.image = subscription.image
        subscriptionNameLabel.text = subscription.rawValue
    }

    private func setUpView() {
        subscriptionView.layer.cornerRadius = 20
    }
}
