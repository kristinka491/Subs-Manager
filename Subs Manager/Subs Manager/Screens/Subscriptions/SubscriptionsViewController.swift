//
//  SubscriptionsViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import UIKit

class SubscriptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddSubscriptionScreen", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddSubscriptionScreen") as! AddSubscriptionViewController
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
}
