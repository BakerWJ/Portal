//
//  ArticleViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import FaveButton
import PINRemoteImage

class ArticleViewController: UIViewController, FaveButtonDelegate, UIScrollViewDelegate {
    
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height;
    
    var imageHeight = NSLayoutConstraint();
    
    var article:Article? {
        didSet {
            guard let articleItem = article else {return}
            // img.loadImage(urlString: articleItem.img)
            img.pin_updateWithProgress = true
            img.pin_setImage(from: URL(string: articleItem.img))
            authorLabel.text = articleItem.author
            titleLabel.text = articleItem.title
            textLabel.text = articleItem.text
            heartButton.setSelected(selected: articleItem.liked, animated: false)
        }
    }
    
    var source: Int?
    
    //necessary for widget transition
    weak var delegate : UIViewController?
    
    lazy var heartButton: FaveButton = {
        let button = FaveButton(frame: CGRect(x: 320/375.0*w, y: 40/375.0*w, width: 40/375.0*w, height: 40/375.0*w), faveIconNormal: UIImage(named: "filledHeartImage"));
        button.selectedColor = UIColor.getColor(255, 105, 180)
        button.delegate = self;
        self.heartButton = button;
        return button;
    }()

    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let img: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        img.backgroundColor = UIColor.getColor(230, 230, 230);
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
    
    lazy var backButton: UIImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let articleImage = UIImage(named: "Taskbar")
        let bgimage = UIImageView(image: articleImage)
        bgimage.addGestureRecognizer(tap)
        return bgimage;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        self.scrollview.addSubview(img)
        let layer = UIView()
        layer.layer.cornerRadius = 15/375*w
        layer.backgroundColor = UIColor.white
        self.scrollview.addSubview(layer)
        let layer2 = UIView(frame: CGRect(x: 0, y: 364/375.0*w, width: w, height: 1000000));
        layer2.layer.cornerRadius = 15/375*w;
        layer2.backgroundColor = UIColor.white;
        layer2.dropShadow()
        self.scrollview.addSubview(layer2);
        self.scrollview.addSubview(authorLabel)
        self.scrollview.addSubview(titleLabel)
        self.scrollview.addSubview(textLabel)
        self.scrollview.isUserInteractionEnabled = true;
        self.scrollview.isScrollEnabled = true;
        
        titleLabel.topAnchor.constraint(equalTo: self.scrollview.topAnchor, constant: 408/375*w).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 300.79/375*w).isActive = true
        titleLabel.layoutIfNeeded()
        
        authorLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 18/375*w).isActive = true
        authorLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        authorLabel.widthAnchor.constraint(equalToConstant: 300/375*w).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 14/375*w).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 39/375*w).isActive = true
        textLabel.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor, constant: 36/375*w).isActive = true
        textLabel.widthAnchor.constraint(equalToConstant: 300/375*w).isActive = true
        textLabel.layoutIfNeeded()
        
        layer.translatesAutoresizingMaskIntoConstraints = false;
        layer.topAnchor.constraint (equalTo: scrollview.topAnchor, constant: 364/375.0*w).isActive = true;
        layer.leftAnchor.constraint (equalTo: scrollview.leftAnchor).isActive = true;
        layer.widthAnchor.constraint (equalTo: scrollview.widthAnchor).isActive = true;
        layer.bottomAnchor.constraint (equalTo: scrollview.bottomAnchor).isActive = true;
        let height1 = textLabel.frame.height + titleLabel.frame.height + (40 + 44 + 14 + 18 + 39)/375.0*w;
        let height2 = h - 364/375.0*w + 15/375.0*w;
        layer.heightAnchor.constraint (equalToConstant: max (height1, height2)).isActive = true;
                
        img.centerXAnchor.constraint (equalTo: self.scrollview.centerXAnchor).isActive = true;
        img.bottomAnchor.constraint (equalTo: self.scrollview.topAnchor, constant: 395/375.0*w).isActive = true;
        imageHeight = img.heightAnchor.constraint(equalToConstant: 395/375.0*w);
        imageHeight.isActive = true;
        img.widthAnchor.constraint (equalTo: img.heightAnchor, multiplier: 395.0/375.0).isActive = true;

        
        view.addSubview (backButton);
        backButton.translatesAutoresizingMaskIntoConstraints = false;
        backButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 17/375.0*w).isActive = true;
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40/375.0*w).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 40/375.0*w).isActive = true;
        backButton.heightAnchor.constraint (equalTo: backButton.widthAnchor).isActive = true;
        backButton.clipsToBounds = true
        backButton.isUserInteractionEnabled = true
        backButton.layoutIfNeeded()
        backButton.layer.cornerRadius = backButton.frame.height/2;
        //sets drop shadow
        backButton.layer.shadowColor = UIColor.black.cgColor;
        backButton.layer.shadowOpacity = 0.2
        backButton.layer.masksToBounds = false;
        backButton.layer.shadowRadius = 0.5;
        backButton.layer.shadowPath = UIBezierPath(roundedRect: backButton.bounds, cornerRadius: backButton.layer.cornerRadius).cgPath;
        backButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.3);
        view.addSubview(heartButton);
        
        //swipe
        if source != 2 && source != 0
        {
            let sgr = UISwipeGestureRecognizer(target: self, action: #selector(handleTap));
            sgr.direction = .right;
            view.addGestureRecognizer(sgr);
        }
    }
    
    func setupScroll() {
        scrollview.bounces = true
        scrollview.delegate = self;
        scrollview.showsVerticalScrollIndicator = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollview.contentInsetAdjustmentBehavior = .never;
        scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func handleTap() {
        if source == 0 {
            self.performSegue(withIdentifier: "toPub", sender: self)
        }
        else if source == 1{
            self.performSegue(withIdentifier: "articleu", sender: self)
        }
        else if source == 2{
            self.performSegue(withIdentifier: "returnToMain", sender: self)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if (offset >= 0)
        {
            return;
        }
        imageHeight.constant = abs(offset/375.0*w) + 395/375.0*w;
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y;
        if ((source == 2 || source == 0) && offset <= -170/375.0*w)
        {
            handleTap()
        }
    }
    
    func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        article?.liked = selected;
        CoreDataStack.saveContext()
    }
}
