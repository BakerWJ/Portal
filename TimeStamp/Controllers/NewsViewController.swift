//
//  NewsViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-07-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import LBTAComponents

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let w = UIScreen.main.bounds.width;
    let h = UIScreen.main.bounds.height;
    
    var articles = UserDataSettings.fetchAllArticles()
    var timer: Timer?;
    
    var row: Int = 1
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count == nil ? 0 : articles!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        performSegue(withIdentifier: "article", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! NewsPageTableViewCell
        var array = [Article]()
        if (clicked == 0) {
            array = new
        }
        else if (clicked == 1) {
            array = sift
        }
        else {
            array = popular
        }
        cell.article = array [indexPath.row]
        return cell
    }
    
    let featuredArticle : Article? = {
        let articles = UserDataSettings.fetchAllArticles()
        var selected : Article?
        guard let article = articles else {return nil}
        for each in article {
            if (selected == nil)
            {
                selected = each;
            }
            else if (each.likes > selected!.likes)
            {
                selected = each;
            }
        }
        return selected
    }()
    
    
    func popArticles() -> [Article] {
        guard let article = articles else {return [Article]()}
        let sortedarticles = article.sorted { (article1, article2) -> Bool in
            return article1.likes > article2.likes
        }
        return sortedarticles
    }
    
    func siftArticles() -> [Article]  {
        guard let article = articles else {return [Article]()}
        return article;
    }

    func newArticles() -> [Article] {
        guard let article = articles else {return [Article]()}
        let sortedarticles = article.sorted { (article1, article2) -> Bool in
            return article1.timestamp as Date >= article2.timestamp as Date
        }
        return sortedarticles
    }
    
    var popular = [Article]()
    var sift = [Article]()
    var new = [Article]()
    
    //this view is so that the content of the view does not block the status bar
    lazy var blockView: UIView = {
        let view = UIView()
        view.backgroundColor = .white;
        return view;
    }()
    
    var featured: Int = 0
    var clicked: Int = 0
    var publication: Int = 0
    
    let articlesView = UITableView() // Bottom articles
    
    lazy var scrollview: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never;
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.refresh()
        timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector (fireTimer), userInfo: nil, repeats: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        //stops the timer when the view disappears
        timer?.invalidate()
    }
    
    @objc func fireTimer ()
    {
        self.refresh()
    }
    
    private func refresh ()
    {
        articles = UserDataSettings.fetchAllArticles()
        sift = self.siftArticles()
        new = self.newArticles()
        popular = self.popArticles()
        articlesView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        new = self.newArticles()
        popular = self.popArticles()
        sift = self.siftArticles()
        view.addSubview(scrollview)
        setupScroll()
        topText()
        featuredView()
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
        articlesView.bottomAnchor.constraint (equalTo: scrollview.bottomAnchor, constant: -100/375.0*w).isActive = true;
        
        articlesView.dataSource = self
        articlesView.register(NewsPageTableViewCell.self, forCellReuseIdentifier: "articleCell")
        articlesView.delegate = self
        articlesView.isScrollEnabled = false
        articlesView.rowHeight = 127/375.0 * w
        articlesView.separatorStyle = .none
        
        DispatchQueue.main.async {
            self.articlesView.reloadData()
            self.articlesView.layoutIfNeeded()
            self.articlesView.heightAnchor.constraint (equalToConstant: self.articlesView.rowHeight*CGFloat(self.articles!.count)).isActive = true;
        }
        
        view.addSubview(blockView);
        blockView.translatesAutoresizingMaskIntoConstraints = false;
        blockView.topAnchor.constraint (equalTo: view.topAnchor).isActive = true;
        view.addConstraintsWithFormat("H:|[v0]|", views: blockView);
        blockView.heightAnchor.constraint (equalToConstant: 30/812.0*h).isActive = true;
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
    
    func featuredView() {
        guard let featuredArticle = featuredArticle else {return}
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
        let textContent = featuredArticle.title
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
        let ctextContent = featuredArticle.genre
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
        
        let i_view = CachedImageView()
        i_view.image = #imageLiteral(resourceName: "f_image")
        i_view.loadImage(urlString: featuredArticle.img)
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
        clicked = 0
        articlesView.reloadData()
        newLabel.alpha = 1
        popularLabel.alpha = 0.5
        siftLabel.alpha = 0.5
    }
    
    @objc func filterSiftTap() {
        clicked = 1
        articlesView.reloadData()
        newLabel.alpha = 0.5
        popularLabel.alpha = 0.5
        siftLabel.alpha = 1
    }
    
    @objc func filterPopTap() {
        clicked = 2
        articlesView.reloadData()
        newLabel.alpha = 0.5
        popularLabel.alpha = 1
        siftLabel.alpha = 0.5
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        featured = 1
        performSegue(withIdentifier: "article", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destinationVC = segue.destination as? ArticleViewController {
            if (featured == 1) {
                featured = 0
                destinationVC.article = featuredArticle
            }
            else if (clicked == 1) {
                destinationVC.article = sift[row]
            }
            else if (clicked == 2) {
                destinationVC.article = popular[row]
            }
            else {
                destinationVC.article = new[row]
            }
            destinationVC.source = 1
        }
        if let destinationVC = segue.destination as? PublicationViewController {
            destinationVC.pub = publication
        }
    }
    
    @IBAction func returnFromArticle (sender: UIStoryboardSegue) {}
}
