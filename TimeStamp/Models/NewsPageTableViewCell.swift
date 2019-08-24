//
//  NewsPageTableViewCell.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-23.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class NewsPageTableViewCell: UITableViewCell {
    
    var article:Article? {
        didSet {
            guard let articleItem = article else {return}
            img.image = articleItem.img
            titleLabel.text = articleItem.title
            authorLabel.text = "by " + articleItem.author
            genreLabel.text = articleItem.genre.uppercased()
            tLabel.text = articleItem.text
        }
    }
    
    let img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 18)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 2
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.8
        return textLayer
    }()
    
    let tLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 14)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = false
        return textLayer
    }()
    
    let authorLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 12)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.alpha = 0.4
        textLayer.adjustsFontSizeToFitWidth = false
        return textLayer
    }()
    
    let genreLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 14)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.8
        return textLayer
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(img)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(tLabel)
        self.contentView.addSubview(genreLabel)
        
        img.widthAnchor.constraint(equalToConstant: 83).isActive = true
        img.heightAnchor.constraint(equalToConstant: 76).isActive = true
        img.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 19).isActive = true
        img.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 26).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: 234).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 28).isActive = true
        
        tLabel.widthAnchor.constraint(equalToConstant: 238).isActive = true
        tLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        tLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120).isActive = true
        tLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 66).isActive = true
        
        authorLabel.widthAnchor.constraint(equalToConstant: 234).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120).isActive = true
        authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 88).isActive = true
        
        genreLabel.widthAnchor.constraint(equalToConstant: 52).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 302).isActive = true
        genreLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
    }
}
