//
//  ToDoListViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {

    //initializes the addbutton
    let addButton: UIButton = {
        let button = UIButton ();
        button.setBackgroundImage (UIImage (named: "addItem"), for: .normal);
        return button
    }()
    
    //initializes the cancel button
    let cancelButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    //initializes the list button
    let listButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage (named: "listIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    //initialize the black view that comes up when the side menus are shown
    let blackView: UIView = {
        let view = UIView ();
        view.backgroundColor = UIColor (white: 0, alpha: 0.5);
        view.isHidden = true;
        return view;
    }()
    
    //initializes the event side menu
    let eventMenu = EventMenuView();
    var eventMenuTrailing = NSLayoutConstraint()

    //initializes the task side menu
    let taskMenu = TaskMenuView();
    var taskMenuTrailing = NSLayoutConstraint()
    
    //the current constraint
    var currentTrailing = NSLayoutConstraint()
    
    let taskeventmenu = TaskEventMenu();
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        setConstraints ()
        // Do any additional setup after loading the view.
    }
    
    private func setConstraints ()
    {
        addButton.addTarget(self, action: #selector (toItem), for: .touchUpInside);
        view.addSubview(addButton);
        addButton.translatesAutoresizingMaskIntoConstraints = false;
        addButton.heightAnchor.constraint (equalToConstant: 80/812.0*screenHeight).isActive = true;
        addButton.widthAnchor.constraint (equalToConstant: 80/812.0*screenHeight).isActive = true;
        addButton.bottomAnchor.constraint (equalTo: view.bottomAnchor, constant: -50/812.0*screenHeight).isActive = true;
        addButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 50/812.0*screenHeight).isActive = true;
        addButton.layoutIfNeeded();
        //creates a shadow
        let shadowLayer = CAShapeLayer();
        shadowLayer.path = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.frame.height/2).cgPath;
        shadowLayer.borderColor = UIColor.black.cgColor;
        shadowLayer.borderWidth = 1;
        shadowLayer.fillColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1).cgColor;
        shadowLayer.shadowPath = shadowLayer.path;
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0);
        shadowLayer.shadowOpacity = 0.7;
        shadowLayer.shadowRadius = 4;
        //adds the layer;
        addButton.layer.insertSublayer(shadowLayer, at: 0);
        
        //sets up the cancel button
        cancelButton.addTarget(self, action: #selector (back), for: .touchUpInside);
        view.addSubview (cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        cancelButton.widthAnchor.constraint (equalTo: cancelButton.heightAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        cancelButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 60/812.0*screenWidth).isActive = true;
        
        //sets up the taskeventmenu
        view.addSubview (taskeventmenu);
        taskeventmenu.translatesAutoresizingMaskIntoConstraints = false;
        taskeventmenu.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        taskeventmenu.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        taskeventmenu.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        taskeventmenu.widthAnchor.constraint (equalToConstant: 200/812.0*screenHeight).isActive = true;
        //rounded corner
        taskeventmenu.roundCorners()
        
        //sets up the listButton
        listButton.addTarget(self, action: #selector (popOutList), for: .touchUpInside);
        view.addSubview (listButton);
        listButton.translatesAutoresizingMaskIntoConstraints = false;
        listButton.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        listButton.widthAnchor.constraint (equalTo: listButton.heightAnchor).isActive = true;
        listButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -60/812.0*screenWidth).isActive = true;
        listButton.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        
        //set up the side menus
        let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector (panned(sender:)));
        view.addSubview (taskMenu);
        taskMenu.translatesAutoresizingMaskIntoConstraints = false;
        taskMenu.addGestureRecognizer(panGestureRecognizer1);
        taskMenu.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        taskMenu.widthAnchor.constraint (equalTo: view.widthAnchor, multiplier: 0.75).isActive = true;
        taskMenu.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        taskMenuTrailing = taskMenu.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: 0.75*screenWidth);
        taskMenuTrailing.isActive = true;
        
        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector (panned(sender:)));
        view.addSubview (eventMenu);
        eventMenu.translatesAutoresizingMaskIntoConstraints = false;
        eventMenu.addGestureRecognizer(panGestureRecognizer2);
        eventMenu.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        eventMenu.widthAnchor.constraint (equalTo: view.widthAnchor, multiplier: 0.75).isActive = true;
        eventMenu.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        eventMenuTrailing = eventMenu.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: 0.75*screenWidth);
        eventMenuTrailing.isActive = true;
        
        //set up the black view
        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector (dismissMenu));
        blackView.addGestureRecognizer(tapGestureRecognizer);
        view.addSubview(blackView);
        blackView.translatesAutoresizingMaskIntoConstraints = false;
        view.addContraintsWithFormat("H:|-0-[v0]-0-|", views: blackView);
        view.addContraintsWithFormat("V:|-0-[v0]-0-|", views: blackView);
        
        //set the views in appropriate order
        view.bringSubviewToFront(blackView);
        view.bringSubviewToFront(eventMenu);
        view.bringSubviewToFront(taskMenu);
    }
    
    @objc func back ()
    {
        performSegue (withIdentifier: "returnFromToDoList", sender: self);
    }
    
    @objc func toItem ()
    {
        performSegue (withIdentifier: "toToDoListItem", sender: self);
    }
    
    @objc func popOutList ()
    {
        currentTrailing = (taskeventmenu.selectedFirst ? taskMenuTrailing : eventMenuTrailing);
        currentTrailing.constant = 0;
        self.blackView.layer.opacity = 0;
        self.blackView.isHidden = false;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded();
            self.blackView.layer.opacity = 1;
        }, completion: nil)

    }
    
    @objc func dismissMenu ()
    {
        currentTrailing.constant = 0.75*screenWidth;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded();
            self.blackView.layer.opacity = 0;
        }) { (Finished) in
            self.blackView.isHidden = true;
        }
    }
    
    @objc func panned (sender: UIPanGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            //if panned over half, then dismiss
            if (currentTrailing.constant > 0.75*screenWidth/2)
            {
                currentTrailing.constant = 0.75*screenWidth;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.blackView.layer.opacity = 0;
                }) { (Finished) in
                    self.blackView.isHidden = true;
                }
            }
            else //otherwise, go back
            {
                currentTrailing.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.blackView.layer.opacity = 1;
                }, completion: nil);
            }
        }
        else
        {
            let translation = sender.translation(in: view);
            let newval = currentTrailing.constant + translation.x;
            let newval2 = blackView.layer.opacity - Float(translation.x/(0.75*screenWidth));
            currentTrailing.constant = max(0, newval);
            blackView.layer.opacity = min (1, newval2);
            sender.setTranslation(.zero, in: view);
        }
    }
    
    @IBAction func returnFromItem (sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
