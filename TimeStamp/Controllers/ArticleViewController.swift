//
//  ArticleViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-29.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1185
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        articleContent()
        backButton()
    }
    
    func setupScroll() {
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let mainStory = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let destinationViewController = mainStory.instantiateViewController(withIdentifier: "article")
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.show(destinationViewController, sender: self)
    }
    
    func backButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let articleImage = UIImage(named: "Taskbar")
        let bgimage = UIImageView(image: articleImage)
        bgimage.frame = CGRect(x: 17, y: 26, width: 40, height: 40)
        bgimage.clipsToBounds = true
        bgimage.contentMode = .scaleAspectFill
        bgimage.isUserInteractionEnabled = true
        bgimage.addGestureRecognizer(tap)
        self.view.addSubview(bgimage)
    }
    
    func articleContent() {
        let layer = UIView(frame: CGRect(x: -0.21, y: 364, width: 376, height: 866))
        layer.layer.cornerRadius = 15
        layer.backgroundColor = UIColor.white
        self.scrollview.addSubview(layer)
        
        let title = UILabel(frame: CGRect(x: 37, y: 408, width: 240, height: 80))
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        title.textColor = UIColor.black
        title.alpha = 1
        let titleContent = "We live in an \nage of change."
        let titleString = NSMutableAttributedString(string: titleContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 40)!
            ])
        let titleRange = NSRange(location: 0, length: titleString.length)
        let titleStyle = NSMutableParagraphStyle()
        titleStyle.lineSpacing = 1
        titleString.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleStyle, range: titleRange)
        titleString.addAttribute(NSAttributedString.Key.kern, value: 0.6, range: titleRange)
        title.attributedText = titleString
        title.sizeToFit()
        self.scrollview.addSubview(title)
        
        let authorLayer = UILabel(frame: CGRect(x: 36.29, y: 506, width: 62, height: 14))
        authorLayer.lineBreakMode = .byWordWrapping
        authorLayer.numberOfLines = 0
        authorLayer.textColor = UIColor.black
        authorLayer.alpha = 1
        let authorContent = "John Smith"
        let authorString = NSMutableAttributedString(string: authorContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 14)!
            ])
        let authorRange = NSRange(location: 0, length: authorString.length)
        let authorStyle = NSMutableParagraphStyle()
        authorStyle.lineSpacing = 1
        authorString.addAttribute(NSAttributedString.Key.paragraphStyle, value: authorStyle, range: authorRange)
        authorString.addAttribute(NSAttributedString.Key.kern, value: 0.21, range: authorRange)
        authorLayer.attributedText = authorString
        authorLayer.sizeToFit()
        self.scrollview.addSubview(authorLayer)
        
        
    }

}
