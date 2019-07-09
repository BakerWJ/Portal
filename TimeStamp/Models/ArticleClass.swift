//
//  ArticleClass.swift
//  UTS APP
//
//  Created by Baker Jackson on 2019-04-10.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit

//Defines class for a news article, which will be displayed in the table view

class Article {
    var text: String
    var author: String
    
    //Image is Optional
    
    var img: UIImage
    var title: String
    
    
    //Initializer for article class
    init(text: String, author: String, img: UIImage, title: String) {
        self.text = text
        self.author = author
        self.img = img
        self.title = title
    }
}
