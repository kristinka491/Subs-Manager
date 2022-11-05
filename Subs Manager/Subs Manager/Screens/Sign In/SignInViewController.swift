//
//  ViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

class SignInViewController: UIViewController, UIScrollViewDelegate, MoveToAnotherScreenDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    private var contentWidth: CGFloat = 0.0
    let greetingView = GreetingView()
    let signInView = SignInView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        signInView.setUpDelegate(delegate: self)
        setUpScrollView()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
    }

    func moveToAnotherScreen() {
        let storyBoard = UIStoryboard(name: "SignUpScreen", bundle: nil)
        let signUpViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpScreen") as! SignUpViewController
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.addSubview(greetingView)
        scrollView.addSubview(signInView)

        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
            for i in 0...1 {
                let xCoordinate = view.frame.width * CGFloat(i)
                contentWidth += view.frame.width
                greetingView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - navigationBarHeight)
                signInView.frame = CGRect(x: xCoordinate, y: 0, width: view.frame.size.width, height: view.frame.size.height - navigationBarHeight)
            }
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height - navigationBarHeight)
        }
    }
}

