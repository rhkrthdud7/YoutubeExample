//
//  RootComponent+Splash.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the Splash scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencySplash: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the Splash scope.
}

extension RootComponent: SplashDependency {

    // TODO: Implement properties to provide for Splash scope.
}
