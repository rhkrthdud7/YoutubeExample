//
//  SplashViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then

protocol SplashPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func didFinishSplashAnimation()
}

final class SplashViewController: UIViewController, SplashPresentable, SplashViewControllable {

    weak var listener: SplashPresentableListener?

    let disposeBag = DisposeBag()

    let imageViewLogo = UIImageView().then {
        $0.image = #imageLiteral(resourceName: "icon_logo")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Observable.just(())
            .take(1)
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.didFinishSplashAnimation()
            })
            .disposed(by: disposeBag)
    }

    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(imageViewLogo)
        imageViewLogo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
