//
//  UINavigationController+.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import UIKit
import RIBs

extension UINavigationController: ViewControllable {
    public var uiviewController: UIViewController { return self }

    public convenience init(root: ViewControllable) {
        self.init(rootViewController: root.uiviewController)
    }
}
