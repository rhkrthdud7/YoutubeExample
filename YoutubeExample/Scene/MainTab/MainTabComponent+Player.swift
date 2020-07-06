//
//  MainTabComponent+Player.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/06.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

protocol MainTabDependencyPlayer: Dependency { }

extension MainTabComponent: PlayerDependency { }
