//
//  NewsViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1339
        view.backgroundColor = #colorLiteral(red: 0.2038967609, green: 0.3737305999, blue: 0.7035349607, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        titleContent()

    }
    
    func setupScroll() {
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func titleContent() {
        let articles = UILabel(frame: CGRect(x: 33, y: 44, width: 82, height: 20))
        articles.lineBreakMode = .byWordWrapping
        articles.numberOfLines = 0
        articles.textColor = UIColor.white
        articles.alpha = 1
        let textContent = "ARTICLES"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: textRange)
        articles.attributedText = textString
        articles.sizeToFit()
        self.scrollview.addSubview(articles)
        
        let discover = UILabel(frame: CGRect(x: 34, y: 64, width: 213, height: 30))
        discover.lineBreakMode = .byWordWrapping
        discover.numberOfLines = 0
        discover.textColor = UIColor.white
        discover.alpha = 1
        let disTextContent = "Discover Stories."
        let disTextString = NSMutableAttributedString(string: disTextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 30)!
            ])
        let disTextRange = NSRange(location: 0, length: disTextString.length)
        let disParagraphStyle = NSMutableParagraphStyle()
        disParagraphStyle.lineSpacing = 1
        disTextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: disParagraphStyle, range: disTextRange)
        disTextString.addAttribute(NSAttributedString.Key.kern, value: 0.45, range: disTextRange)
        discover.attributedText = disTextString
        discover.sizeToFit()
        self.scrollview.addSubview(discover)
    }
    

}
