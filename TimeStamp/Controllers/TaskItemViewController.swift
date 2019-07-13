//
//  TaskItemViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-10.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TaskItemViewController: UIViewController, UITextViewDelegate {

    let cancelButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    lazy var titleText: UITextView = {
        let text = UITextView ();
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.backgroundColor = .clear;
        text.delegate = self;
        text.text = titlePlaceHolder
        text.textColor = .lightGray
        text.font = UIFont (name: "SegoeUI", size: 16);
        return text;
    }()
    
    lazy var detailText: UITextView = {
        let text = UITextView ();
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.backgroundColor = .clear;
        text.delegate = self;
        text.text = detailPlaceHolder
        text.textColor = .lightGray
        text.font = UIFont (name: "SegoeUI", size: 14);
        return text;
    }()
    
    let tagSelect: UIButton = {
        let button = UIButton();
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.backgroundColor = .clear;
        return button;
    }()
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    let titlePlaceHolder = "title";
    let detailPlaceHolder  = "description";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup ()
    }
    
    private func setup ()
    {
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);

        cancelButton.addTarget(self, action: #selector (back), for: .touchUpInside);
        view.addSubview (cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        cancelButton.widthAnchor.constraint (equalTo: cancelButton.heightAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        cancelButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 60/812.0*screenWidth).isActive = true;
    }
    
    //MARK: TextView Delegate methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        let placeHolderText = (textView === titleText ? titlePlaceHolder : detailPlaceHolder);
        if (textView.text == placeHolderText)
        {
            textView.text = "";
            textView.textColor = .black;
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let placeHolderText = (textView === titleText ? titlePlaceHolder : detailPlaceHolder);
        if (textView.text == "")
        {
            textView.text = placeHolderText;
            textView.textColor = .lightGray;
        }
        textView.resignFirstResponder()
    }
    
    //MARK: segues
    
    @objc func back()
    {
        performSegue(withIdentifier: "fromTaskItem", sender: self);
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
