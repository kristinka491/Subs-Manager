//
//  AddSubscriptionViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 07.11.2022.
//

import UIKit

class AddSubscriptionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var filteredData = SubscriptionEnum.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpSearchBar()
        navigationController?.navigationBar.isHidden = true
    }

    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddSubscriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "subscriptionCell")
    }

    private func setUpSearchBar() {
        searchBar.delegate = self
    }
}

// MARK: -
// MARK: - UITableViewDelegate

extension AddSubscriptionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptionCell", for: indexPath) as? AddSubscriptionTableViewCell {
            cell.setUpCell(filteredData[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let controller = viewController(storyboardName: "SubscriptionInfoScreen", identifier: "SubscriptionInfoScreen") as? SubscriptionInfoViewController {
            controller.setUp(with: filteredData[indexPath.row], typeOfController: .add)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: -
// MARK: - UISearchBarDelegate


extension AddSubscriptionViewController: UISearchBarDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let subscriptions = SubscriptionEnum.allCases
        filteredData = searchText.isEmpty ? subscriptions : subscriptions.filter( { $0.rawValue.localizedCaseInsensitiveContains(searchText) })
        tableView.reloadData()
    }
}



