//
//  SubscriptionCollectionViewCell.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 10.11.2022.
//

import UIKit

class SubscriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateOfNextPaymentLabel: UILabel!
    @IBOutlet weak var subView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    private func setUpView() {
        subView.layer.cornerRadius = 20
    }

    func setUpCell(_ userSubscription: UserSubscription) {
        subscriptionNameLabel.text = userSubscription.subscriptionName
        amountLabel.text = "\(userSubscription.amount) \(userSubscription.currency)"
        subscriptionImageView.image = SubscriptionEnum(rawValue: userSubscription.subscriptionName)?.image 
    }
}
