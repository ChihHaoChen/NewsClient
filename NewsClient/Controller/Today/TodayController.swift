//
//  TodayController.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-27.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout  {
	
	let activityIndicator = UIActivityIndicatorView(color: .systemGray, style: .large)
	
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    var startFrame: CGRect?
    var todayMultipleNewsController: TodayMultipleNewsController!
    
    var items = [TodayItem]()
    var topNewsUS, topNewsJapan, topNewsCanada, topNewsTaiwan: newsGroup?
	
	let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	
	var todayMultipleNewsBeginOffset: CGFloat = 0
	var anchoredConstraints: AnchoredConstraints?
	
	fileprivate let todayCellHeight: CGFloat = 4*CellSize.cellHeight + 6*CellSize.minimumSpacingSection + ConfigEnv.heightHeaderCell
	
	
	// MARK: - To configure UI elements
    override func viewDidLoad() {
        super.viewDidLoad()
	
        setCollectionView()
        fetchAPI()
        setActivityIndicator()
        setVisualEffect()
		pullToRefresh()
    }
    

	fileprivate func setVisualEffect()  {
		// Add blur effect to the frame
		view.addSubview(blurVisualEffect)
		blurVisualEffect.fillSuperview()
		blurVisualEffect.alpha = 0
	}
	
	
	fileprivate func setCollectionView() {
		collectionView.backgroundColor = .systemBackground
		
		collectionView.register(TitleCellCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleCellCollectionView.headerId)
		collectionView.register(TodayControllerCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
	}
	
	
	fileprivate func setActivityIndicator() {
		view.addSubview(activityIndicator)
		activityIndicator.centerInSuperview()
	}
	
	
	// MARK: - To fetch API
    func fetchAPI() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchUSTopNews  { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.topNewsUS = newsGroup
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Service.shared.fetchJapanTopNews   { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.topNewsJapan = newsGroup
            dispatchGroup.leave()
        }
		dispatchGroup.enter()
        Service.shared.fetchCanadaTopNews   { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.topNewsCanada = newsGroup
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Service.shared.fetchTaiwanTopNews   { (newsGroup, error) in
            if error != nil {
                print("API Fetch Error ->", error!)
                return
            }
            self.topNewsTaiwan = newsGroup
            dispatchGroup.leave()
        }
        // Completion
        dispatchGroup.notify(queue: .main)  {
            self.items = [
				TodayItem.init(category: "日本", title: "トップ", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsJapan?.articles ?? []),
				TodayItem.init(category: "Canada", title: "Top News", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsCanada?.articles ?? []),
                TodayItem.init(category: "US", title: "Top News", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsUS?.articles ?? []),
				TodayItem.init(category: "台灣", title: "頭條", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsTaiwan?.articles ?? [])
            ]
            self.collectionView.reloadData()
        }
		activityIndicator.stopAnimating()
    }
    
    
    // MARK: - To control rendering all items in fullscreen
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        setupMultipleNewsFullScreen(indexPath)

        setupMultipleNewsStartPosition(indexPath)

        beginFullScreenAnimation()
    }
    
	
    fileprivate func setupMultipleNewsFullScreen(_ indexPath: IndexPath)  {
        let todayMultipleNewsController = TodayMultipleNewsController(mode: .fullscreen)
        todayMultipleNewsController.articles = items[indexPath.item].newsFetch
        todayMultipleNewsController.articleCategory = items[indexPath.item].category
        todayMultipleNewsController.articleTitle = items[indexPath.item].title
        todayMultipleNewsController.dismissHandler = {
            self.handleRemoveTodayMultipleNewsViewByButton()
        }
        self.todayMultipleNewsController = todayMultipleNewsController
		self.todayMultipleNewsController.view.layer.cornerRadius = CellSize.imageCornerRadius
        // To set up the pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragTodayMultipleNews))
        gesture.delegate = self
        todayMultipleNewsController.collectionView.addGestureRecognizer(gesture)

    }
    
	
	// MARK: - To record the frames of animation
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
    
	
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)  else { return }
        
        // absolute coordinates of the specific chosen cell
        guard let startFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startFrame = startFrame
    }
    
    
    // MARK: - To store the start position of animation, and controll the animation -
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
    
	
	// MARK: - The operations when clicking the cells
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDailyListFullScreen(indexPath)
    }
	
	
	// MARK: - The setting of the header in TodayCotnroller
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleCellCollectionView.headerId, for: indexPath) as! TitleCellCollectionView
		
		header.titleLabel.text = "Worldwide Today"
		
		return header
	}
    
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return .init(width: collectionView.frame.width, height: ConfigEnv.heightHeaderCell)
	}
	
	
    // MARK: - The setting of the UICollectionCell in UICollectionViewController -
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
	
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellId = items[indexPath.item].cellType.rawValue
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
		
		cell.todayItem = items[indexPath.item]
		
		// MARK: Add gestures to the cells
		(cell as? TodayControllerCell)?.todayMultipleNewsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleNewsTap)))
		(cell as? TodayControllerCell)?.todayMultipleNewsController.collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressed)))
		
		return cell
    }
    
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		return .init(width: view.frame.width - 16, height: todayCellHeight)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 16
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 12, left: 0, bottom: 12, right: 0)
	}
}


extension TodayController: UIGestureRecognizerDelegate {
	
	// MARK: - To enable drag function to move cells -
	override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemDragged = items.remove(at: sourceIndexPath.item)
        items.insert(itemDragged, at: destinationIndexPath.item)
    }

	
	// MARK: - To enable the feature of pulling to referesh content -
	fileprivate func pullToRefresh() {
		let refreshControl = UIRefreshControl()
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh News")
		refreshControl.addTarget(self, action: #selector(refreshFetch), for: .valueChanged)
		
		collectionView.addSubview(refreshControl)
	}
	
	
	// MARK: To allow the pan gesture not interfered with the original UICollectionView Scrolling-Up or -Down
	  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		  return true
	  }
	  
	
	@objc func refreshFetch(refreshControl: UIRefreshControl) {
		activityIndicator.startAnimating()
		
		fetchAPI()
		
		refreshControl.endRefreshing()
	}
	
	
	// MARK: - ObjectC functions for gesture
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
    
	
	@objc fileprivate func handleLongPressed(gesture: UILongPressGestureRecognizer) {
		switch(gesture.state) {
			case .began:
				guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
				collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
			case .changed:
				collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
			case .ended:
				collectionView.endInteractiveMovement()
			default:
				collectionView.cancelInteractiveMovement()
		}
		
	}
    
	
    @objc fileprivate func handleDragTodayMultipleNews (gesture: UIPanGestureRecognizer)    {
        if gesture.state == .began  {
            todayMultipleNewsBeginOffset = todayMultipleNewsController.collectionView.contentOffset.y
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
	
	
	@objc func handleRemoveTodayMultipleNewsViewByButton()    {
			  if let StatusbarView = UIApplication.shared.statusBarUIView {
			   StatusbarView.backgroundColor = .systemGroupedBackground
			  }
			  UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
				  // By setting contentOffset = .zero, the content inside the cell, even after being scrolled down to the bottom, the animated content will still shows the top with higher priority
				  self.todayMultipleNewsController.collectionView.contentOffset = .zero
				  // To disalbe the blur effect
				  self.blurVisualEffect.alpha = 0
				  // To restore the transform
				  self.todayMultipleNewsController.view.transform = .identity
			   

				  guard let startFrame = self.startFrame else { return }
			   print("starFrame.width = \(startFrame.width)", "frame.width = \(self.view.frame.width)")
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
}
