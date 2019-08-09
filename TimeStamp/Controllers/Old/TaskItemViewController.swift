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
        text.isScrollEnabled = false;
        text.delegate = self;
        text.text = titlePlaceHolder
        text.textColor = .lightGray
        text.font = UIFont (name: "SegoeUI", size: 16);
        return text;
    }()
    
    lazy var detailText: UITextView = {
        let text = UITextView ();
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.isScrollEnabled = false;
        text.backgroundColor = .clear;
        text.delegate = self;
        text.text = detailPlaceHolder
        text.textColor = .lightGray
        text.font = UIFont (name: "SegoeUI", size: 14);
        return text;
    }()
    
    //the label displaying the current selected tag
    let tagSelect: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.textAlignment = .center;
        label.font = UIFont (name: "SegoeUI", size: 14);
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label;
    }()
    
    let selectTaskTagView: SelectTaskTagView = {
        let view = SelectTaskTagView()
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    //initialize the completed (or not) button
    let checkMark: UIButton = {
        let button = UIButton();
        button.backgroundColor = .clear;
        button.setBackgroundImage(UIImage(named: "notChecked"), for: .normal);
        button.setBackgroundImage(UIImage(named: "notChecked"), for: [.normal, .highlighted]);
        button.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        button.setBackgroundImage(UIImage(named: "checked"), for: [.selected, .highlighted]);
        button.translatesAutoresizingMaskIntoConstraints = false;
        return button;
    }()
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    let titlePlaceHolder = "title";
    let detailPlaceHolder  = "description";
    
    //stackview that contains all the views
    let stackview = UIStackView()
    //scrollview that contains the stackview
    let scrollview = UIScrollView()
    
    //the titleText heigh constraint
    var titleHeight = NSLayoutConstraint()
    
    //the detailText height constraint
    var detailHeight = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup ()
    }
    
    private func setup ()
    {
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);

        //sets up the cancel button constraints
        cancelButton.addTarget(self, action: #selector (back), for: .touchUpInside);
        view.addSubview (cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        cancelButton.widthAnchor.constraint (equalTo: cancelButton.heightAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        cancelButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        
        //add the checkmark at the top right corner
        view.addSubview(checkMark);
        checkMark.translatesAutoresizingMaskIntoConstraints = false;
        checkMark.heightAnchor.constraint(equalToConstant: 18/812.0*screenHeight).isActive = true;
        checkMark.widthAnchor.constraint (equalTo: checkMark.heightAnchor).isActive = true;
        checkMark.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        checkMark.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -30/375.0*screenWidth).isActive = true;

        
        //sets up the scrollview
        view.addSubview(scrollview);
        scrollview.translatesAutoresizingMaskIntoConstraints = false;
        scrollview.topAnchor.constraint (equalTo: cancelButton.bottomAnchor, constant: 20/812.0*screenHeight).isActive = true;
        scrollview.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        scrollview.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        scrollview.heightAnchor.constraint (equalToConstant: (812.0 - 18 - 60 - 20)/812.0*screenHeight).isActive = true;
        
        //sets up stackview that contains all the contents
        stackview.axis = .vertical;
        stackview.spacing = 10/812.0*screenHeight;
        stackview.alignment = .center;
        scrollview.addSubview (stackview);
        stackview.translatesAutoresizingMaskIntoConstraints = false;
        stackview.leadingAnchor.constraint (equalTo: scrollview.leadingAnchor).isActive = true;
        stackview.trailingAnchor.constraint (equalTo: scrollview.trailingAnchor).isActive = true;
        stackview.topAnchor.constraint (equalTo: scrollview.topAnchor).isActive = true;
        stackview.bottomAnchor.constraint (equalTo: scrollview.bottomAnchor).isActive = true;
        stackview.centerXAnchor.constraint (equalTo: scrollview.centerXAnchor).isActive = true;
        
        //set up titleText
        stackview.addArrangedSubview(titleText);
        titleText.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true;
        titleHeight = titleText.heightAnchor.constraint(equalToConstant: 40/812.0*screenHeight);
        titleHeight.isActive = true;
        
        //set up detailText
        stackview.addArrangedSubview(detailText);
        detailText.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true;
        detailHeight = detailText.heightAnchor.constraint(equalToConstant: 40/812.0*screenHeight);
        detailHeight.isActive = true;
        
        //set up tag selection label;
        stackview.addArrangedSubview(tagSelect);
        //this gesture recognizes a press on the label and goes to the function "willSelectTag"
        let gestureRecognizer = UITapGestureRecognizer (target: self, action: #selector (willSelectTag));
        tagSelect.addGestureRecognizer(gestureRecognizer);
        //constraints
        tagSelect.widthAnchor.constraint (equalToConstant: screenWidth).isActive = true;
        tagSelect.text = "Select Tag";
        tagSelect.heightAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        tagSelect.isUserInteractionEnabled = true;
        
        //tag select view
        view.addSubview(selectTaskTagView);
        selectTaskTagView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        selectTaskTagView.widthAnchor.constraint (equalToConstant: 200/375.0*screenWidth).isActive = true;
        selectTaskTagView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        selectTaskTagView.heightAnchor.constraint(equalToConstant: 400/812.0*screenHeight).isActive = true;
        selectTaskTagView.isHidden = true;
        //selectTaskTagView.heightAnchor.constraint (equalToConstant: )
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
    
    func textViewDidChange(_ textView: UITextView)
    {
        let changedConstraint = (textView === titleText ? titleHeight : detailHeight);
        if (changedConstraint.constant == textView.intrinsicContentSize.height) {return}
        changedConstraint.constant = textView.intrinsicContentSize.height;
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            textView.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: segues
    
    @objc func back()
    {
        performSegue(withIdentifier: "fromTaskItem", sender: self);
    }
    
    //MARK: gestures
    @objc func willSelectTag ()
    {
        print ("hello")
        selectTaskTagView.reload()
        selectTaskTagView.isHidden = false;
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
