//
//  NewsFullScreenDescriptionCell.swift
//  NewsClient
//
//  Created by chihhao on 2019-05-28.
//  Copyright © 2019 ChihHao. All rights reserved.
//

import UIKit

class NewsFullScreenDescriptionCell: UITableViewCell {

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        let attributedText = NSMutableAttributedString(string: "Great games", attributes: [.foregroundColor: UIColor.black])
        attributedText.append(NSMutableAttributedString(string: " are all about the details, from subtle visual effects to imaginative art styles. In these titles, you're sure to find something to marvel at, whether you're into fancy worlds of neon-soaked dartboards", attributes: [.foregroundColor : UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "\n\n\nHeroic Adventure", attributes: [.foregroundColor : UIColor.black]))
        attributedText.append(NSMutableAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor : UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "\n\n\nExcellence", attributes: [.foregroundColor : UIColor.black]))
        attributedText.append(NSMutableAttributedString(string: "\nTest your abilities by going through many different challenges today.", attributes: [.foregroundColor : UIColor.gray]))
        
        attributedText.append(NSMutableAttributedString(string: " are all about the details, from subtle visual effects to imaginative art styles. In these titles, you're sure to find something to marvel at, whether you're into fancy worlds of neon-soaked dartboards", attributes: [.foregroundColor : UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "\n\n\nHeroic Adventure", attributes: [.foregroundColor : UIColor.black]))
        attributedText.append(NSMutableAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor : UIColor.gray]))
        attributedText.append(NSMutableAttributedString(string: "\n\n\nExcellence", attributes: [.foregroundColor : UIColor.black]))
        attributedText.append(NSMutableAttributedString(string: "\nTest your abilities by going through many different challenges today.", attributes: [.foregroundColor : UIColor.gray]))
        
        label.attributedText = attributedText
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
