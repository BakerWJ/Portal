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
    let timeLabel = UILabel ()
    let classLabel = UILabel ()
    let classTextField = UITextField ();
    var screenHeight = UIScreen.main.bounds.size.height;
    var screenWidth = UIScreen.main.bounds.size.width;
    
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
        formatter.dateFormat = "h:mm a";
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
        if (classnumber != 0) //if this is an editable period
        {
            
            //The stackView is horizontal
            axis = .vertical;
            //set attributes
            classLabel.text = periodName
            classLabel.textAlignment = .center
            classLabel.numberOfLines = 1
            classLabel.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
            classLabel.minimumScaleFactor = 6.0/classLabel.font.pointSize;

            
            //light sky blue: 135-206-250
            //settting the colors and border colors of classLabel
            classLabel.backgroundColor = .white
            
            //adding classLabel to the classLabel view for extra paddin
            classLabelView.addSubview (classLabel);
            classLabelView.addSubview (classTextField);
            
            //setting the attributes of the time Label
            timeLabel.text = formatter.string(from: startTime) + " - " + formatter.string (from: endTime);
            timeLabel.textAlignment = .center
            timeLabel.numberOfLines = 1
            timeLabel.font = UIFont (name: "SegoeUI", size: 14/812.0*screenHeight);
            
            //set background color to white
            timeLabel.backgroundColor = .white
            
            
            //add to stackview
            addArrangedSubview (classLabelView);
            addArrangedSubview (timeLabel);
            
            //set layout constraints for classLabel and timeLabel
            classLabelView.translatesAutoresizingMaskIntoConstraints = false;
            classLabelView.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true
            classLabel.translatesAutoresizingMaskIntoConstraints = false;
            classLabel.topAnchor.constraint(equalTo: classLabelView.topAnchor).isActive = true;
            classLabel.bottomAnchor.constraint (equalTo: classLabelView.bottomAnchor).isActive = true;
            classLabel.leadingAnchor.constraint (equalTo: classLabelView.leadingAnchor).isActive = true;
            classLabel.trailingAnchor.constraint (equalTo: classLabelView.trailingAnchor).isActive = true;
            timeLabel.translatesAutoresizingMaskIntoConstraints = false;
            timeLabel.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true;
            
            //enable user interaction for the labels
            classLabel.isUserInteractionEnabled = true;
            
            //create gesture
            let tapGesture = UITapGestureRecognizer (target: self, action: #selector (self.classLabelTapped));
            tapGesture.numberOfTapsRequired = 1;
            classLabel.addGestureRecognizer(tapGesture)
            
            //set the attributes of classTextField
            classTextField.textAlignment = .center
            classTextField.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
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
        else
        {
            //the stackview is horizontal
            axis = .horizontal

            //set attributes
            classLabel.text = periodName
            classLabel.textAlignment = .center
            classLabel.numberOfLines = 1
            classLabel.font = UIFont (name: "SegoeUI-Bold", size: 16/812.0*screenHeight);
            classLabel.adjustsFontSizeToFitWidth = true;
            classLabel.minimumScaleFactor = 6.0/classLabel.font.pointSize;

            
            //light sky blue: 135-206-250
            //settting the colors and border colors of classLabel
            classLabel.backgroundColor = .clear
            
            //adding classLabel to the classLabel view for extra paddin
            classLabelView.addSubview (classLabel);
            
            //setting the attributes of the time Label
            timeLabel.text = formatter.string(from: startTime) + " - " + formatter.string (from: endTime);
            timeLabel.textAlignment = .left
            timeLabel.numberOfLines = 1
            timeLabel.font = UIFont (name: "SegoeUI", size: 14/812.0*screenHeight);
            
            //set background color to white
            timeLabel.backgroundColor = .clear
            
            
            //add to stackview
            addArrangedSubview (classLabelView);
            addArrangedSubview (timeLabel);
            
            //set layout constraints for classLabel and timeLabel
            classLabelView.translatesAutoresizingMaskIntoConstraints = false;
            classLabelView.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true
            classLabelView.widthAnchor.constraint (equalToConstant: 140/375.0*screenWidth).isActive = true;
            classLabel.translatesAutoresizingMaskIntoConstraints = false;
            classLabel.topAnchor.constraint(equalTo: classLabelView.topAnchor).isActive = true;
            classLabel.bottomAnchor.constraint (equalTo: classLabelView.bottomAnchor).isActive = true;
            classLabel.leadingAnchor.constraint (equalTo: classLabelView.leadingAnchor).isActive = true;
            classLabel.trailingAnchor.constraint (equalTo: classLabelView.trailingAnchor).isActive = true;
            timeLabel.translatesAutoresizingMaskIntoConstraints = false;
            timeLabel.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true;
        }
    }
    
    @objc func classLabelTapped ()
    {
        keyboardDelegate?.didReceiveData (Float (self.frame.minY));
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
        let changeTimetable = UserTimetable ();
        changeTimetable.update(ADay: ADay, flipped: flipped, classnumber: classnumber, newValue: textField.text ?? "");
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
