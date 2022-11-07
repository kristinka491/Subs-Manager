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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setUpView() {
        subscriptionView.layer.cornerRadius = 20
    }

    func setUpCell(_ subscription: Subscription) {
        subscriptionImage.image = subscription.image
        subscriptionNameLabel.text = subscription.name
    }
}
