//
//  TodayController.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-27.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate   {
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .systemGray4
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var items = [TodayItem]()
    var businessUS, businessJapan: newsGroup?
    let screenRatio = UIScreen.main.bounds.width/414
    let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    override func viewDidLoad() {
        super.viewDidLoad()
	    navigationController?.setNavigationBarHidden(true, animated: false)
        setCollectionView()
        fetchAPI()
        setActivityIndicator()
        setVisualEffect()
    }
    
    fileprivate func setVisualEffect()  {
        // Add blur effect to the frame
        view.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        blurVisualEffect.alpha = 0
    }
    
    fileprivate func setCollectionView()    {
		collectionView.backgroundColor = .systemBackground
        collectionView.register(TitleCell.self, forCellWithReuseIdentifier: "titleCell")
        collectionView.register(TodayControllerCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
    }
    
    fileprivate func setActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    // To clear the issue of wrong layout of the tab-bar after dismissing the TodayMultipleAppsController.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Invalidates the current layout of the receiver and triggers a layout update during the next update cycle.
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    func fetchAPI() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchUSBusinessNews  { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.businessUS = newsGroup
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Service.shared.fetchJapanBusinessNews   { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.businessJapan = newsGroup
            dispatchGroup.leave()
        }
        
        // Completion
        dispatchGroup.notify(queue: .main)  {
            self.items = [
                TodayItem.init(category: "THE DAILY LIST", title: "News", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.businessUS?.articles ?? []),
                TodayItem.init(category: "THE DAILY LIST", title: "News", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.businessJapan?.articles ?? [])
            ]
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var startFrame: CGRect?
    var todayMultipleNewsController: TodayMultipleNewsController!
    
    // MARK: To control rendering all items in fullscreen
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        setupMultipleNewsFullScreen(indexPath)

        setupMultipleNewsStartPosition(indexPath)

        beginFullScreenAnimation()
    }
    
    fileprivate func setupMultipleNewsFullScreen(_ indexPath: IndexPath)  {
        let todayMultipleNewsController = TodayMultipleNewsController(mode: .fullscreen)
        todayMultipleNewsController.articles = items[indexPath.item-1].newsFetch
        todayMultipleNewsController.articleCategory = items[indexPath.item-1].category
        todayMultipleNewsController.articleTitle = items[indexPath.item-1].title
        todayMultipleNewsController.dismissHandler = {
            self.handleRemoveTodayMultipleNewsViewByButton()
        }
        self.todayMultipleNewsController = todayMultipleNewsController
        self.todayMultipleNewsController.view.layer.cornerRadius = 16
        // To set up the pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragTodayMultipleNews))
        gesture.delegate = self
        todayMultipleNewsController.collectionView.addGestureRecognizer(gesture)

    }
    
    fileprivate func setupMultipleNewsStartPosition(_ indexPath: IndexPath)   {
        guard let todayMultipleNewsView = todayMultipleNewsController.view else { return }
        
        view.addSubview(todayMultipleNewsView)
        addChild(todayMultipleNewsController)
        
        setupStartingCellFrame(indexPath)
        
        guard let startFrame = self.startFrame else { return }

        todayMultipleNewsView.translatesAutoresizingMaskIntoConstraints = false
        self.anchoredConstraints = todayMultipleNewsView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startFrame.origin.y, left: startFrame.origin.x, bottom: 0, right: 0), size: .init(width: startFrame.width, height: startFrame.height))
        self.collectionView.layoutIfNeeded()
    }
    
    @objc fileprivate func handleMultipleNewsTap(gesture: UIGestureRecognizer)   {
        let collectionView = gesture.view
        // To figure out which cell was clicking at
        var superView =  collectionView?.superview
        while (superView != nil)   {
            if let cell = superView as? TodayControllerCell    {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                showDailyListFullScreen(indexPath)
                return
            }
            superView = superView?.superview
        }
    }
    
    var todayMultipleNewsBeginOffset: CGFloat = 0
    
    @objc fileprivate func handleDragTodayMultipleNews (gesture: UIPanGestureRecognizer)    {
        if gesture.state == .began  {
            todayMultipleNewsBeginOffset = todayMultipleNewsController.collectionView.contentOffset.y
            print("Begin!")
        }
        let point:CGPoint = .init(x: 0, y: todayMultipleNewsController.offsetHeader)
        let transitionY = gesture.translation(in: todayMultipleNewsController.collectionView).y
        if todayMultipleNewsController.collectionView.contentOffset.y > 0 {
            return
        }
        var scale: CGFloat = 1

        if transitionY > 30  {
            if gesture.state == .changed  {
                let trueOffset = transitionY
                    scale = 1 - trueOffset/1000
                    scale = min(1, scale)
                    scale = max(0.85, scale)
                    let transform: CGAffineTransform = .init(scaleX: scale, y: scale)
                    todayMultipleNewsController.collectionView.contentOffset = point
                    todayMultipleNewsController.view.transform = transform
            }
            else if gesture.state == .ended {
                todayMultipleNewsController.closeButton.alpha = 0
                handleRemoveTodayMultipleNewsViewByButton()
            }
        }
        if (transitionY < 30 && transitionY > 0) || gesture.state == .failed || gesture.state == .cancelled {
            todayMultipleNewsController.view.transform = .identity
        }
    }
    
    
    // This function allows the pan gesture not interfered with the original UITableView Scrolling-Up or -Down
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)  else { return }
        
        // absolute coordinates of the specific chosen cell
        guard let startFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startFrame = startFrame
    }
    
    
    // MARK: - To store the start position of animation, and controll the animation -
    var anchoredConstraints: AnchoredConstraints?
    
    fileprivate func beginFullScreenAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            // Lays out the subviews immediately, if layout updates are pending.
            self.collectionView.layoutIfNeeded() // To start the animation
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height

            // To set blur.alpha =  1 to blur the view under the tranformed cell
            self.blurVisualEffect.alpha = 1
        }, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDailyListFullScreen(indexPath)
    }
    
    @objc func handleRemoveTodayMultipleNewsViewByButton()    {
           if let StatusbarView = UIApplication.shared.statusBarUIView {
               StatusbarView.backgroundColor = #colorLiteral(red: 0.9555236697, green: 0.9596020579, blue: 0.972651422, alpha: 1)
           }
           UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               // By setting contentOffset = .zero, the content inside the cell, even after being scrolled down to the bottom, the animated content will still shows the top with higher priority
               self.todayMultipleNewsController.collectionView.contentOffset = .zero
               // To disalbe the blur effect
               self.blurVisualEffect.alpha = 0
               // To restore the transform
               self.todayMultipleNewsController.view.transform = .identity
            

               guard let startFrame = self.startFrame else { return }
               self.anchoredConstraints?.top?.constant = startFrame.origin.y
               self.anchoredConstraints?.leading?.constant = startFrame.origin.x
               self.anchoredConstraints?.width?.constant = startFrame.width
               self.anchoredConstraints?.height?.constant = startFrame.height
 
               // Lays out the subviews immediately, if layout updates are pending.
            let point:CGPoint = .init(x: 0, y: self.todayMultipleNewsController.offsetHeader)
            self.todayMultipleNewsController.collectionView.contentOffset = point
                
            
               self.todayMultipleNewsController.view.layoutIfNeeded() // To start the animation
               if let tabBarFrame = self.tabBarController?.tabBar.frame {
                   self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
               }
               self.todayMultipleNewsController.closeButton.alpha = 0
           }, completion: { _ in
               self.todayMultipleNewsController.view.removeFromSuperview()
               self.todayMultipleNewsController?.removeFromParent()
               self.tabBarController?.tabBar.isHidden = false
               self.collectionView.isUserInteractionEnabled = true
           })
       }
    
    @objc func handleRemoveTodayMultipleNewsByTapping(gesture: UIGestureRecognizer) {
           if let StatusbarView = UIApplication.shared.statusBarUIView  {
               StatusbarView.backgroundColor = #colorLiteral(red: 0.9555236697, green: 0.9596020579, blue: 0.972651422, alpha: 1)
           }
           UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
               // By setting contentOffset = .zero, the content inside the cell, even after being scrolled down to the bottom, the animated content will still shows the top with higher priority
               self.todayMultipleNewsController.collectionView.contentOffset = .zero
            self.todayMultipleNewsController.view.transform = .identity

               // The previous method to use frame to restore the fullScreenView to cellView is not good enough
//               gesture.view?.frame = self.startFrame ?? .zero
               guard let startFrame = self.startFrame else { return }

               self.anchoredConstraints?.top?.constant = startFrame.origin.y
               self.anchoredConstraints?.leading?.constant = startFrame.origin.x
               self.anchoredConstraints?.width?.constant = startFrame.width
               self.anchoredConstraints?.height?.constant = startFrame.height
               // Lays out the subviews immediately, if layout updates are pending.
               self.collectionView.layoutIfNeeded() // To start the animation
               if let tabBarFrame = self.tabBarController?.tabBar.frame {
                   self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
               }
               // To disalbe the blur effect
               self.blurVisualEffect.alpha = 0

               guard let cell = self.todayMultipleNewsController.collectionView.cellForItem(at: [0, 0]) as? TodayMultipleNewsHeaderCell else { return }
               self.todayMultipleNewsController.closeButton.alpha = 0
               cell.layoutIfNeeded()
           }, completion: { _ in
               self.todayMultipleNewsController.view?.removeFromSuperview()
               self.todayMultipleNewsController?.removeFromParent()
               self.collectionView.isUserInteractionEnabled = true
           })
       }
    
    // MARK: - The setting of the UICollectionCell in UICollectionViewController -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count+1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.item == 0)    {
            let cellId = "titleCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            return cell
        }
        else    {
            let cellId = items[indexPath.item-1].cellType.rawValue
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
            
            cell.todayItem = items[indexPath.item-1]
            
            (cell as? TodayControllerCell)?.todayMultipleNewsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleNewsTap)))
            return cell
        }
    }
    
    static let heightCell: CGFloat = 500
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if (indexPath.item == 0)    {
               return .init(width: view.frame.width - 32, height: 60)
           }
        return .init(width: view.frame.width - 32, height: UIScreen.main.bounds.width*1.33)
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 16
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return .init(top: 16, left: 0, bottom: 16, right: 0)
       }
}
