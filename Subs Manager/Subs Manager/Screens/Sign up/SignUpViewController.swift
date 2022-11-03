//
//  ViewController.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 03.11.2022.
//

import UIKit

class SignUpViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    var contentWidth: CGFloat = 0.0
    let greetingView = GreetingView()
    let signUpView = SignUpView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollView()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(414))
    }

    private func setUpScrollView() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.addSubview(greetingView)
        scrollView.addSubview(signUpView)

        for i in 0...1 {
            let xCoordinate = view.frame.width * CGFloat(i)
            contentWidth += view.frame.width
            greetingView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            signUpView.frame = CGRect(x: xCoordinate, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
    }
}

