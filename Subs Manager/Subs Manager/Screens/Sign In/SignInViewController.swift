//
//  ViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

class SignInViewController: SetUpKeyboardViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    private let greetingView = GreetingView()
    private let signInView = SignInView()
    private let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        signInView.setUpDelegate(delegate: self)
        setUpScrollView()
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.addSubview(greetingView)
        scrollView.addSubview(signInView)

        if let navBarHeight = navigationController?.navigationBar.frame.height {
            let height = view.frame.height - navBarHeight
            greetingView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
                signInView.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.size.width, height: height)
            scrollView.contentSize = CGSize(width: 2 * view.frame.width, height: height)
        }
    }

    private func navigateToSubscriptionsScreen() {
        let storyBoard = UIStoryboard(name: "SubscriptionsScreen", bundle: nil)
        let subscriptionsViewController = storyBoard.instantiateViewController(withIdentifier: "SubscriptionsScreen")
        navigationController?.pushViewController(subscriptionsViewController, animated: true)
    }
}

// MARK: -
// MARK: - UIScrollViewDelegate

extension SignInViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
    }
}

// MARK: -
// MARK: - MoveToAnotherScreenDelegate

extension SignInViewController: MoveToAnotherScreenDelegate {

    func moveToRegistrationScreen() {
        let storyBoard = UIStoryboard(name: "SignUpScreen", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpScreen")
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    func moveToSubscriptionsScreen(login: String?, password: String?, isRemembered: Bool) {
        if !login.isEmptyOrNil && !password.isEmptyOrNil {
            if RealmDataStore.shared.getUser(login: login ?? "", password: password ?? "") != nil {
                userDefaults.set(isRemembered, forKey: UserDefaultsKeys.isUserRemembered)
                userDefaults.set(true, forKey: UserDefaultsKeys.isUserLoggedIn)
                userDefaults.set(login, forKey: UserDefaultsKeys.currentUserLogin)
                navigateToSubscriptionsScreen()
            } else {
                showAlert(alertText: "Please try again", alertMessage: "Wrong e-mail or password", completion: nil)
            }
        } else {
            showAlert(alertText: "Error", alertMessage: "Please enter e-mail and password", completion: nil)
        }
    }
}

