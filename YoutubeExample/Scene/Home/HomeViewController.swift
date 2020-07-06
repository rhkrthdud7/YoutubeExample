//
//  HomeViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit
import SnapKit
import Then

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {

    weak var listener: HomePresentableListener?

    let disposeBag = DisposeBag()
    var constraintNavTop: NSLayoutConstraint?

    private enum Color {
        static let lightBlack = 0x282828.color
        static let darkBlack = 0x212121.color
    }
    private enum Metrics {
        static let navigationBarHeight: CGFloat = 44
    }

    let viewNavigationBar = UIView().then {
        $0.backgroundColor = Color.lightBlack
    }

    let viewBarContent = UIView().then {
        $0.backgroundColor = .clear
    }

    let viewContent = UIView().then {
        $0.backgroundColor = Color.darkBlack
    }

    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = Color.darkBlack
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    let data: [String] = [
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
    ]
}

extension HomeViewController {
    func setupViews() {
        view.backgroundColor = Color.lightBlack

        view.addSubview(viewNavigationBar)
        constraintNavTop = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: viewNavigationBar.topAnchor)
        constraintNavTop?.isActive = true
        viewNavigationBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metrics.navigationBarHeight)
        }
        viewNavigationBar.addSubview(viewBarContent)
        viewBarContent.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let navigationBar = NavigationBar(subviews: [])
        viewBarContent.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        view.addSubview(viewContent)
        viewContent.snp.makeConstraints {
            $0.top.equalTo(viewNavigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        viewContent.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }

    func setupBindings() {
        guard let constraint = constraintNavTop else { return }
        let viewNavigationBar = self.viewNavigationBar
        let viewBarContent = self.viewBarContent
        let constraintConstant = PublishSubject<CGFloat>()
        let height = Metrics.navigationBarHeight

        // 현재 오프셋
        let contentOffset = tableView.rx.contentOffset

        // 현재 스크롤 차이
        let scrollOffsetDiff = Observable
            .zip(contentOffset, contentOffset.skip(1))
            .filter { $0.1.y > 0 }
            .map { $0.1.y - $0.0.y }
            .distinctUntilChanged()

        // scrollDown -> 네비게이션 위로(숨김)
        contentOffset
            .withLatestFrom(scrollOffsetDiff) { ($0, $1) }
            .filter { $0.1 > 0 }
            .map { constraint.constant + $1 }
            .map { min(max($0, 0), height) }
            .bind(to: constraintConstant)
            .disposed(by: disposeBag)

        // scrollUp -> 네비게이션 아래로(보이기) - y < 0 일때
        contentOffset
            .withLatestFrom(scrollOffsetDiff) { ($0, $1) }
            .filter { (offset: CGPoint, diff: CGFloat) -> Bool in diff < 0 && offset.y < 0 }
            .map { constraint.constant + $1 }
            .map { min(max($0, 0), height) }
            .bind(to: constraintConstant)
            .disposed(by: disposeBag)

        // constant 설정
        constraintConstant
            .bind(to: constraint.rx.constant)
            .disposed(by: disposeBag)

        // alpha 설정
        constraintConstant
            .map { 1 - $0 / 44.0 }
            .bind(to: viewBarContent.rx.alpha)
            .disposed(by: disposeBag)

        // 위 / 아래 스크롤 날렸을때
        let willEndDragging = tableView.rx.willEndDragging
            .withLatestFrom(contentOffset) { ($0.0, $1) }
            .filter { $0.0.y != 0 && $0.1.y > height }
            .map { $0.0.y < 0 ? 0 : height }

        // 최상단에 도착했을때 동작
        let didEndDragging = tableView.rx.didEndDragging
            .filter { !$0 }
            .withLatestFrom(contentOffset)
            .filter { $0.y <= 0 }
            .map { _ in CGFloat.zero }

        // 탭바가 보이는 상황에서 스크롤을 놨을때 동작
        let didEndDragging2 = tableView.rx.didEndDragging
            .filter { !$0 }
            .withLatestFrom(contentOffset)
            .filter { $0.y > 0 }
            .withLatestFrom(constraintConstant)
            .map { $0 < height / 2 ? 0 : height }

        let didScrollToTop = tableView.rx.didScrollToTop
            .map { _ in CGFloat.zero }

        Observable.of(willEndDragging, didEndDragging,
            didEndDragging2, didScrollToTop).merge()
            .subscribe(onNext: { constant in
                UIView.animate(withDuration: 0.15, animations: {
                    viewBarContent.alpha = constant == 0 ? 1 : 0
                    constraint.constant = constant
                    viewNavigationBar.superview?.layoutIfNeeded()
                }) { _ in
                    constraintConstant.onNext(constant)
                }
            })
            .disposed(by: disposeBag)

    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = Color.darkBlack
        return cell
    }

}
