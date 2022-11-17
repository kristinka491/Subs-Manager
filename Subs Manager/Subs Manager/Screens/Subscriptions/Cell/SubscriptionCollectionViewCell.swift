//
//  SubscriptionCollectionViewCell.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 10.11.2022.
//

import UIKit

protocol DeleteUserSubscriptionDelegate: AnyObject {
    func deleteUserSubscription(subscriptionID: UUID)
}

class SubscriptionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var subscriptionNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateOfNextPaymentLabel: UILabel!
    @IBOutlet weak var subView: UIView!

    private weak var delegate: DeleteUserSubscriptionDelegate?
    private var subscriptionID: UUID?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    @IBAction private func tappedCancelButton(_ sender: UIButton) {
        if let subscriptionID = subscriptionID {
            delegate?.deleteUserSubscription(subscriptionID: subscriptionID)
        }
    }

    func setUpCell(_ userSubscription: UserSubscription, delegate: DeleteUserSubscriptionDelegate) {
        subscriptionNameLabel.text = userSubscription.subscriptionName
        amountLabel.text = "\(userSubscription.amount) \(userSubscription.currency)"
        subscriptionImageView.image = SubscriptionEnum(rawValue: userSubscription.subscriptionName)?.image
        subscriptionID = userSubscription.id

        dateOfNextPaymentLabel.text = DateFormatterHepler.getDateString(from: userSubscription.paymentDate)
        self.delegate = delegate
    }

    private func setUpView() {
        subView.layer.cornerRadius = 20
    }
}
