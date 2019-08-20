//
//  PublicationViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-08-20.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class PublicationViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello"
        return cell
    }
    
    
    let articleTableView = UITableView() //view

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(articleTableView)
        articleTableView.translatesAutoresizingMaskIntoConstraints = false
        articleTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        articleTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        articleTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        articleTableView.dataSource = self
        articleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view.
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
