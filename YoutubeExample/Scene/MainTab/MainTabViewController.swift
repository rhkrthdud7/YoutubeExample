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

protocol MainTabPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class MainTabViewController: UITabBarController, MainTabPresentable, MainTabViewControllable {

    weak var listener: MainTabPresentableListener?
}
