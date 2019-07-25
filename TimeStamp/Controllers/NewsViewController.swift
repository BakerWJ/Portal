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
        view.contentSize.height = 1260
        view.backgroundColor = #colorLiteral(red: 0.2038967609, green: 0.3737305999, blue: 0.7035349607, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        titleContent()
        featuredTab()
        siftArticles()
    }
    
    func setupScroll() {
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
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
        
        let subtextLayer = UILabel(frame: CGRect(x: 36, y: 94, width: 177, height: 20))
        subtextLayer.lineBreakMode = .byWordWrapping
        subtextLayer.numberOfLines = 0
        subtextLayer.textColor = UIColor.white
        subtextLayer.alpha = 1
        let subtextContent = "Stories worth sharing."
        let subtextString = NSMutableAttributedString(string: subtextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
            ])
        let subtextRange = NSRange(location: 0, length: subtextString.length)
        let subparagraphStyle = NSMutableParagraphStyle()
        subparagraphStyle.lineSpacing = 1
        subtextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: subparagraphStyle, range: subtextRange)
        subtextString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: subtextRange)
        subtextLayer.attributedText = subtextString
        subtextLayer.sizeToFit()
        self.scrollview.addSubview(subtextLayer)
    }
    
    func featuredTab() {
        let layer = UIView(frame: CGRect(x: -1.5, y: 546.31, width: 378, height: 266.38))
        layer.layer.cornerRadius = 25
        layer.backgroundColor = UIColor.white
        self.scrollview.addSubview(layer)
        
        let layer2 = UIView(frame: CGRect(x: -1.5, y: 546.31, width: 378, height: 230))
        layer2.layer.cornerRadius = 0
        layer2.backgroundColor = UIColor.white
        self.scrollview.addSubview(layer2)
        
        let latest = UILabel(frame: CGRect(x: 38, y: 561, width: 254, height: 30))
        latest.lineBreakMode = .byWordWrapping
        latest.numberOfLines = 0
        latest.textColor = UIColor.black
        latest.alpha = 1
        let latesttextContent = "Latest and Greatest."
        let latesttextString = NSMutableAttributedString(string: latesttextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 30)!
            ])
        let latesttextRange = NSRange(location: 0, length: latesttextString.length)
        let latestparagraphStyle = NSMutableParagraphStyle()
        latestparagraphStyle.lineSpacing = 1
        latesttextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: latestparagraphStyle, range: latesttextRange)
        latesttextString.addAttribute(NSAttributedString.Key.kern, value: 0.45, range: latesttextRange)
        latest.attributedText = latesttextString
        latest.sizeToFit()
        self.scrollview.addSubview(latest)
        
        let textLayer = UILabel(frame: CGRect(x: 38, y: 591, width: 208, height: 20))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        textLayer.alpha = 1
        let textContent = "Stories hot off the presses."
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        let articleImage = UIImage(named: "000")
        let bgimage = UIImageView(image: articleImage)
        bgimage.frame = CGRect(x: 38, y: 625, width: 351, height: 160)
        bgimage.layer.cornerRadius = 15
        bgimage.clipsToBounds = true
        bgimage.contentMode = .scaleAspectFill
        self.scrollview.addSubview(bgimage)
        
        let titleLayer = UILabel(frame: CGRect(x: 55, y: 642, width: 185.69, height: 29.63))
        titleLayer.lineBreakMode = .byWordWrapping
        titleLayer.numberOfLines = 0
        titleLayer.textColor = UIColor.white
        titleLayer.alpha = 1
        let titleContent = "Longing:\nHath do us Part."
        let titleString = NSMutableAttributedString(string: titleContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
            ])
        let titleRange = NSRange(location: 0, length: titleString.length)
        let titleparagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: titleparagraphStyle, range: titleRange)
        titleString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: titleRange)
        titleLayer.attributedText = titleString
        titleLayer.sizeToFit()
        self.scrollview.addSubview(titleLayer)
    }
    
    func siftArticles() {
        for i in 0...3 {
            let layer = UIView(frame: CGRect(x: 10, y: 868 + 98 * i, width: 357, height: 93))
            layer.layer.cornerRadius = 30
            layer.backgroundColor = UIColor.white
            self.scrollview.addSubview(layer)
            
            let textLayer = UILabel(frame: CGRect(x: 140, y: 884 + 98 * i, width: 144, height: 40))
            textLayer.lineBreakMode = .byWordWrapping
            textLayer.numberOfLines = 0
            textLayer.textColor = UIColor.black
            textLayer.alpha = 1
            let textContent = "When I Speak, the\nWorld Listens"
            let textString = NSMutableAttributedString(string: textContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
                ])
            let textRange = NSRange(location: 0, length: textString.length)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1
            textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
            textString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: textRange)
            textLayer.attributedText = textString
            textLayer.sizeToFit()
            self.scrollview.addSubview(textLayer)
            
            let date = UILabel(frame: CGRect(x: 140, y: 928 + 98 * i, width: 67, height: 14))
            date.lineBreakMode = .byWordWrapping
            date.numberOfLines = 0
            date.textColor = UIColor.black
            date.alpha = 1
            let dateContent = "24 Feb 2019"
            let dateString = NSMutableAttributedString(string: dateContent, attributes: [
                NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 14)!
                ])
            let dateRange = NSRange(location: 0, length: dateString.length)
            let dateStyle = NSMutableParagraphStyle()
            dateStyle.lineSpacing = 1
            dateString.addAttribute(NSAttributedString.Key.paragraphStyle, value: dateStyle, range: dateRange)
            textString.addAttribute(NSAttributedString.Key.kern, value: 0.21, range: dateRange)
            date.attributedText = dateString
            date.sizeToFit()
            self.scrollview.addSubview(date)
            
            let articleImage = UIImage(named: "lighthouse_2x (2)")
            let bgimage = UIImageView(image: articleImage)
            bgimage.frame = CGRect(x: 37, y: 873 + 98 * i, width: 85, height: 85)
            bgimage.layer.cornerRadius = 30
            bgimage.clipsToBounds = true
            bgimage.contentMode = .scaleAspectFill
            self.scrollview.addSubview(bgimage)
        }
    }
}
