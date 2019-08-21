//
//  PublicationViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-20.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class PublicationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    let a = Article(text: "First, there was the adjusted fighting weight of the rookie, as the team changed the reported number from 200 pounds....", author: "Baker Jackson", img: #imageLiteral(resourceName: "f_image"), title: "The Blue Jays are an Amazing Team.")
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PublicationTableViewCell
        cell.article = a
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 363
    }
    
    
    let articleTableView = UITableView() //view

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar()
        view.addSubview(articleTableView)
        articleTableView.delegate = self
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        articleTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        articleTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        articleTableView.dataSource = self
        articleTableView.register(PublicationTableViewCell.self, forCellReuseIdentifier: "cell")
        articleTableView.separatorStyle = .none
    }
    
    @objc func exit() {
        dismiss(animated: true)
    }
    
    func navBar() {
        let layer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 90))
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: -1, y: 0)
        layer.transform = transform
        layer.backgroundColor = UIColor.white
        layer.layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        layer.layer.shadowOpacity = 1
        layer.layer.shadowRadius = 4
        self.view.addSubview(layer)
        
        let textLayer = UILabel(frame: CGRect(x: 134, y: 48, width: 108, height: 22))
        textLayer.lineBreakMode = .byWordWrapping
        textLayer.numberOfLines = 0
        textLayer.textColor = UIColor.black
        textLayer.alpha = 1
        textLayer.textAlignment = .center
        let textContent = "CUSPIDOR"
        let textString = NSMutableAttributedString(string: textContent, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Arial", size: 20)!
            ])
        let textRange = NSRange(location: 0, length: textString.length)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.1
        textString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: textRange)
        textString.addAttribute(NSAttributedString.Key.kern, value: 0.3, range: textRange)
        textLayer.attributedText = textString
        textLayer.sizeToFit()
        self.view.addSubview(textLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(exit))
        
        let f_image = UIImage(named: "Exit")
        let i_view = UIImageView(image: f_image)
        i_view.frame = CGRect(x: 36, y: 50, width: 20, height: 20)
        i_view.clipsToBounds = true
        i_view.isUserInteractionEnabled = true
        i_view.contentMode = .scaleAspectFill
        i_view.addGestureRecognizer(tap)
        self.view.addSubview(i_view)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
