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
import ReactorKit
import SnapKit
import UIKit
import Then
import RxViewController

protocol HomePresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable, View {

    weak var listener: HomePresentableListener?

    var disposeBag = DisposeBag()

    private enum Color {
        static let lightBlack = 0x282828.color
        static let darkBlack = 0x212121.color
    }
    private enum Metric {
        static let navigationBarHeight: CGFloat = 44
        static let loadingOffset: CGFloat = 64
    }

    let viewNavigationBar = UIView().then {
        $0.backgroundColor = Color.lightBlack
    }
    let viewBarContent = UIView().then {
        $0.backgroundColor = .clear
    }
    let buttonUpload = HighlightingButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_video"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonSearch = HighlightingButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_search"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonAccount = HighlightingButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_profile"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let viewContent = UIView().then {
        $0.backgroundColor = Color.darkBlack
    }
    lazy var tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = Color.darkBlack
    }
    let refreshControl = UIRefreshControl().then {
        $0.backgroundColor = .clear
        $0.tintColor = .clear
    }
    let labelLoading = UILabel().then {
        $0.text = "Loading"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.backgroundColor = .clear
    }
    var constraintNavTop: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupNavigation()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func bind(reactor: HomeInteractor) {
        let tableView = self.tableView
        
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.initialLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonUpload.rx.tap
            .map { Reactor.Action.tapUpload }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonSearch.rx.tap
            .map { Reactor.Action.tapSearch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        buttonAccount.rx.tap
            .map { Reactor.Action.tapAccount }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        tableView.rx.itemSelected
            .map { Reactor.Action.tapCell($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        tableView.rx.didEndDragging
            .filter { $0 }
            .withLatestFrom(tableView.rx.contentOffset)
            .filter { $0.y < -Metric.loadingOffset }
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.isLoading }
            .filter { !$0 }
            .subscribe(onNext: { _ in
                tableView.panGestureRecognizer.isEnabled = false
                tableView.panGestureRecognizer.isEnabled = true
            })
            .disposed(by: disposeBag)
        reactor.state
            .map { $0.videos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, video, cell in
                cell.textLabel?.text = video.id
                cell.textLabel?.textColor = .white
                cell.backgroundColor = Color.darkBlack
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
}

extension HomeViewController {
    func setupViews() {
        view.backgroundColor = Color.lightBlack

        view.addSubview(viewNavigationBar)
        constraintNavTop = view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: viewNavigationBar.topAnchor)
        constraintNavTop?.isActive = true
        viewNavigationBar.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.navigationBarHeight)
        }
        viewNavigationBar.addSubview(viewBarContent)
        viewBarContent.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let navigationBar = NavigationBar(subviews: [buttonUpload, buttonSearch, buttonAccount])
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

        tableView.refreshControl = refreshControl
        refreshControl.addSubview(labelLoading)
        labelLoading.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func setupNavigation() {
        guard let constraint = constraintNavTop else { return }
        let viewNavigationBar = self.viewNavigationBar
        let viewBarContent = self.viewBarContent
        let constraintConstant = PublishSubject<CGFloat>()
        let height = Metric.navigationBarHeight
        let tableView = self.tableView

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
            .filter { _ in tableView.contentSize.height > tableView.bounds.height }
            .withLatestFrom(scrollOffsetDiff) { ($0, $1) }
            .filter { $0.1 > 0 }
            .map { constraint.constant + $1 }
            .map { min(max($0, 0), height) }
            .bind(to: constraintConstant)
            .disposed(by: disposeBag)

        // scrollUp -> 네비게이션 아래로(보이기) - y < 0 일때
        contentOffset
            .filter { _ in tableView.contentSize.height > tableView.bounds.height }
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
            .filter { _ in tableView.contentSize.height > tableView.bounds.height }
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
