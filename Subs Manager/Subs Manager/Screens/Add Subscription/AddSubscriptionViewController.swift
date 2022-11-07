//
//  AddSubscriptionViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 07.11.2022.
//

import UIKit

class AddSubscriptionViewController: SetUpKeyboardViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var filteredData = [Subscription]()
    private let subscriptions: [Subscription] = [Subscription(name: "Netflix", image: UIImage(named: "netflix")), Subscription(name: "Youtube", image: UIImage(named: "youtube")), Subscription(name: "Spotify", image: UIImage(named: "spotify")), Subscription(name: "Apple Music", image: UIImage(named: "appleMusic")), Subscription(name: "Dribbble", image: UIImage(named: "dribbble")), Subscription(name: "Skype", image: UIImage(named: "skype")), Subscription(name: "Evernote", image: UIImage(named: "evernote")), Subscription(name: "iCloud", image: UIImage(named: "iCloud")), Subscription(name: "Playstation Plus", image: UIImage(named: "playstationPlus")), Subscription(name: "Amazon", image: UIImage(named: "amazon")), Subscription(name: "Apple Developer Program", image: UIImage(named: "appleDeveloper")), Subscription(name: "Apple TV+", image: UIImage(named: "appleTV")), Subscription(name: "Dropbox", image: UIImage(named: "dropbox"))]

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpSearchBar()
        setUpStartDate()
    }

    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AddSubscriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "subscriptionCell")
    }

    private func setUpSearchBar() {
        searchBar.delegate = self
    }

    private func setUpStartDate() {
        filteredData = subscriptions
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

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyBoard = UIStoryboard(name: "WorkoutScreen", bundle: nil)
//        if let workoutItemViewController = storyBoard.instantiateViewController(withIdentifier: "workoutScreen") as? WorkoutItemViewController {
//            workoutItemViewController.setUp(with: filteredListOfExercises[indexPath.row], typeOfController: .edit)
//            navigationController?.pushViewController(workoutItemViewController, animated: true)
//        }
//
//    }
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
        filteredData = searchText.isEmpty ? subscriptions : subscriptions.filter( { $0.name.localizedCaseInsensitiveContains(searchText) })
        tableView.reloadData()
    }
}
