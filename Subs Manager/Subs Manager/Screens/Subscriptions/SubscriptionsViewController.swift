//
//  SubscriptionsViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import UIKit
import RealmSwift

class SubscriptionsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var helloNameLabel: UILabel!
    @IBOutlet weak var allExpensesLabel: UILabel!

    private let realmDataStore = RealmDataStore.shared
    private var user: User?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        setUpCollectionView()
    }

    @IBAction func tappedAddButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddSubscriptionScreen", bundle: nil)
        let controller = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "AddSubscriptionScreen"))
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true, completion: nil)
    }

    @IBAction func tappedStatisticsButton(_ sender: UIButton) {

    }

    @IBAction func tappedFilterButton(_ sender: UIButton) {

    }

    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "SubscriptionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "subscriptionCell")
    }

    private func getCurrentUser() {
        if let currentUserLogin = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserLogin) {
            user = realmDataStore.getUser(with: currentUserLogin)
            setUpLabels()
        }
    }

    private func setUpLabels() {
        helloNameLabel.text = "Hello, \(user?.name ?? "")"
    }
}

// MARK: -
// MARK: - UICollectionViewDelegate

extension SubscriptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.subscription.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCell", for: indexPath) as? SubscriptionCollectionViewCell {
            if let userSubscription = user?.subscription {
                cell.setUpCell(userSubscription[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow = 2
        let spaceBetweenCells = 5
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (Int(screenWidth) - spaceBetweenCells * (numberOfCellsInRow + 1)) / numberOfCellsInRow
        return CGSize(width: cellWidth, height: 250)
    }
}
