//
//  LoginToTabBar.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-09-26.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class LoginToTabBar: UIStoryboardSegue {
    override func perform ()
    {
        self.destination.modalPresentationStyle = .fullScreen;
        self.source.present(self.destination, animated: false, completion: nil)
    }
}
