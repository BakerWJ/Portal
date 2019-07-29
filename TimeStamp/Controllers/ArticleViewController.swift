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
        articleContent()
    }
    
    func setupScroll() {
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        let titleContent = "We live in an \n age of change."
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
        
    }

}
