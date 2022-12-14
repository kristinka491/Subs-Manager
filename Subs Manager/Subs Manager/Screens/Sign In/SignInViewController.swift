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
        signInView.setUpDelegate(delegate: self)
        setUpScrollView()
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupContentHeight()
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.addSubview(greetingView)
        scrollView.addSubview(signInView)
    }

    private func setupContentHeight() {
        let height = scrollView.frame.height
        greetingView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: height)
        signInView.frame = CGRect(x: view.frame.width, y: 0, width: view.frame.size.width, height: height)
        scrollView.contentSize = CGSize(width: 2 * view.frame.width, height: height)
    }

    private func navigateToSubscriptionsScreen() {
        view.window?.rootViewController = viewController(storyboardName: "SubscriptionsScreen", identifier: "SubscriptionsScreen", isNavigation: true)
        view.window?.makeKeyAndVisible()
    }
}

// MARK: -
// MARK: - UIScrollViewDelegate

extension SignInViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(view.frame.size.width))
    }
}

// MARK: -
// MARK: - MoveToAnotherScreenDelegate

extension SignInViewController: MoveToAnotherScreenDelegate {

    func moveToRegistrationScreen() {
        let controller = viewController(storyboardName: "SignUpScreen", identifier: "SignUpScreen")
        navigationController?.pushViewController(controller, animated: true)
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
