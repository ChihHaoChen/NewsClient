//
//  ViewTodayController.swift
//  NewsClient
//
//  Created by ChihHao on 2020/01/16.
//  Copyright © 2020 ChihHao. All rights reserved.
//

import UIKit
let cellName = "cell"

class ViewTodayController: UIViewController {
	
	let activityIndicator: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(style: .large)
		aiv.color = .systemGray
		aiv.startAnimating()
		aiv.hidesWhenStopped = true
		return aiv
	}()
	let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	
	let titleCell = TitleCell()
	var collectionView: UICollectionView!
	
	var items = [TodayItem]()
	var topNewsUS, topNewsJapan, topNewsCanada, topNewsTaiwan: newsGroup?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationController?.setNavigationBarHidden(true, animated: false)
		
		configureCollectionView()
		configureUIElements()
		fetchAPI()
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarController?.tabBar.superview?.setNeedsLayout()
	}
    
	
	func configureCollectionView()	{
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: NewsCardLayout.createNewsCardLayout(in: view))
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(TodayControllerCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
		collectionView.backgroundColor = .systemBlue
		
		setVisualEffect()
		setActivityIndicator()
	}
	
	
	fileprivate func setActivityIndicator() {
        collectionView.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
	
	
    fileprivate func setVisualEffect()  {
        // Add blur effect to the frame
        collectionView.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        blurVisualEffect.alpha = 0
    }
	
	
	private func configureUIElements() {
		let paddingCell: CGFloat = 8
		view.addSubview(titleCell)
		view.addSubview(collectionView)
		
		titleCell.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 40, left: paddingCell, bottom: 0, right: paddingCell), size: .init(width: view.frame.width-2*paddingCell, height: 50))
		collectionView.anchor(top: titleCell.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
	}
	
	
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
				TodayItem.init(category: "日本", title: "トップ", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsJapan?.articles ?? []),
				TodayItem.init(category: "Canada", title: "Top News", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsCanada?.articles ?? []),
                TodayItem.init(category: "US", title: "Top News", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsUS?.articles ?? []),
				TodayItem.init(category: "台灣", title: "頭條", image: #imageLiteral(resourceName: "News_iOS_Icon"), description: "All the New you are eager to know right way", backgroundColor: .systemGroupedBackground, cellType: .multiple, newsFetch: self.topNewsTaiwan?.articles ?? []),

            ]
			
			self.activityIndicator.stopAnimating()
			self.collectionView.reloadData()
        }
    }
}


extension ViewTodayController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellId = items[indexPath.item].cellType.rawValue
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
		
		cell.todayItem = items[indexPath.item]
		
//		(cell as? TodayControllerCell)?.todayMultipleNewsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleNewsTap)))
		return cell
	}
}
