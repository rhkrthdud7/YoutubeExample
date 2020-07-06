//
//  MainTabViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SwiftyColor

protocol MainTabPresentableListener: class { }

final class MainTabViewController: UITabBarController, MainTabPresentable, MainTabViewControllable {

    weak var listener: MainTabPresentableListener?

    private enum Color {
        static let tabBarTint = 0x282828.color
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .white
        tabBar.barTintColor = Color.tabBarTint
    }

    // MARK: - MainTabViewControllable
    func setViewControllers(viewControllers: [ViewControllable], animated: Bool = false) {
        let viewControllers = viewControllers.map { $0.uiviewController }
        setViewControllers(viewControllers, animated: false)
    }

    func showViewController(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }

    func dismissViewController(completion: (() -> Void)?) {
        dismiss(animated: true, completion: completion)
    }
}
