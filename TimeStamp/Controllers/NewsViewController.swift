//
//  NewsViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let w = UIScreen.main.bounds.width
    
    let a = Article(text: "First, there was the adjusted fighting weight of the rookie, as the team changed the reported number from 200 pounds....", author: "Baker Jackson", img: #imageLiteral(resourceName: "f_image"), title: "The Blue Jays are an Amazing Team.", genre: "Bad", likes: 6, hash: "bleh")
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "article", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! NewsPageTableViewCell
        cell.article = a
        return cell
    }
    
    
    var clicked: Int = 0
    var publication: Int = 0
    
    let articlesView = UITableView() // Bottom articles
    
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 1120/375 * UIScreen.main.bounds.width
        view.contentSize.width = UIScreen.main.bounds.width
        return view
    }()
    
    let newLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 20/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor(red: 0, green: 0.19, blue: 0.34, alpha: 1)
        textLayer.text = "New"
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.textAlignment = .center
        return textLayer
    }()
    
    let popularLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 20/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor(red: 0, green: 0.19, blue: 0.34, alpha: 1)
        textLayer.text = "Popular"
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.textAlignment = .center
        return textLayer
    }()
    
    let siftLabel:UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 20/375 * UIScreen.main.bounds.width)
        textLayer.textColor = UIColor(red: 0, green: 0.19, blue: 0.34, alpha: 1)
        textLayer.text = "Sift"
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.textAlignment = .center
        return textLayer
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
        setupScroll()
        topText()
        featured()
        publications()
        
        // featured articles code
        
        let newTap = UITapGestureRecognizer(target: self, action: #selector(filterNewTap))
        let popTap = UITapGestureRecognizer(target: self, action: #selector(filterPopTap))
        let siftTap = UITapGestureRecognizer(target: self, action: #selector(filterSiftTap))
        
        newLabel.addGestureRecognizer(newTap)
        popularLabel.addGestureRecognizer(popTap)
        siftLabel.addGestureRecognizer(siftTap)
        
        newLabel.isUserInteractionEnabled = true
        popularLabel.isUserInteractionEnabled = true
        siftLabel.isUserInteractionEnabled = true
        
        popularLabel.alpha = 0.5
        siftLabel.alpha = 0.5
        
        self.scrollview.addSubview(newLabel)
        self.scrollview.addSubview(popularLabel)
        self.scrollview.addSubview(siftLabel)
        
        newLabel.widthAnchor.constraint(equalToConstant: w / 3).isActive = true
        newLabel.heightAnchor.constraint(equalToConstant: 20/375 * w).isActive = true
        newLabel.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 514/375 * w).isActive = true
        newLabel.leftAnchor.constraint(equalTo: scrollview.leftAnchor).isActive = true
        
        popularLabel.widthAnchor.constraint(equalToConstant: w/3).isActive = true
        popularLabel.heightAnchor.constraint(equalToConstant: 20/375 * w).isActive = true
        popularLabel.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 514/375 * w).isActive = true
        popularLabel.leftAnchor.constraint(equalTo: newLabel.rightAnchor).isActive = true
        
        siftLabel.widthAnchor.constraint(equalToConstant: w/3).isActive = true
        siftLabel.heightAnchor.constraint(equalToConstant: 20/375 * w).isActive = true
        siftLabel.topAnchor.constraint(equalTo: scrollview.topAnchor, constant: 514/375 * w).isActive = true
        siftLabel.leftAnchor.constraint(equalTo: popularLabel.rightAnchor).isActive = true
        
        
        // configuring 4 articles at bottom
        
        self.scrollview.addSubview(articlesView)
        articlesView.translatesAutoresizingMaskIntoConstraints = false
        articlesView.topAnchor.constraint(equalTo: self.scrollview.topAnchor, constant: 541/375 * w).isActive = true
        articlesView.leftAnchor.constraint(equalTo: self.scrollview.leftAnchor).isActive = true
        articlesView.widthAnchor.constraint(equalToConstant: w).isActive = true
        articlesView.heightAnchor.constraint(equalToConstant: 508/375 * w).isActive = true
        
        articlesView.dataSource = self
        articlesView.register(NewsPageTableViewCell.self, forCellReuseIdentifier: "articleCell")
        articlesView.delegate = self
        articlesView.isScrollEnabled = false
        articlesView.rowHeight = 127/375 * w
        articlesView.separatorStyle = .none
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
    
    func publications() {
        let ctap = UITapGestureRecognizer(target: self, action: #selector(pubCuspidorView))
        let btap = UITapGestureRecognizer(target: self, action: #selector(pubBluesNewsView))
        let otap = UITapGestureRecognizer(target: self, action: #selector(pubOtherView))
        
        let layer = UIView(frame: CGRect(x: 19/375 * w, y: 336/375 * w, width: 107/375 * w, height: 122/375 * w))
        layer.layer.cornerRadius = 15/375 * w
        layer.backgroundColor = UIColor(red: 0.98, green: 0.6, blue: 0.09, alpha: 1)
        layer.addGestureRecognizer(ctap)
        self.scrollview.addSubview(layer)
        
        
        let layer1 = UIView(frame: CGRect(x: 135/375 * w, y: 336/375 * w, width: 107/375 * w, height: 122/375 * w))
        layer1.layer.cornerRadius = 15/375 * w
        layer1.backgroundColor = UIColor(red: 0.16, green: 0.29, blue: 0.64, alpha: 1)
        layer1.addGestureRecognizer(btap)
        self.scrollview.addSubview(layer1)
        
        let layer3 = UIView(frame: CGRect(x: 251/375 * w, y: 336/375 * w, width: 107/375 * w, height: 122/375 * w))
        layer3.layer.cornerRadius = 15/375 * w
        layer3.backgroundColor = UIColor(red: 0.16, green: 0.54, blue: 0.53, alpha: 1)
        layer3.addGestureRecognizer(otap)
        self.scrollview.addSubview(layer3)
        
        var textLayer = UILabel(frame: CGRect(x: 31/375 * w, y: 355/375 * w, width: 69/375 * w, height: 18/375 * w))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        var textContent = "Cuspidor"
        var textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18/375 * w)!
            ])
        var textRange = NSRange(location: 0, length: textString.length)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27/375 * w, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        textLayer = UILabel(frame: CGRect(x: 147/375 * w, y: 355/375 * w, width: 42/375 * w, height: 36/375 * w))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        textContent = "Blues News"
        textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18/375 * w)!
            ])
        textRange = NSRange(location: 0, length: textString.length)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27/375 * w, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        textLayer = UILabel(frame: CGRect(x: 263/375 * w, y: 355/375 * w, width: 69/375 * w, height: 18/375 * w))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        textContent = "Other"
        textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 18/375 * w)!
            ])
        textRange = NSRange(location: 0, length: textString.length)
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27/375 * w, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
    }
    
    func topText() {
        let textLayer = UILabel(frame: CGRect(x: 20/375 * w, y: 57/375 * w, width: 123/375 * w, height: 40/375 * w))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        textLayer.alpha = 1
        let textContent = "Articles"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 40/375 * w)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 1.1/375 * w, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        let tLayer = UILabel(frame: CGRect(x: 18/375 * w, y: 97/375 * w, width: 161/375 * w, height: 20/375 * w))
        tLayer.lineBreakMode = .byWordWrapping
        tLayer.numberOfLines = 0
        tLayer.textColor = UIColor.black
        tLayer.alpha = 1
        let tContent = "Ideas worth Sharing"
        let tString = NSMutableAttributedString(string: tContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 20/375 * w)!
            ])
        let tRange = NSRange(location: 0, length: tString.length)
        let tparagraphStyle = NSMutableParagraphStyle()
        tparagraphStyle.lineSpacing = 1
        tString.addAttribute(NSAttributedString.Key.paragraphStyle, value: tparagraphStyle, range: tRange)
        tString.addAttribute(NSAttributedString.Key.kern, value: 0.3/375 * w, range: tRange)
        tLayer.attributedText = tString
        tLayer.sizeToFit()
        self.scrollview.addSubview(tLayer)
        
        let pubLayer = UILabel(frame: CGRect(x: 22/375 * w, y: 303/375 * w, width: 104/375 * w, height: 20/375 * w))
        pubLayer.lineBreakMode = .byWordWrapping
        pubLayer.numberOfLines = 0
        pubLayer.textColor = UIColor.black
        pubLayer.alpha = 1
        let pubContent = "Publications"
        let pubString = NSMutableAttributedString(string: pubContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 20/375 * w)!
            ])
        let pubRange = NSRange(location: 0, length: pubString.length)
        let pubParagraphStyle = NSMutableParagraphStyle()
        pubParagraphStyle.lineSpacing = 1
        pubString.addAttribute(NSAttributedString.Key.paragraphStyle, value: pubParagraphStyle, range: pubRange)
        pubString.addAttribute(NSAttributedString.Key.kern, value: 0.3/375 * w, range: textRange)
        pubLayer.attributedText = pubString
        pubLayer.sizeToFit()
        self.scrollview.addSubview(pubLayer)
        
        let lLayer = UILabel(frame: CGRect(x: 18/375 * w, y: 482/375 * w, width: 182/375 * w, height: 20/375 * w))
        lLayer.lineBreakMode = .byWordWrapping
        lLayer.numberOfLines = 0
        lLayer.textColor = UIColor.black
        lLayer.alpha = 1
        let lContent = "Latest Stories for You"
        let lString = NSMutableAttributedString(string: lContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 20/375 * w)!
            ])
        let lRange = NSRange(location: 0, length: lString.length)
        let lparagraphStyle = NSMutableParagraphStyle()
        lparagraphStyle.lineSpacing = 1
        lString.addAttribute(NSAttributedString.Key.paragraphStyle, value: lparagraphStyle, range: lRange)
        lString.addAttribute(NSAttributedString.Key.kern, value: 0.3/375 * w, range: lRange)
        lLayer.attributedText = lString
        lLayer.sizeToFit()
        self.scrollview.addSubview(lLayer)
    }
    
    func featured() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        let layer1 = UIView(frame: CGRect(x: 18/375 * w, y: 132/375 * w, width: 190/375 * w, height: 144/375 * w))
        layer1.layer.cornerRadius = 15/375 * w
        layer1.backgroundColor = UIColor(red: 0.46, green: 0.75, blue: 0.85, alpha: 1)
        layer1.addGestureRecognizer(tap1)
        self.scrollview.addSubview(layer1)
        
        let layer = UIView(frame: CGRect(x: 150/375 * w, y: 200/375 * w, width: 73.27/375 * w, height: 90.47/375 * w))
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -2.007128639793479)
        layer.transform = transform
        layer.layer.cornerRadius = 0
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.18)
        layer.addGestureRecognizer(tap2)
        self.scrollview.addSubview(layer)
        
        let layer2 = UIView(frame: CGRect(x: 34/375 * w, y: 230/375 * w, width: 121/375 * w, height: 27/375 * w))
        layer2.layer.cornerRadius = 15/375 * w
        layer2.layer.borderWidth = 2/375 * w
        layer2.layer.borderColor = UIColor.white.cgColor
        layer2.addGestureRecognizer(tap)
        self.scrollview.addSubview(layer2)
        
        
        let textLayer = UILabel(frame: CGRect(x: 38/375 * w, y: 180/375 * w, width: 122/375 * w, height: 36/375 * w))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.white
        textLayer.alpha = 1
        let textContent = "How to design a better app."
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 18/375 * w)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.27/375 * w, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.scrollview.addSubview(textLayer)
        
        let textLayer1 = UILabel(frame: CGRect(x: 57/375 * w, y: 237/375 * w, width: 75/375 * w, height: 14/375 * w))
        textLayer1.lineBreakMode = .byWordWrapping
        textLayer1.numberOfLines = 0
        textLayer1.textColor = UIColor.white
        textLayer1.alpha = 1
        let textContent1 = "READ MORE"
        let textString1 = NSMutableAttributedString(string: textContent1, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner-Bold", size: 14/375 * w)!
            ])
        let textRange1 = NSRange(location: 0, length: textString1.length)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 1
        textString1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle1, range: textRange1)
        textString1.addAttribute(NSAttributedString.Key.kern, value: 0.21/375 * w, range: textRange1)
        textLayer1.attributedText = textString1
        textLayer1.sizeToFit()
        self.scrollview.addSubview(textLayer1)
        
        let ctextLayer = UILabel(frame: CGRect(x: 40/375 * w, y: 159/375 * w, width: 85/375 * w, height: 14/375 * w))
        ctextLayer.lineBreakMode = .byWordWrapping
        ctextLayer.numberOfLines = 0
        ctextLayer.textColor = UIColor.white
        ctextLayer.alpha = 1
        let ctextContent = "ART & DESIGN"
        let ctextString = NSMutableAttributedString(string: ctextContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "SitkaBanner", size: 14/375 * w)!
            ])
        let ctextRange = NSRange(location: 0, length: ctextString.length)
        let cparagraphStyle = NSMutableParagraphStyle()
        cparagraphStyle.lineSpacing = 1
        ctextString.addAttribute(NSAttributedString.Key.paragraphStyle, value: cparagraphStyle, range: ctextRange)
        ctextString.addAttribute(NSAttributedString.Key.kern, value: 0.21/375 * w, range: ctextRange)
        ctextLayer.attributedText = ctextString
        ctextLayer.sizeToFit()
        self.scrollview.addSubview(ctextLayer)
        
        let f_image = UIImage(named: "f_image")
        let i_view = UIImageView(image: f_image)
        i_view.frame = CGRect(x: 218/375 * w, y: 132/375 * w, width: 134/375 * w, height: 144/375 * w)
        i_view.layer.cornerRadius = 15/375 * w
        i_view.clipsToBounds = true
        i_view.contentMode = .scaleAspectFill
        self.scrollview.addSubview(i_view)
    }
    
    @objc func pubCuspidorView() {
        publication = 0
        performSegue(withIdentifier: "pubf", sender: self)
    }
    
    @objc func pubBluesNewsView() {
        publication = 1
        performSegue(withIdentifier: "pubf", sender: self)
    }
    
    @objc func pubOtherView() {
        publication = 2
        performSegue(withIdentifier: "pubf", sender: self)
    }
    
    @objc func filterNewTap() {
        articlesView.reloadData()
        newLabel.alpha = 1
        popularLabel.alpha = 0.5
        siftLabel.alpha = 0.5
    }
    
    @objc func filterSiftTap() {
        articlesView.reloadData()
        newLabel.alpha = 0.5
        popularLabel.alpha = 0.5
        siftLabel.alpha = 1
    }
    
    @objc func filterPopTap() {
        articlesView.reloadData()
        newLabel.alpha = 0.5
        popularLabel.alpha = 1
        siftLabel.alpha = 0.5
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "article", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let article = Article(text: "The Liberal majority on the House of Commons ethic committee has voted down an opposition motion to call Conflict of Interest andEthics Commissioner Mario Dion to testify about his report concluding thatPrime Minister Justin Trudeau violated the Conflict of Interest Act over the SNC-Lavalinaffair. Liberal MP Steven MacKinnon said he and the other Liberal Msitting on the committee today voted down the motion because, following Dion'sreport and hours of testimony on the scandal over a five-week period, therewas nothing new to add to their understanding of the SNC-Lavalin affair.Theopposition's claim to simply wanting the facts is contradicted by the fact thatwhat they seek is found in the commissioner's report, MacKinnon said. The only conclusion that I, and members of this committee, can come to is that thopposition seeks to prolong this process for reasons of politics, reasons ofpartisan games, and it is for that reason … that we will be opposing this motion. Liberal MP Nathaniel Erskine-Smith broke ranks with his party and votedwith opposition MPs to call Dion before the committee — not, he said, becausehe thought Dion had more to tell, but because he wanted to challenge thecommissioner's findings, which he called flawed. I would like the commissionerto sit right there to answer how he got this so completely, completelywrong, Erskine-Smith said."
            , author: "Baker Jackson", img: #imageLiteral(resourceName: "000"), title: "Jacky's Solution is bad and won't work hello hello hello", genre: "SPORTS", likes: 5, hash: "meh")
        
        if let destinationVC = segue.destination as? ArticleViewController {
            destinationVC.article = article
            destinationVC.source = 1
        }
        if let destinationVC = segue.destination as? PublicationViewController {
            destinationVC.pub = publication
        }
    }
    
    @IBAction func returnFromArticle (sender: UIStoryboardSegue) {}
}
