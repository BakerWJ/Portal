//
//  ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

class GetStartedViewController: UIViewController {
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    lazy var stackView : UIStackView = {
        let view = UIStackView();
        view.axis = .vertical;
        view.alignment = .fill;
        view.distribution = .fillEqually
        view.spacing = 30/812.0*screenHeight;
        return view;
    }()
    
    let mask = UIImageView(image: UIImage(named: "curvyMask"));

    lazy var maskView : UIView = {
        let view = UIView ();
        view.mask = mask;
        view.clipsToBounds = true;
        view.layer.masksToBounds = true;
        return view;
    }()
    
    let imageView = UIImageView (image: UIImage (named: "onLakeImage"));
    
    lazy var doneButton: UIButton = {
        let button = UIButton ();
        button.backgroundColor = UIColor.getColor(40, 73, 164);
        button.addTarget(self, action: #selector (done), for: .touchUpInside);
        button.setTitle("Done!", for: .normal);
        button.setTitle("Done!", for: .highlighted);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.titleLabel?.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        return button;
    }()
    
    lazy var movingRect: UIView = {
        let view = UIView ()
        view.backgroundColor = UIColor.getColor(223, 168, 144)
        return view;
    }()
    
    lazy var yourInterestLabel: UILabel = {
        let label = UILabel ();
        let text = NSMutableAttributedString(string: "Tell Us what ", attributes: [.font: UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]);
        text.append(NSMutableAttributedString (string: "Interests you!", attributes: [.font: UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)]));
        label.attributedText = text;
        label.textColor = UIColor.getColor(40, 73, 164);
        label.backgroundColor = .clear;
        return label;
    }()
    
    let containerView = UIView ()
    var movingRectTrailing = NSLayoutConstraint();
    
    var buttons = [AnimatingButtonView]();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setup();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        mask.frame = maskView.bounds;
    }
    
    var imageTop = NSLayoutConstraint();
    var imageLeading = NSLayoutConstraint();
    
    private func setup()
    {
        view.backgroundColor = .white;
        buttons = [AnimatingButtonView]()
        for _ in 0..<4
        {
            let button = AnimatingButtonView()
            buttons.append (button);
            stackView.addArrangedSubview(button);
            button.translatesAutoresizingMaskIntoConstraints = false;
        }
        buttons [0].text = "General";
        let gr1 = UITapGestureRecognizer (target: self, action: #selector(generalClick));
        buttons[0].addGestureRecognizer(gr1);
        
        buttons [1].text = "House";
        let gr2 = UITapGestureRecognizer(target: self, action: #selector (houseClick));
        buttons [1].addGestureRecognizer(gr2);
        
        buttons [2].text = "Articles";
        let gr3 = UITapGestureRecognizer(target: self, action: #selector (articleClick));
        buttons [2].addGestureRecognizer(gr3);
        
        buttons [3].text = "Surveys";
        let gr4 = UITapGestureRecognizer(target: self, action: #selector(surveyClick));
        buttons [3].addGestureRecognizer(gr4);
        
        //add containerview that contains the stackview
        view.addSubview(containerView);
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        containerView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        containerView.topAnchor.constraint (equalTo: view.topAnchor, constant: 212/812.0*screenHeight).isActive = true;
        containerView.widthAnchor.constraint(equalToConstant: 295.0/375.0*screenWidth).isActive = true;
        containerView.heightAnchor.constraint (equalToConstant: 402/812.0*screenHeight).isActive = true;
        containerView.backgroundColor = .white;
        containerView.layer.cornerRadius = 10/375.0*screenWidth;
        containerView.layoutIfNeeded()
        containerView.dropShadow();
        
        //add stackview contraints
        containerView.addSubview(stackView);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.centerXAnchor.constraint (equalTo: containerView.centerXAnchor).isActive = true;
        stackView.centerYAnchor.constraint (equalTo: containerView.centerYAnchor).isActive = true;
        stackView.widthAnchor.constraint (equalToConstant: 231/375.0*screenWidth).isActive = true;
        stackView.heightAnchor.constraint(equalToConstant: 304/812.0*screenHeight).isActive = true;
        
        //add doneButton
        view.addSubview (doneButton);
        doneButton.translatesAutoresizingMaskIntoConstraints = false;
        doneButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        doneButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 696/812.0*screenHeight).isActive = true;
        doneButton.heightAnchor.constraint (equalToConstant: 45/812.0*screenHeight).isActive = true;
        doneButton.widthAnchor.constraint (equalToConstant: 307/375.0*screenWidth).isActive = true;
        doneButton.layoutIfNeeded();
        doneButton.layer.cornerRadius = doneButton.frame.height/3;
        doneButton.dropShadow()
        
        //add interest label
        view.addSubview(yourInterestLabel);
        yourInterestLabel.translatesAutoresizingMaskIntoConstraints = false;
        yourInterestLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        yourInterestLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 654/812.0*screenHeight).isActive = true;
        yourInterestLabel.widthAnchor.constraint (equalToConstant: 219/375.0*screenWidth).isActive = true;
        yourInterestLabel.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        
        //add the moving rectangle (line)
        view.addSubview(movingRect);
        movingRect.translatesAutoresizingMaskIntoConstraints = false;
        movingRectTrailing = movingRect.trailingAnchor.constraint (equalTo: yourInterestLabel.trailingAnchor);
        movingRectTrailing.isActive = true;
        movingRect.heightAnchor.constraint (equalToConstant: 2/812.0*screenHeight).isActive = true;
        movingRect.widthAnchor.constraint (equalToConstant: 503/375.0*screenWidth).isActive = true;
        movingRect.topAnchor.constraint (equalTo: yourInterestLabel.bottomAnchor).isActive = true;
        
        //add the maskView
        view.addSubview(maskView);
        maskView.translatesAutoresizingMaskIntoConstraints = false;
        maskView.topAnchor.constraint (equalTo: view.topAnchor, constant: -21/812.0*screenHeight).isActive = true;
        maskView.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: -64/375.0*screenWidth).isActive = true;
        maskView.widthAnchor.constraint (equalToConstant: 592/375.0*screenWidth).isActive = true;
        maskView.heightAnchor.constraint (equalToConstant: 232.86/812.0*screenHeight).isActive = true;
        
        maskView.addSubview(imageView);
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        imageTop = imageView.topAnchor.constraint (equalTo: maskView.topAnchor, constant: -63/812.0*screenHeight);
        imageTop.isActive = true;
        imageLeading = imageView.leadingAnchor.constraint (equalTo: maskView.leadingAnchor, constant: 60/375.0*screenWidth);
        imageLeading.isActive = true;
        imageView.heightAnchor.constraint (equalToConstant: 296/812.0*screenHeight).isActive = true;
        imageView.widthAnchor.constraint (equalToConstant: 395/375.0*screenWidth).isActive = true;
    }
    
    @objc func generalClick() {
        buttons[0].isSelected = !buttons[0].isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].generalNotifications = buttons[0].isSelected
            }
        }
        catch {
            fatalError("There was an er ror fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @objc func houseClick() {
        buttons[1].isSelected = !buttons[1].isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].houseNotifications = buttons[1].isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @objc func articleClick () {
        buttons[2].isSelected = !buttons[2].isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].articleNotifications = buttons[2].isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @objc func surveyClick() {
        buttons[3].isSelected = !buttons[3].isSelected
        let fetchRequest = NSFetchRequest <NSFetchRequestResult> (entityName: "Settings");
        do {
            if let results = try CoreDataStack.managedObjectContext.fetch(fetchRequest) as? [Settings] {
                results[0].surveyNotifications = buttons[3].isSelected
            }
        }
        catch {
            fatalError("There was an error fetching the list of timetables");
        }
        CoreDataStack.saveContext()
    }
    
    @objc func done(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setNotifications()
        performSegue(withIdentifier: "toSetUp", sender: self);
    }
}

