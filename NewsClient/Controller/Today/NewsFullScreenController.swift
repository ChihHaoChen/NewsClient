//
//  NewsFullScreenController.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            return statusBar
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}

class NewsFullScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate   {
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?

    let statusBar = UIApplication.shared.statusBarUIView
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0   {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true // Enabled immediately if we want to scroll up or down in later interaction.
        }
        
        let translationY = -90 - (UIApplication.shared.statusBarUIView?.frame.height ?? 0)
        // Set up a transform variable to decide how the floatingContainerView would be rendered out
        let transform = scrollView.contentOffset.y > 100 ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = transform
        }, completion: nil)
    }
    
    let tableView = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFloatingControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let StatusbarView = UIApplication.shared.statusBarUIView {
            StatusbarView.backgroundColor = todayItem?.backgroundColor
        }
    }
    
    fileprivate func setupTableView()    {
        view.clipsToBounds = true
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        setupCloseButton()
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        // The behavior for determining the adjusted content offsets.
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarUIView?.frame.height ?? 0
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    @objc fileprivate func handleTap()   {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.floatingContainerView.transform = .init(translationX: 0, y: -90)
        }, completion: nil)
    }
    
    let floatingContainerView = UIView()
    fileprivate func setupFloatingControls()    {
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 16
        view.addSubview(floatingContainerView)
        
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: -90, right: 16), size: .init(width: 0, height: 80))
        
        let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        
        // Add the gesture recognizer to the current view
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        // add the subviews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.constrainWidth(constant: 68)
        imageView.constrainHeight(constant: 68)
        
        let getButton = UIButton(title: "GET", titleColor: .white, font: .boldSystemFont(ofSize: 16), width: 80, height: 32, cornerRadius: 16)
        getButton.backgroundColor = .darkGray
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            VerticalStackView(arrangedSubviews: [
                UILabel(text: todayItem?.category ?? "Life Hack", font: UIFont.boldSystemFont(ofSize: 18)),
                UILabel(text: todayItem?.title ?? "Utilizing Your Time", font: UIFont.systemFont(ofSize: 16))
                ], spacing: 4),
            getButton
            ], customSpacing: 16)
        
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
    }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0.025*self.view.frame.height, left: 0, bottom: 0, right: 0.05*self.view.frame.width), size: .init(width: 32, height: 32))
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0   {
            return TodayController.heightCell
        }
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0   {
            let headerCell = NewsFullScreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        }
        else {
            let cell = NewsFullScreenDescriptionCell()
            return cell
        }
    }
    
    @objc func handleDismiss(button: UIButton)    {
        button.isHidden = true
        dismissHandler?()
    }
}

