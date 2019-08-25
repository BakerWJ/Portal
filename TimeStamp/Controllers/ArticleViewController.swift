//
//  ArticleViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit


class ArticleViewController: UIViewController {
    let w = UIScreen.main.bounds.width
    
    var article:Article? {
        didSet {
            guard let articleItem = article else {return}
            img.image = articleItem.img
            authorLabel.text = articleItem.author
            titleLabel.text = articleItem.title
            textLabel.text = articleItem.text
        }
    }
    
    var source: Int?
    
    

    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 15/375*UIScreen.main.bounds.width
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 40/375*UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 4
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.7
        return textLayer
    }()
    
    let authorLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 14/375*UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.8
        return textLayer
    }()
    
    let textLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 16/375*UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 0
        textLayer.adjustsFontSizeToFitWidth = false
        return textLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        self.scrollview.addSubview(img)
        let layer = UIView(frame: CGRect(x: -0.21/375*w, y: 364/375*w, width: 375/375*w, height: 866/375*w))
        layer.layer.cornerRadius = 15/375*w
        layer.backgroundColor = UIColor.white
        self.scrollview.addSubview(layer)
        self.scrollview.addSubview(authorLabel)
        self.scrollview.addSubview(titleLabel)
        self.scrollview.addSubview(textLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.scrollview.topAnchor, constant: 408/375*w).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300.79/375*w).isActive = true
        
        authorLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 18/375*w).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 300/375*w).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 14/375*w).isActive = true
        
        
        textLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 39/375*w).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 300/375*w).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: self.scrollview.bottomAnchor, constant: -30/375*w).isActive = true
        textLabel.sizeToFit()
        textLabel.layoutIfNeeded()
        textLabel.heightAnchor.constraint(equalToConstant: textLabel.frame.height).isActive = true
        
        img.topAnchor.constraint(equalTo: self.scrollview.topAnchor, constant: -7/375*w).isActive = true
        img.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 0).isActive = true
        img.widthAnchor.constraint(equalToConstant: 419/375*w).isActive = true
        img.heightAnchor.constraint(equalToConstant: 395/375*w).isActive = true
        
        backButton()
    }
    
    func setupScroll() {
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        if #available(iOS 11.0, *) {
            self.scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if source == 0 {
            self.performSegue(withIdentifier: "toPub", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "articleu", sender: self)
        }
    }
    
    func backButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let articleImage = UIImage(named: "Taskbar")
        let bgimage = UIImageView(image: articleImage)
        bgimage.frame = CGRect(x: 17/375*w, y: 26/375*w, width: 40/375*w, height: 40/375*w)
        bgimage.clipsToBounds = true
        bgimage.contentMode = .scaleAspectFill
        bgimage.isUserInteractionEnabled = true
        bgimage.addGestureRecognizer(tap)
        self.view.addSubview(bgimage)
    }
    
    
}
