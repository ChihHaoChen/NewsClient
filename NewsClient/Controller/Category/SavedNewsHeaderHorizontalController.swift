//
//  SavedNewsHeaderHorizontalController.swift
//  NewsClientJson
//
//  Created by chihhao on 2019-04-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class SavedNewsHeaderHorizontalController: HorizontalSnappingController, UICollectionViewDelegateFlowLayout  {
    fileprivate let cellId = "headerCellId"
    var savedNews: newsGroup?
    var didSelectHandler: ((Article)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(SavedNewsHeaderCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: 0, left: 12, bottom: 0, right: 12)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedNews?.articles.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SavedNewsHeaderCell
        if let article = savedNews?.articles[indexPath.item]    {
            cell.article = article
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width-48, height: collectionView.frame.height)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = savedNews?.articles[indexPath.item] else { return }
    
        didSelectHandler?(news)
    }
}


