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
        view.contentSize.height = 1049
        view.contentSize.width = 375
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        topText()
        featured()
    }
    
    func setupScroll() {
        scrollview.bounces = false
        scrollview.showsVerticalScrollIndicator = false
        scrollview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollview.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollview.backgroundColor = .white;
        if #available(iOS 11.0, *) {
            self.scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func topText() {
        let textLayer = UILabel(frame: CGRect(x: 20, y: 57, width: 123, height: 40))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        textLayer.alpha = 1
        let textContent = "Articles"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 40)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 1.1, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        let tLayer = UILabel(frame: CGRect(x: 18, y: 97, width: 161, height: 20))
        tLayer.lineBreakMode = .byWordWrapping
        tLayer.numberOfLines = 0
        tLayer.textColor = UIColor.black
        tLayer.alpha = 1
        let tContent = "Ideas worth Sharing"
        let tString = NSMutableAttributedString(string: tContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20)!
            ])
        let tRange = NSRange(location: 0, length: tString.length)
        let tparagraphStyle = NSMutableParagraphStyle()
        tparagraphStyle.lineSpacing = 1
        tString.addAttribute(NSAttributedString.Key.paragraphStyle, value: tparagraphStyle, range: tRange)
        tString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: tRange)
        tLayer.attributedText = tString
        tLayer.sizeToFit()
        self.scrollview.addSubview(tLayer)
        
        let pubLayer = UILabel(frame: CGRect(x: 22, y: 329, width: 104, height: 20))
        pubLayer.lineBreakMode = .byWordWrapping
        pubLayer.numberOfLines = 0
        pubLayer.textColor = UIColor.black
        pubLayer.alpha = 1
        let pubContent = "Publications"
        let pubString = NSMutableAttributedString(string: pubContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 20)!
            ])
        let pubRange = NSRange(location: 0, length: pubString.length)
        let pubParagraphStyle = NSMutableParagraphStyle()
        pubParagraphStyle.lineSpacing = 1
        pubString.addAttribute(NSAttributedString.Key.paragraphStyle, value: pubParagraphStyle, range: pubRange)
        pubString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: textRange)
        pubLayer.attributedText = pubString
        pubLayer.sizeToFit()
        self.scrollview.addSubview(pubLayer)
        
        let lLayer = UILabel(frame: CGRect(x: 18, y: 508, width: 182, height: 20))
        lLayer.lineBreakMode = .byWordWrapping
        lLayer.numberOfLines = 0
        lLayer.textColor = UIColor.black
        lLayer.alpha = 1
        let lContent = "Latest Stories for You"
        let lString = NSMutableAttributedString(string: lContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 20)!
            ])
        let lRange = NSRange(location: 0, length: lString.length)
        let lparagraphStyle = NSMutableParagraphStyle()
        lparagraphStyle.lineSpacing = 1
        lString.addAttribute(NSAttributedString.Key.paragraphStyle, value: lparagraphStyle, range: lRange)
        lString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: lRange)
        lLayer.attributedText = lString
        lLayer.sizeToFit()
        self.scrollview.addSubview(lLayer)
    }
    
    func featured() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        let layer1 = UIView(frame: CGRect(x: 18, y: 158, width: 190, height: 144))
        layer1.layer.cornerRadius = 15
        layer1.backgroundColor = UIColor(red: 0.46, green: 0.75, blue: 0.85, alpha: 1)
        layer1.addGestureRecognizer(tap1)
        self.scrollview.addSubview(layer1)
        
        let layer = UIView(frame: CGRect(x: 150, y: 220, width: 73.27, height: 90.47))
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -2.007128639793479)
        layer.transform = transform
        layer.layer.cornerRadius = 0
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.18)
        layer.addGestureRecognizer(tap2)
        self.scrollview.addSubview(layer)
        
        let layer2 = UIView(frame: CGRect(x: 34, y: 256, width: 121, height: 27))
        layer2.layer.cornerRadius = 15
        layer2.layer.borderWidth = 2
        layer2.layer.borderColor = UIColor.white.cgColor
        layer2.addGestureRecognizer(tap)
        self.scrollview.addSubview(layer2)
        
        let textLayer = UILabel(frame: CGRect(x: 38, y: 206, width: 122, height: 36))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        let textContent = "How to design a better app."
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 18)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        let textLayer1 = UILabel(frame: CGRect(x: 57, y: 263, width: 75, height: 14))
        textLayer1.lineBreakMode = .byWordWrapping
        textLayer1.numberOfLines = 0
        textLayer1.textColor = UIColor.white
        textLayer1.alpha = 1
        let textContent1 = "READ MORE"
        let textString1 = NSMutableAttributedString(string: textContent1, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 14)!
            ])
        let textRange1 = NSRange(location: 0, length: textString1.length)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 1
        textString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle1, range: textRange1)
        textString1.addAttribute(NSAttributedString.Key.kern, value: 0.21, range: textRange1)
        textLayer1.attributedText = textString1
        textLayer1.sizeToFit()
        self.scrollview.addSubview(textLayer1)
        
        let ctextLayer = UILabel(frame: CGRect(x: 40, y: 185, width: 85, height: 14))
        ctextLayer.lineBreakMode = .byWordWrapping
        ctextLayer.numberOfLines = 0
        ctextLayer.textColor = UIColor.white
        ctextLayer.alpha = 1
        let ctextContent = "ART & DESIGN"
        let ctextString = NSMutableAttributedString(string: ctextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 14)!
            ])
        let ctextRange = NSRange(location: 0, length: ctextString.length)
        let cparagraphStyle = NSMutableParagraphStyle()
        cparagraphStyle.lineSpacing = 1
        ctextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: cparagraphStyle, range: ctextRange)
        ctextString.addAttribute(NSAttributedString.Key.kern, value: 0.21, range: ctextRange)
        ctextLayer.attributedText = ctextString
        ctextLayer.sizeToFit()
        self.scrollview.addSubview(ctextLayer)
        
        let f_image = UIImage(named: "f_image")
        let i_view = UIImageView(image: f_image)
        i_view.frame = CGRect(x: 218, y: 158, width: 134, height: 144)
        i_view.layer.cornerRadius = 15
        i_view.clipsToBounds = true
        i_view.contentMode = .scaleAspectFill
        self.scrollview.addSubview(i_view)
    }
    
    func topArticles() {
        for i in 0 ... 4 {
            
        }
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "article", sender: self)
    }
    
    @IBAction func returnFromArticle (sender: UIStoryboardSegue) {}
}
