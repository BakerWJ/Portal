//
//  PeriodClass.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-20.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit
import Foundation

//The PeriodView Class is also a subclass of UIStackView
//Note: UIStackView is not the same as UIView so UIStackView.layer might not work as expected
class PeriodView: UIStackView, UITextFieldDelegate
{
    //MARK: Properties
    var periodName: String = "Empty"
    var startTime: Date = Date()
    var endTime: Date = Date()
    var additionalNotes: String = ""
    var ADay = false;
    var flipped = false;
    var classnumber = 0;
    
    //labels, views and textfields
    let classLabelView = UIView ()
    let containerView = UIView()
    let timeLabel = UILabel ()
    let classLabel = UILabel ()
    let classTextField = UITextField ();
    var screenHeight = UIScreen.main.bounds.size.height;
    var screenWidth = UIScreen.main.bounds.size.width;
    
    lazy var rectangle1: UIView = {
        let view = UIView();
        view.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1);
        return view;
    }()
    lazy var rectangle2: UIView = {
        let view = UIView();
        view.backgroundColor = UIColor(red: 224/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1);
        return view;
    }()
    
    //delegate set to an instance of secondviewcontroller
    weak var keyboardDelegate: KeyboardShiftingDelegate?
    
    //formats dates
    let formatter = DateFormatter ();
    
    //Whether it is glowing or not
    var glowing = false;
    
    //MARK: Constructors
    
    //The constructor takes in four parameters and sets the appropriate values to properties
    init (periodName: String, startTime: Date, endTime: Date, additionalNotes: String, ADay: Bool, flipped: Bool, classnumber: Int, delegate: KeyboardShiftingDelegate)
    {
        super.init (frame: CGRect())
        formatter.dateFormat = "hh:mm";
        self.periodName = periodName;
        self.startTime = startTime;
        self.endTime = endTime;
        self.additionalNotes = additionalNotes;
        self.ADay = ADay;
        self.flipped = flipped;
        self.classnumber = classnumber;
        self.keyboardDelegate = delegate;
        
        //Makes the textfield's delegate self
        classTextField.delegate = self;
        
        //the textfield is initially hidden
        classTextField.isHidden = true;
        
        setup ()
    }
    //override superclass methods
    override init (frame: CGRect)
    {
        super.init (frame: frame)
    }
    required init (coder: NSCoder)
    {
        super.init (coder: coder)
    }
    
    //MARK: Setters
    
    //Gives more options to directly modifying the current Object without creating a new one
    func setPeriodName (periodName: String)
    {
        self.periodName = periodName;
        classLabel.text = periodName;
    }
    func setStartTime (startTime: Date)
    {
        self.startTime = startTime
        timeLabel.text = formatter.string(from: startTime) + " - " + formatter.string(from: endTime)
    }
    func setEndTime (endTime: Date)
    {
        self.endTime = endTime
        timeLabel.text = formatter.string(from: startTime) + " - " + formatter.string(from: endTime)
    }
    
    //setting the opacity to 0.99 and calling the fadeout function starts the animation;
    func glow ()
    {
        classLabel.layer.opacity = 0.99;
        timeLabel.layer.opacity = 0.99;
        fadeout();
    }
    
    //Setting the opacity to 1 stops the animation
    func unglow ()
    {
        classLabel.layer.opacity = 1;
        timeLabel.layer.opacity = 1;
    }
    
    //This lets the labesl fade in and upon completion, it calls the function that lets the labels fade out, which then creates an infinite animation;
    func fadein ()
    {
        UIView.animate (withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations:
        {
            self.classLabel.layer.opacity = 0.99;
            self.timeLabel.layer.opacity = 0.99;
        },
        completion:
        {
            (finished) in
            if (self.classLabel.layer.opacity < 1)
            {
                self.fadeout()
            }
        })
    }
    
    //This is an animation that lets the labels fade out and upon completion, it calls the function that lets the labels fade in
    func fadeout ()
    {
        UIView.animate (withDuration: 0.8, delay: 0, options: .curveEaseInOut, animations:
        {
            self.classLabel.layer.opacity = 0.5;
            self.timeLabel.layer.opacity = 0.5;
        },
        completion:
        {
            (finished) in
            if (self.classLabel.layer.opacity < 1)
            {
                self.fadein()
            }
        })
    }
    
    private func setup ()
    {
        translatesAutoresizingMaskIntoConstraints = false;
        if (classnumber != 0) //if this is an editable period
        {
            
            //The stackView is horizontal
            axis = .horizontal
            //set attributes
            classLabel.text = periodName
            classLabel.textAlignment = .left
            classLabel.numberOfLines = 1
            classLabel.baselineAdjustment = .alignCenters;
            classLabel.font = UIFont (name: "SitkaBanner", size: 20/812.0*screenHeight);
            classLabel.minimumScaleFactor = 6.0/classLabel.font.pointSize;

            //light sky blue: 135-206-250
            //settting the colors and border colors of classLabel
            classLabel.backgroundColor = .clear;
            
            //adding classLabel to the classLabel view for extra paddin
            classLabelView.addSubview (classLabel);
            classLabelView.addSubview (classTextField);
            
            //setting the attributes of the time Label
            timeLabel.text = formatter.string(from: startTime);
            timeLabel.textAlignment = .center
            timeLabel.baselineAdjustment = .alignCenters;
            timeLabel.numberOfLines = 1
            timeLabel.font = UIFont (name: "SimSun", size: 20/812.0*screenHeight);
            
            //set background color to clear
            timeLabel.backgroundColor = .clear
            
            //add to stackview
            addArrangedSubview (timeLabel);
            addArrangedSubview (classLabelView);
            spacing = 0;
            
            //set layout constraints for classLabel and timeLabel
            classLabelView.translatesAutoresizingMaskIntoConstraints = false;
            classLabelView.widthAnchor.constraint(equalToConstant: 173/375.0*screenWidth).isActive = true;
            classLabel.translatesAutoresizingMaskIntoConstraints = false;
            classLabel.topAnchor.constraint(equalTo: classLabelView.topAnchor).isActive = true;
            classLabel.bottomAnchor.constraint (equalTo: classLabelView.bottomAnchor).isActive = true;
            classLabel.leadingAnchor.constraint (equalTo: classLabelView.leadingAnchor).isActive = true;
            classLabel.trailingAnchor.constraint (equalTo: classLabelView.trailingAnchor).isActive = true;
            timeLabel.translatesAutoresizingMaskIntoConstraints = false;
            timeLabel.widthAnchor.constraint (equalToConstant: 130/375.0*screenWidth).isActive = true;
            
            //enable user interaction for the labels
            classLabel.isUserInteractionEnabled = true;
            
            //create gesture
            let tapGesture = UITapGestureRecognizer (target: self, action: #selector (self.classLabelTapped));
            tapGesture.numberOfTapsRequired = 1;
            classLabel.addGestureRecognizer(tapGesture)
            
            //set the attributes of classTextField
            classTextField.textAlignment = .left
            classTextField.font = UIFont (name: "SitkaBanner", size: 20/812.0*screenHeight);
            classTextField.adjustsFontSizeToFitWidth = true;
            classTextField.minimumFontSize = 6;
            classTextField.returnKeyType = .done
            
            //set background color to white
            classTextField.backgroundColor = .white;
            
            //set textfield constraints
            classTextField.translatesAutoresizingMaskIntoConstraints = false;
            classTextField.topAnchor.constraint(equalTo: classLabelView.topAnchor).isActive = true;
            classTextField.bottomAnchor.constraint (equalTo: classLabelView.bottomAnchor).isActive = true;
            classTextField.leadingAnchor.constraint (equalTo: classLabelView.leadingAnchor).isActive = true;
            classTextField.trailingAnchor.constraint (equalTo: classLabelView.trailingAnchor).isActive = true;
        }
        else //if this is not an editable period, such as lunch
        {
            //the stackview is horizontal
            axis = .horizontal;
            alignment = .center;
            spacing = 0;
            
            //setting the attributes of the time Label
            timeLabel.text = formatter.string(from: startTime);
            timeLabel.textAlignment = .center
            timeLabel.baselineAdjustment = .alignCenters;
            timeLabel.numberOfLines = 1
            timeLabel.font = UIFont (name: "SimSun", size: 20/812.0*screenHeight);
            
            //set background color to white
            timeLabel.backgroundColor = .clear
            
            //add to stackview
            addArrangedSubview (timeLabel);
            addArrangedSubview(containerView);
            
            timeLabel.translatesAutoresizingMaskIntoConstraints = false;
            timeLabel.widthAnchor.constraint (equalToConstant: 130/375.0*screenWidth).isActive = true;
            
            containerView.translatesAutoresizingMaskIntoConstraints = false;
            containerView.widthAnchor.constraint (equalToConstant: 173/375.0*screenWidth).isActive = true;
            
            //set attributes
            classLabel.text = periodName.uppercased()
            classLabel.textAlignment = .center
            classLabel.numberOfLines = 1
            classLabel.baselineAdjustment = .alignCenters;
            classLabel.font = UIFont (name: "SitkaBanner", size: 14/812.0*screenHeight);
            classLabel.minimumScaleFactor = 6.0/classLabel.font.pointSize;
            
            containerView.addSubview(rectangle1);
            containerView.addSubview(rectangle2);
            rectangle1.translatesAutoresizingMaskIntoConstraints = false;
            rectangle1.centerYAnchor.constraint (equalTo: containerView.centerYAnchor).isActive = true;
            rectangle1.heightAnchor.constraint (equalToConstant: 2/812.0*screenHeight).isActive = true;
            rectangle1.leadingAnchor.constraint (equalTo: containerView.leadingAnchor).isActive = true;
            rectangle1.widthAnchor.constraint (equalToConstant: 14/375.0*screenWidth).isActive = true;
            
            containerView.addSubview(classLabel)
            classLabel.translatesAutoresizingMaskIntoConstraints = false;
            classLabel.leadingAnchor.constraint (equalTo: rectangle1.trailingAnchor, constant: 8/375.0*screenWidth).isActive = true;
            classLabel.topAnchor.constraint (equalTo: containerView.topAnchor).isActive = true;
            classLabel.bottomAnchor.constraint (equalTo: containerView.bottomAnchor).isActive = true;
            classLabel.layoutIfNeeded();
            classLabel.widthAnchor.constraint (equalToConstant: min(classLabel.frame.width, 129.0)).isActive = true;
            classLabel.adjustsFontSizeToFitWidth = true;
            
            rectangle2.translatesAutoresizingMaskIntoConstraints = false;
            rectangle2.centerYAnchor.constraint (equalTo: containerView.centerYAnchor).isActive = true;
            rectangle2.heightAnchor.constraint (equalToConstant: 2/812.0*screenHeight).isActive = true;
            rectangle2.leadingAnchor.constraint (equalTo: classLabel.trailingAnchor, constant: 8/375.0*screenWidth).isActive = true;
            rectangle2.widthAnchor.constraint (equalToConstant: 14/375.0*screenWidth).isActive = true;
            
            //light sky blue: 135-206-250
            //settting the colors and border colors of classLabel
            classLabel.backgroundColor = .clear
        }
    }
    
    @objc func classLabelTapped ()
    {
        layoutIfNeeded();
        if let point = self.superview?.convert(self.frame.origin, to: UIApplication.shared.keyWindow)
        {
            keyboardDelegate?.didReceiveData(point)
        }
        classLabel.isHidden = true
        classTextField.isHidden = false;
        classTextField.text = classLabel.text;
        classTextField.becomeFirstResponder ()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder ()
        classTextField.isHidden = true;
        classLabel.isHidden = false;
        classLabel.text = classTextField.text;
        UserTimetable.update(ADay: ADay, flipped: flipped, classnumber: classnumber, newValue: textField.text ?? "");
        CoreDataStack.saveContext()
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
