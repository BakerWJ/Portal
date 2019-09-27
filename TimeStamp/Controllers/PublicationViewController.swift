//
//  PublicationViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-20.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class PublicationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let w = UIScreen.main.bounds.width
    let articles = UserDataSettings.fetchAllArticles()
    
    var selected = 0
    
    var pub: Int? {
        didSet {
            if (pub == 0) {
                titleLabel.text = "CUSPIDOR"
            }
            else if (pub == 1) {
                titleLabel.text = "BLUES NEWS"
            }
            else {
                titleLabel.text = "OTHER"
            }
        }
    }
    
    lazy var pubArticles: [Article] = {
        guard let article = articles else {return [Article]()}
        var array: [Article] = [Article]()
        let sortedarticles = article.sorted { (article1, article2) -> Bool in
            return article1.timestamp as Date >= article2.timestamp as Date
        }
        for i in sortedarticles {
            if i.publication == pub! {
                array.append(i)
            }
        }
        return array
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let article = articles else {return 0}
        var cuspidor: Int = 0
        var bNews: Int = 0
        var other: Int = 0
        for i in article {
            if i.publication == 0 {
                cuspidor += 1
            }
            else if i.publication == 1 {
                bNews += 1
            }
            else {
                other += 1
            }
        }
        if (pub == 0) {
            return cuspidor
        }
        else if (pub == 1) {
            return bNews
        }
        return other
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PublicationTableViewCell
        cell.article = pubArticles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 363/375*w
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selected = indexPath.row
        performSegue(withIdentifier: "articlePub", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen;
        if let destinationVC = segue.destination as? ArticleViewController {
            destinationVC.delegate = self;
            destinationVC.article = pubArticles[selected]
            destinationVC.source = 0
        }
    }
    
    
    let articleTableView = UITableView() //view

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar()
        view.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90/375*w).isActive = true
        articleTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        articleTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        articleTableView.dataSource = self
        articleTableView.register(PublicationTableViewCell.self, forCellReuseIdentifier: "cell")
        articleTableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        articleTableView.layoutIfNeeded()
        let oldContentOffset = articleTableView.contentOffset
        articleTableView.reloadData()
        articleTableView.layoutIfNeeded()
        self.articleTableView.setContentOffset(oldContentOffset, animated: false)
    }
    
    @objc func exit() {
        dismiss(animated: true)
    }
    
    let titleLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "Arial", size: 20/375*UIScreen.main.bounds.width)
        textLayer.textColor = UIColor.black
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.textAlignment = .center
        return textLayer;
    }()
    
    func navBar() {
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: 375/375*w, height: 90/375*w))
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: -1/375*w, y: 0)
        layer.transform = transform
        layer.backgroundColor = UIColor.white
        layer.layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.layer.shadowOpacity = 1
        layer.layer.shadowRadius = 4/375*w
        self.view.addSubview(layer)
        
        self.view.addSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 300/375*w).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 22/375*w).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50/375*w).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 37.5/375*w).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(exit))
        
        let f_image = UIImage(named: "Exit")
        let i_view = UIImageView(image: f_image)
        i_view.frame = CGRect(x: 36/375*w, y: 50/375*w, width: 20/375*w, height: 20/375*w)
        i_view.clipsToBounds = true
        i_view.isUserInteractionEnabled = true
        i_view.contentMode = .scaleAspectFill
        i_view.addGestureRecognizer(tap)
        self.view.addSubview(i_view)
    }
    
    @IBAction func returnToPub (sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
