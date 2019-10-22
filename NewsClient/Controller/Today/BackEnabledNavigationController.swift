//
//  BackEnabledNavigationController.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-06.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate   {
    // The following block has already made the back transition by swiping right possible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // The gesture recognizer responsible for popping the top view controller off the navigation stack.
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
