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
    private let cellId = "cellId"
    private let headerId = "headerId"
    let screenRatio = UIScreen.main.bounds.width/414
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDismiss()  {
        dismiss(animated: true, completion: nil)
    }
    
    // New init to have mode selection of this controller.
    fileprivate let mode: Mode
    
    enum Mode {
        case small, fullscreen
    }
    
    init(mode: Mode)    {
        self.mode = mode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TodayMultipleNewsHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(MultipleNewsCell.self, forCellWithReuseIdentifier: cellId)
        // Never put the API fetch inside sub-viewController
        if self.mode == .fullscreen {
            setupCloseButton()
            navigationController?.navigationBar.isHidden = true
        }   else    {
            collectionView.isScrollEnabled = false
        }
    }
    
    override var prefersStatusBarHidden: Bool  { return true }
    
    func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0.05*self.view.frame.height, left: 0, bottom: 0, right: 0.05*self.view.frame.width), size: .init(width: 32, height: 32))
    }
    
    // MARK: Configuration of UICollectionView
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! TodayMultipleNewsHeaderCell
        header.categoryLabel.text = articleCategory
        header.titleLabel.text = articleTitle
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleNewsCell
        cell.article = articles[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.mode == .fullscreen {
            return .init(width: collectionView.frame.width, height: 160)
        }
        return .init(width: collectionView.frame.width, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mode == .fullscreen {
            return articles.count
        }
        return min(4, articles.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heightCell: CGFloat = (view.frame.height - 3*spacing)/4
        let heightCellFullScreen: CGFloat = (view.frame.height - 7*spacing)/8
        if self.mode == .fullscreen {
            return .init(width: view.frame.width - 32, height: heightCellFullScreen)
        }
        return .init(width: view.frame.width, height: heightCell)
    }
    
    fileprivate let spacing: CGFloat = 16
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.mode == .fullscreen {
            return .init(top: 12, left: 12, bottom: 12, right: 12)
        }
        return .zero
    }
    
    // MARK: Navigate users to the detailed News page
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailView = NewsDetailController(url: articles[indexPath.item].url)
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
