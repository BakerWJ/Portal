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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "articlePub", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let article = Article(text: "The Liberal majority on the House of Commons ethic committee has voted down an opposition motion to call Conflict of Interest andEthics Commissioner Mario Dion to testify about his report concluding thatPrime Minister Justin Trudeau violated the Conflict of Interest Act over the SNC-Lavalinaffair. Liberal MP Steven MacKinnon said he and the other Liberal Msitting on the committee today voted down the motion because, following Dion'sreport and hours of testimony on the scandal over a five-week period, therewas nothing new to add to their understanding of the SNC-Lavalin affair.Theopposition's claim to simply wanting the facts is contradicted by the fact thatwhat they seek is found in the commissioner's report, MacKinnon said. The only conclusion that I, and members of this committee, can come to is that thopposition seeks to prolong this process for reasons of politics, reasons ofpartisan games, and it is for that reason … that we will be opposing this motion. Liberal MP Nathaniel Erskine-Smith broke ranks with his party and votedwith opposition MPs to call Dion before the committee — not, he said, becausehe thought Dion had more to tell, but because he wanted to challenge thecommissioner's findings, which he called flawed. I would like the commissionerto sit right there to answer how he got this so completely, completelywrong, Erskine-Smith said."
            , author: "Baker Jackson", img: #imageLiteral(resourceName: "000"), title: "Jacky's Solution is bad and won't work hello hello hello")
        
        if let destinationVC = segue.destination as? ArticleViewController {
            destinationVC.article = article
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
