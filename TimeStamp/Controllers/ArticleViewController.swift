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
        image()
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
        self.performSegue(withIdentifier: "articleu", sender: self)
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
    
    func image() {
        let articleImage = UIImage(named: "000")
        let bgimage = UIImageView(image: articleImage)
        bgimage.frame = CGRect(x: -29.03, y: -48.31, width: 433.3, height: 477.29)
        bgimage.clipsToBounds = true
        bgimage.contentMode = .scaleAspectFill
        self.scrollview.addSubview(bgimage)
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
        
        let textLayer = UILabel(frame: CGRect(x: 37.79, y: 559, width: 300, height: 616))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        textLayer.alpha = 1
        let textContent = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounterconsequences that are extremely painful.Nor again is there anyone who loves or pursues ordesires to obtain pain of itself, because it is pain, butbecause occasionally circumstances occur in whichtoil and pain can procure him some great pleasure. Totake a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure? On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are. On the other hand, we denounce with righteous indignation and dislike men who are so beguiled and demoralized by the charms of pleasure of the moment, so blinded by desire, that they cannot foresee the pain and trouble that are bound to ensue; and equal blame belongs to those who fail in their duty through weakness of will, which is the same as saying through shrinking from toil and pain. These cases are perfectly simple and easy to distinguish. In a free hour, when our power of choice is untrammelled and when nothing prevents our being able to do what we like best, every pleasure is to be welcomed and every pain avoided. But in certain circumstances and owing to the claims of duty or the obligations of business it will frequently occur that pleasures have to be repudiated and annoyances accepted."
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 14)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.21, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
    }

}
