//
//  NewsPageTableViewCell.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-23.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import LBTAComponents

class NewsPageTableViewCell: UITableViewCell {
    let w = UIScreen.main.bounds.width
    
    var article:Article? {
        didSet {
            guard let articleItem = article else {return}
            img.loadImage(urlString: articleItem.img)
            titleLabel.text = articleItem.title
            authorLabel.text = "by " + articleItem.author
            genreLabel.text = articleItem.genre.uppercased()
            tLabel.text = articleItem.text
            var likes = articleItem.likes;
            if (articleItem.liked != articleItem.uploaded)
            {
                likes += (articleItem.liked ? 1 : -1);
            }
            numLikesLabel.text = "\(likes)"
        }
    }
    
    
    let heartImage : UIImageView = {
        let view = UIImageView();
        let image = UIImage(named: "filledHeartImage")?.imageWithColor(newColor: UIColor.getColor(117, 190, 217));
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.image = image;
        return view;
    }()
    
    lazy var numLikesLabel: UILabel = {
        let label = UILabel();
        label.textColor = UIColor.getColor(117, 190, 217);
        label.backgroundColor = .clear;
        label.textAlignment = .right;
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont(name: "Arial-BoldMT", size: 16/375.0*w);
        return label;
    }()
    
    let img: CachedImageView = {
        let img = CachedImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.backgroundColor = #colorLiteral(red: 0.2038967609, green: 0.3737305999, blue: 0.7035349607, alpha: 1)
        return img
    }()
    
    let titleLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 18/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 2
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.8
        return textLayer
    }()
    
    let tLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 14/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = false
        return textLayer
    }()
    
    let authorLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 12/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.alpha = 0.4
        textLayer.adjustsFontSizeToFitWidth = false
        return textLayer
    }()
    
    let genreLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 14/375 * UIScreen.main.bounds.width)
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
        addSubview(heartImage);
        addSubview(numLikesLabel);
        
        img.widthAnchor.constraint(equalToConstant: 83/375 * w).isActive = true
        img.heightAnchor.constraint(equalToConstant: 76/375 * w).isActive = true
        img.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 19/375 * w).isActive = true
        img.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 26/375 * w).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: 234/375 * w).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 36/375 * w).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120/375 * w).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 28/375 * w).isActive = true
        
        tLabel.widthAnchor.constraint(equalToConstant: 238/375 * w).isActive = true
        tLabel.heightAnchor.constraint(equalToConstant: 14/375 * w).isActive = true
        tLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120/375 * w).isActive = true
        tLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 66/375 * w).isActive = true
        
        authorLabel.widthAnchor.constraint(equalToConstant: 234/375 * w).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 12/375 * w).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 120/375 * w).isActive = true
        authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 88/375 * w).isActive = true
        
        genreLabel.widthAnchor.constraint(equalToConstant: 52/375 * w).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 14/375 * w).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 302/375 * w).isActive = true
        genreLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10/375 * w).isActive = true
        
        //add the heart image and the numlikes label
        heartImage.centerYAnchor.constraint (equalTo: authorLabel.centerYAnchor).isActive = true;
        heartImage.heightAnchor.constraint(equalToConstant: 16/375.0*w).isActive = true;
        heartImage.widthAnchor.constraint(equalToConstant: 16.2/375.0*w).isActive = true;
        heartImage.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 325/375.0*w).isActive = true;
        
        numLikesLabel.centerYAnchor.constraint (equalTo: heartImage.centerYAnchor).isActive = true;
        numLikesLabel.heightAnchor.constraint (equalTo: heartImage.heightAnchor).isActive = true;
        numLikesLabel.trailingAnchor.constraint(equalTo: heartImage.leadingAnchor, constant: -5/375.0*w).isActive = true;
        
    }
}
