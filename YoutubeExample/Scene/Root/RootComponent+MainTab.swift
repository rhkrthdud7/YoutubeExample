//
//  RootComponent+MainTab.swift
//  YoutubeExample
//
//  Created by Soso on 2020/06/30.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the MainTab scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyMainTab: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the MainTab scope.
}

extension RootComponent: MainTabDependency {

    // TODO: Implement properties to provide for MainTab scope.
}
