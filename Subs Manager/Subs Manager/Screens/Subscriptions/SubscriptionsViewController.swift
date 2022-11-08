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
        let controller = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "AddSubscriptionScreen"))
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true, completion: nil)
    }
}
