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
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var menuView: UIView!

    private let realmDataStore = RealmDataStore.shared
    private let notification = NotificationManager()
    private var chosenCategory: CategoryEnum?
    private var chosenCurrency: CurrencyEnum = .usd
    private var user: User?
    private var userSubscriptions: UserSubscription?
    private var userNotification: NotificationToken?
    private var isButtonActive = false

    private var filteredData: [UserSubscription] {
        guard let chosenCategory = chosenCategory else {
            return user?.subscriptions.toArray() ?? []
        }
        return user?.subscriptions.filter { $0.category == chosenCategory.rawValue } ?? []
    }

    private var reducedAmount: Int {
        return user?.subscriptions.filter { $0.currency == self.chosenCurrency.rawValue }
                                .compactMap { Int($0.amount) }
                                .reduce(0, { $0 + $1 }) ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        getCurrentUser()
        setUpCollectionView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        if touch?.view != menuView {
            menuView.isHidden = true
        }
    }

    deinit {
        userNotification?.invalidate()
    }

    @IBAction private func tappedAddButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddSubscriptionScreen", bundle: nil)
        let controller = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "AddSubscriptionScreen"))
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true, completion: nil)
    }

    @IBAction private func tappedStatisticsButton(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "StatisticsScreen", bundle: nil)
        let statisticsViewController = storyBoard.instantiateViewController(withIdentifier: "StatisticsScreen")
        navigationController?.pushViewController(statisticsViewController, animated: true)
    }

    @IBAction private func tappedFilterButton(_ sender: UIButton) {
        if isButtonActive {
            menuView.isHidden = true
        } else {
            menuView.isHidden = false
        }
        isButtonActive = !isButtonActive
    }

    @IBAction private func tappedCategoryButton(_ sender: UIButton) {
        var chosenCategory: CategoryEnum?
        for category in CategoryEnum.allCases {
            if category.tag == sender.tag {
                chosenCategory = category
                break
            }
        }
        self.chosenCategory = chosenCategory
        menuView.isHidden = true
        collectionView.reloadData()
    }

    @IBAction private func tappedArrowUpButton(_ sender: UIButton) {

    }

    private func setUpView() {
        menuView.layer.cornerRadius = 20
        menuView.isHidden = true
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

            userNotification = user?.subscriptions.observe { [weak self] _ in
                self?.user?.subscriptions.forEach {
                    self?.realmDataStore.updatePaymentDateIfNeeded(model: $0)
                }
                self?.setUpAmountLabel()
                self?.collectionView.reloadData()
            }
            setUpLabels()
        }
    }

    private func setUpLabels() {
        helloNameLabel.text = "Hello, \(user?.name ?? "")"
    }

    private func setUpAmountLabel() {
        allExpensesLabel.text = "\(chosenCurrency.rawValue) \(reducedAmount)" + ",00"
    }
}

// MARK: -
// MARK: - UICollectionViewDelegate

extension SubscriptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "subscriptionCell", for: indexPath) as? SubscriptionCollectionViewCell {
            cell.setUpCell(filteredData[indexPath.row], delegate: self)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInRow = 2
        let spaceBetweenCells = 5
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (Int(screenWidth) - spaceBetweenCells * (numberOfCellsInRow + 1)) / numberOfCellsInRow
        return CGSize(width: cellWidth, height: 270)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "SubscriptionInfoScreen", bundle: nil)
        if let subscriptionInfoViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionInfoScreen") as? SubscriptionInfoViewController {
            subscriptionInfoViewController.setUp(with: filteredData[indexPath.row], typeOfController: .edit)
            navigationController?.pushViewController(subscriptionInfoViewController, animated: true)
        }
    }
}

// MARK: -
// MARK: - DeleteUserSubscription

extension SubscriptionsViewController: DeleteUserSubscriptionDelegate {

    func deleteUserSubscription(subscriptionID: UUID) {
        realmDataStore.deleteSubscription(with: subscriptionID)
    }
}
