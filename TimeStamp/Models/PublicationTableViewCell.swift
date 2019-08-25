//
//  PublicationTableViewCell.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-20.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class PublicationTableViewCell: UITableViewCell {
    let w = UIScreen.main.bounds.width
    
    var article:Article? {
        didSet {
            guard let articleItem = article else {return}
            img.image = articleItem.img
            titleLabel.text = articleItem.title
            authorLabel.text = "by " + articleItem.author
            genreLabel.text = articleItem.genre.uppercased()
            contentLabel.text = articleItem.text
        }
    }
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(img)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(contentLabel)
        self.contentView.addSubview(genreLabel)
        
        img.widthAnchor.constraint(equalToConstant: 315/375 * w).isActive = true
        img.heightAnchor.constraint(equalToConstant: 167/375 * w).isActive = true
        img.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30/375*w).isActive = true
        img.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40/375 * w).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: 310/375 * w).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50/375 * w).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 220/375 * w).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 35/375*w).isActive = true
        
        authorLabel.widthAnchor.constraint(equalToConstant: 304.36/375*w).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18/375 * w).isActive = true
        authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 274/375 * w).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 35/375 * w).isActive = true
        
        genreLabel.widthAnchor.constraint(equalToConstant: 59/375*w).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 18/375 * w).isActive = true
        genreLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 14/375 * w).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 35/375 * w).isActive = true
        
        contentLabel.widthAnchor.constraint(equalToConstant: 304.36/375*w).isActive = true
        contentLabel.heightAnchor.constraint(equalToConstant: 54/375 * w).isActive = true
        contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 301/375 * w).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 35/375*w).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 15/375 * UIScreen.main.bounds.width
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 25/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 2
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.5
        return textLayer
    }()
    
    let authorLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "Arial", size: 14/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        return textLayer
    }()
    
    let contentLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "Arial", size: 14/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 3
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.8
        return textLayer
    }()
    
    let genreLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 18/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
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

}
