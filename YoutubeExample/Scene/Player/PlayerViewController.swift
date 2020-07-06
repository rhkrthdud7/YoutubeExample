//
//  PlayerViewController.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol PlayerPresentableListener: class {}

final class PlayerViewController: UIViewController, PlayerPresentable, PlayerViewControllable {

    weak var listener: PlayerPresentableListener?
}
