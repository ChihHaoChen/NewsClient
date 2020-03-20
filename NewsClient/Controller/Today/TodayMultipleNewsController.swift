//
//  TodayMultipleNewsController.swift
//  NewsClient
//
//  Created by chihhao on 2019-06-03.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class TodayMultipleNewsController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
	
    var articles = [Article]()
    var articleCategory: String?
    var articleTitle: String?
    var dismissHandler: (()->())?
	
    private let cellId = "cellId"
    fileprivate let headerId = "headerId"
	
    var offsetHeader: CGFloat
    let screenRatio = UIScreen.main.bounds.width/414
	let screenWidth: CGFloat = UIScreen.main.bounds.width
	
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss(button: UIButton)  {
        button.isHidden = true
        dismissHandler?()
    }
    
    // New init to have mode selection of this controller.
    var mode: Mode
    fileprivate var numShownArticles: Int
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode)    {
		self.mode = mode
        numShownArticles = 0
        offsetHeader = 0
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        // Never put the API fetch inside sub-viewController
        if self.mode == .fullscreen {
            setupCloseButton()
//			view.layer.borderWidth = 2
//			view.layer.borderColor = UIColor.systemGray.cgColor
			navigationController?.navigationBar.isHidden = true
        }   else    {
            collectionView.isScrollEnabled = false
		}
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.mode == .fullscreen {
			tabBarController?.tabBar.isHidden = true
		}
	}

	
    override var prefersStatusBarHidden: Bool  { return true }
    
	
    // MARK: - Register collectionViewCells and UI elements -
    fileprivate func setupCollectionView() {
		collectionView.backgroundColor = .systemGroupedBackground
        collectionView.layer.cornerRadius = 16
        collectionView.register(TodayMultipleNewsHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(TodayMultipleNewsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
	
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0.05*self.view.frame.height, left: 0, bottom: 0, right: 0.05*self.view.frame.width), size: .init(width: 32, height: 32))
    }
    
	
    // MARK: - Configuration of UICollectionView -
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! TodayMultipleNewsHeaderCell
        header.categoryLabel.text = articleCategory
        header.titleLabel.text = articleTitle
        if let attributes = collectionView.layoutAttributesForSupplementaryElement(ofKind: kind, at: indexPath) {
            var offsetY = attributes.frame.origin.y - self.collectionView.contentInset.top
            if #available(iOS 11.0, *) {
                offsetY -= collectionView.safeAreaInsets.top
            }
            self.offsetHeader = offsetY
        }
        return header
    }
    
	
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayMultipleNewsCell
        cell.article = articles[indexPath.item]
        if(indexPath.item == numShownArticles-1)  {
            cell.separator.alpha = 0
        }
        
        return cell
    }
    
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.mode == .fullscreen {
			return .init(width: collectionView.frame.width-16, height: CellSize.cellHeight)
        }
        return .init(width: collectionView.frame.width, height: 0)
    }
	
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mode == .fullscreen {
            numShownArticles = articles.count
            return numShownArticles
        }
        numShownArticles = min(4, articles.count)
        return numShownArticles
    }
    
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.mode == .fullscreen {
			return .init(width: view.frame.width - 16, height: CellSize.cellHeight)
        }
		return .init(width: view.frame.width, height: CellSize.cellHeight)
    }
	
	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return CellSize.minimumSpacingSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        if self.mode == .fullscreen {
			return .init(top: 0, left: 8, bottom: 12 - tabBarHeight, right: 8)
        }
        return .zero
    }
    
    // MARK: - Navigate users to the detailed News page -
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailView = NewsDetailController(mode: .readUnSavedArticle, article: articles[indexPath.item])
        self.navigationController?.pushViewController(detailView, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
}
