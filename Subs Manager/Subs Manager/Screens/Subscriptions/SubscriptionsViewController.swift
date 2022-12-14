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
    private let numberOfCellsInRow = 2
    private let spaceBetweenCells = 5
    private var chosenCategory: CategoryEnum?
    private var chosenCurrency: CurrencyEnum = .usd
    private var user: User?
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
        setUpNavigationBar()
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
        let controller = viewController(storyboardName: "AddSubscriptionScreen", identifier: "AddSubscriptionScreen", isNavigation: true)
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true, completion: nil)
    }

    @IBAction private func tappedStatisticsButton(_ sender: UIButton) {
        if let controller = viewController(storyboardName: "StatisticsScreen", identifier: "StatisticsScreen") as? StatisticsViewController {
            controller.setUp(with: user?.subscriptions.toArray())
            navigationController?.pushViewController(controller, animated: true)
        }
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
        setUpNextAmount()
    }

    @IBAction private func tappedLogOutButton(_ sender: UIButton) {
        cleanSavedData()
        moveToSignInScreen()
    }

    private func setUpNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }

    private func cleanSavedData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.currentUserLogin)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isUserLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isUserRemembered)
    }

    private func setUpView() {
        menuView.layer.cornerRadius = 20
        menuView.isHidden = true
    }

    private func setUpNextAmount() {
        chosenCurrency = chosenCurrency.next()
        setUpAmountLabel()
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
        if reducedAmount != 0 {
            allExpensesLabel.text = "\(chosenCurrency.rawValue) \(reducedAmount)" + ",00"
        } else if reducedAmount == 0 && user?.subscriptions.count != 0 {
            setUpNextAmount()
        }
    }

    private func moveToSignInScreen() {
        view.window?.rootViewController = viewController(storyboardName: "SignInScreen", identifier: "SignInScreen", isNavigation: true)
        view.window?.makeKeyAndVisible()
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
