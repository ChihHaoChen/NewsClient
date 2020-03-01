//
//  BaseTabController.swift
//  NewsClient
//
//  Created by chihhao on 2019-04-22.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit
import SDWebImage

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
			let statusBarFrame = UIView(frame: UIApplication.shared.windows[0].windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            return statusBarFrame
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}

class BaseTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
		tabBar.tintColor = .systemOrange
        
        viewControllers = [
            createNavContoller(viewController: CategoryTopContainerContoller(), title: "Category", image: "react-native-50"),
			createNavContoller(viewController: TodayController(), title: "Today", image: "today_icon"),
            createNavContoller(viewController: NewsSearchController(), title: "Search", image: "search")
        ]
        
    }
    // Use this function to create the navigation controller for each individual tab
    fileprivate func createNavContoller(viewController: UIViewController, title: String, image: String) -> BackEnabledNavigationController   {
        let backEnableController = BackEnabledNavigationController(rootViewController: viewController)
        viewController.view.backgroundColor = .systemBackground
        viewController.navigationItem.title = title
        
        // In 2019 WWDC, Apple changed its Default Modal Presentation Style for UIModal.
        // By default UIViewController resolves UIModalPresentationAutomatic to UIModalPresentationPageSheet, but other system-provided view controllers may resolve UIModalPresentationAutomatic to other concrete presentation styles.
        backEnableController.modalPresentationStyle = .fullScreen
        backEnableController.tabBarItem.title = title
        backEnableController.tabBarItem.image = UIImage.init(named: image)
        backEnableController.navigationBar.prefersLargeTitles = true
        return backEnableController
    }
}
