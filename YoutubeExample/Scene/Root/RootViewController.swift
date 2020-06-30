//
//  RootViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?

    // MARK: - Private
    private var targetViewController: ViewControllable?
    private var animationInProgress = false

    private func presentTargetViewController() {
        if let targetViewController = targetViewController {
            animationInProgress = true
            present(targetViewController.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }

    // MARK: - RootViewControllable
    func replaceModal(viewController: ViewControllable?) {
        targetViewController = viewController

        guard !animationInProgress else { return }

        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                guard let this = self else { return }

                if this.targetViewController != nil {
                    this.presentTargetViewController()
                } else {
                    this.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
    }

}
