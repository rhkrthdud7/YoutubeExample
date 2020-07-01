//
//  MainTabComponent+Home.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/01.
//  Copyright © 2020 Soso. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of MainTab to provide for the Home scope.
// TODO: Update MainTabDependency protocol to inherit this protocol.
protocol MainTabDependencyHome: Dependency {
    // TODO: Declare dependencies needed from the parent scope of MainTab to provide dependencies
    // for the Home scope.
}

extension MainTabComponent: HomeDependency {

    // TODO: Implement properties to provide for Home scope.
}
