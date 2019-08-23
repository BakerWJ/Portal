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
        publications()
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
    
    @objc func pubView() {
        performSegue(withIdentifier: "pubf", sender: self)
    }
    
    func publications() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(pubView))
        
        
        let layer = UIView(frame: CGRect(x: 19, y: 336, width: 107, height: 122))
        layer.layer.cornerRadius = 15
        layer.backgroundColor = UIColor(red: 0.98, green: 0.6, blue: 0.09, alpha: 1)
        layer.addGestureRecognizer(tap)
        self.scrollview.addSubview(layer)
        
        
        let layer1 = UIView(frame: CGRect(x: 135, y: 336, width: 107, height: 122))
        layer1.layer.cornerRadius = 15
        layer1.backgroundColor = UIColor(red: 0.16, green: 0.29, blue: 0.64, alpha: 1)
        self.scrollview.addSubview(layer1)
        
        let layer3 = UIView(frame: CGRect(x: 251, y: 336, width: 107, height: 122))
        layer3.layer.cornerRadius = 15
        layer3.backgroundColor = UIColor(red: 0.16, green: 0.54, blue: 0.53, alpha: 1)
        self.scrollview.addSubview(layer3)
        
        var textLayer = UILabel(frame: CGRect(x: 31, y: 355, width: 69, height: 18))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        var textContent = "Cuspidor"
        var textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18)!
            ])
        var textRange = NSRange(location: 0, length: textString.length)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        textLayer = UILabel(frame: CGRect(x: 147, y: 355, width: 42, height: 36))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        textContent = "Blues News"
        textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18)!
            ])
        textRange = NSRange(location: 0, length: textString.length)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        textLayer = UILabel(frame: CGRect(x: 263, y: 355, width: 69, height: 18))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        textContent = "Other"
        textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18)!
            ])
        textRange = NSRange(location: 0, length: textString.length)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
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
        
        let pubLayer = UILabel(frame: CGRect(x: 22, y: 303, width: 104, height: 20))
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
        
        let lLayer = UILabel(frame: CGRect(x: 18, y: 482, width: 182, height: 20))
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
        
        let layer1 = UIView(frame: CGRect(x: 18, y: 132, width: 190, height: 144))
        layer1.layer.cornerRadius = 15
        layer1.backgroundColor = UIColor(red: 0.46, green: 0.75, blue: 0.85, alpha: 1)
        layer1.addGestureRecognizer(tap1)
        self.scrollview.addSubview(layer1)
        
        let layer = UIView(frame: CGRect(x: 150, y: 200, width: 73.27, height: 90.47))
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -2.007128639793479)
        layer.transform = transform
        layer.layer.cornerRadius = 0
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.18)
        layer.addGestureRecognizer(tap2)
        self.scrollview.addSubview(layer)
        
        let layer2 = UIView(frame: CGRect(x: 34, y: 230, width: 121, height: 27))
        layer2.layer.cornerRadius = 15
        layer2.layer.borderWidth = 2
        layer2.layer.borderColor = UIColor.white.cgColor
        layer2.addGestureRecognizer(tap)
        self.scrollview.addSubview(layer2)
        
        let textLayer = UILabel(frame: CGRect(x: 38, y: 180, width: 122, height: 36))
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
        
        let textLayer1 = UILabel(frame: CGRect(x: 57, y: 237, width: 75, height: 14))
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
        
        let ctextLayer = UILabel(frame: CGRect(x: 40, y: 159, width: 85, height: 14))
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
        i_view.frame = CGRect(x: 218, y: 132, width: 134, height: 144)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let article = Article(text: "The Liberal majority on the House of Commons ethic committee has voted down an opposition motion to call Conflict of Interest andEthics Commissioner Mario Dion to testify about his report concluding thatPrime Minister Justin Trudeau violated the Conflict of Interest Act over the SNC-Lavalinaffair. Liberal MP Steven MacKinnon said he and the other Liberal Msitting on the committee today voted down the motion because, following Dion'sreport and hours of testimony on the scandal over a five-week period, therewas nothing new to add to their understanding of the SNC-Lavalin affair.Theopposition's claim to simply wanting the facts is contradicted by the fact thatwhat they seek is found in the commissioner's report, MacKinnon said. The only conclusion that I, and members of this committee, can come to is that thopposition seeks to prolong this process for reasons of politics, reasons ofpartisan games, and it is for that reason … that we will be opposing this motion. Liberal MP Nathaniel Erskine-Smith broke ranks with his party and votedwith opposition MPs to call Dion before the committee — not, he said, becausehe thought Dion had more to tell, but because he wanted to challenge thecommissioner's findings, which he called flawed. I would like the commissionerto sit right there to answer how he got this so completely, completelywrong, Erskine-Smith said."
            , author: "Baker Jackson", img: #imageLiteral(resourceName: "000"), title: "Jacky's Solution is bad and won't work hello hello hello")
        
        if let destinationVC = segue.destination as? ArticleViewController {
            destinationVC.article = article
            destinationVC.source = 1
        }
    }
    
    @IBAction func returnFromArticle (sender: UIStoryboardSegue) {}
}
