//
//  SetUp1ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SetUpViewController: UIViewController, UITextFieldDelegate {
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    //the top label
    lazy var dayGreetingLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.textColor = .white;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        //initial text
        let text = NSMutableAttributedString (string: "Monday Classes\n", attributes: [.font: UIFont(name: "Georgia-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)])
        text.append (NSMutableAttributedString(string: "What's your day like?", attributes: [.font: UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]));
        label.attributedText = text;
        label.numberOfLines = 2;
        return label;
    }()
    
    lazy var almostThereLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.textColor = .white;
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.numberOfLines = 1;
        //initial text
        let text = NSMutableAttributedString(string: "Almost There! ", attributes: [.font: UIFont (name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)])
        text.append (NSMutableAttributedString(string: "What are your classes?", attributes: [.font: UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)]))
        label.attributedText = text;
        return label;
    }()
    
    //the done button
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white;
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.setTitle("Done!", for: .normal);
        button.setTitle("Done!", for: .highlighted);
        button.titleLabel?.font = UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        button.setTitleColor(UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1), for: .normal);
        button.setTitleColor(UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1), for: .highlighted);
        button.addTarget(self, action: #selector (donePressed), for: .touchUpInside);
        return button;
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical;
        view.spacing = 10;
        view.distribution = UIStackView.Distribution.fillEqually
        view.alignment = UIStackView.Alignment.fill
        return view;
    }()
    
    lazy var movingRect: UIView = {
        let view = UIView ()
        view.backgroundColor = UIColor(red: 223/255.0, green: 168/255.0, blue: 144/255.0, alpha: 1.0);
        return view;
    }()
    
    let outerView = UIView ()
    
    var currDay: Int = 0 {
        didSet {
            if (currDay == 1)
            {
                updateToTuesday()
            }
            else if (currDay == 2)
            {
                updateToNextView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        view.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1);
        setup ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver (self, selector: #selector (keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    var textFieldCoordinateY = CGFloat()
    var rectLeading = NSLayoutConstraint()
    var keyboardHeight = CGFloat()
    var topConstraint = NSLayoutConstraint()
    
    private func setup ()
    {
        view.addSubview (outerView);
        outerView.translatesAutoresizingMaskIntoConstraints = false;
        topConstraint = outerView.topAnchor.constraint (equalTo: view.topAnchor);
        topConstraint.isActive = true;
        view.addContraintsWithFormat("H:|[v0]|", views: outerView);
        outerView.heightAnchor.constraint (equalTo: view.heightAnchor).isActive = true;
        
        outerView.addSubview(dayGreetingLabel);
        dayGreetingLabel.translatesAutoresizingMaskIntoConstraints = false;
        dayGreetingLabel.leadingAnchor.constraint(equalTo: outerView.leadingAnchor, constant: 25/375.0*screenWidth).isActive = true;
        dayGreetingLabel.topAnchor.constraint (equalTo: outerView.topAnchor, constant: 78/812.0*screenHeight).isActive = true;
        dayGreetingLabel.widthAnchor.constraint (equalToConstant: 250/375.0*screenWidth).isActive = true;
        dayGreetingLabel.heightAnchor.constraint (equalToConstant: 50/812.0*screenHeight).isActive = true;
        
        outerView.addSubview(doneButton);
        doneButton.translatesAutoresizingMaskIntoConstraints = false;
        doneButton.centerXAnchor.constraint (equalTo: outerView.centerXAnchor).isActive = true;
        doneButton.widthAnchor.constraint(equalToConstant: 307/375.0*screenWidth).isActive = true;
        doneButton.heightAnchor.constraint (equalToConstant: 45/812.0*screenHeight).isActive = true;
        doneButton.topAnchor.constraint (equalTo: outerView.topAnchor, constant: 696/812.0*screenHeight).isActive = true;
        //get rounded corners
        doneButton.layoutIfNeeded()
        doneButton.layer.cornerRadius = doneButton.frame.height/3;
        doneButton.dropShadow()
        
        //add the stack view
        outerView.addSubview(stackView);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.topAnchor.constraint (equalTo: outerView.topAnchor, constant: 180/812.0*screenHeight).isActive = true;
        stackView.leadingAnchor.constraint (equalTo: outerView.leadingAnchor).isActive = true;
        stackView.trailingAnchor.constraint (equalTo: outerView.trailingAnchor).isActive = true;
        stackView.bottomAnchor.constraint (equalTo: outerView.bottomAnchor, constant: -220/812.0*screenHeight).isActive = true;
        
        for x in 1...5
        {
            let periodTextField = PeriodTextField(periodNumber: x, delegate: self)
            stackView.addArrangedSubview(periodTextField);
            periodTextField.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        //add the last bit part
        outerView.addSubview(almostThereLabel);
        almostThereLabel.translatesAutoresizingMaskIntoConstraints = false;
        almostThereLabel.leadingAnchor.constraint (equalTo: doneButton.leadingAnchor).isActive = true;
        almostThereLabel.heightAnchor.constraint (equalToConstant: 25/812.0*screenHeight).isActive = true;
        almostThereLabel.bottomAnchor.constraint (equalTo: doneButton.topAnchor, constant: -22/812.0*screenHeight).isActive = true;
        almostThereLabel.sizeToFit()
        
        outerView.addSubview(movingRect);
        movingRect.translatesAutoresizingMaskIntoConstraints = false;
        rectLeading = movingRect.leadingAnchor.constraint (equalTo: almostThereLabel.leadingAnchor)
        rectLeading.isActive = true;
        movingRect.widthAnchor.constraint(equalToConstant: 358/375.0*screenWidth).isActive = true;
        movingRect.heightAnchor.constraint (equalToConstant: 2/812.0*screenHeight).isActive = true;
        movingRect.topAnchor.constraint (equalTo: almostThereLabel.bottomAnchor).isActive = true;
        movingRect.layoutIfNeeded()
    }
    
    private func updateToTuesday ()
    {
        let animation = CATransition();
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut);
        animation.type = .fade;
        animation.duration = 0.5
        dayGreetingLabel.layer.add(animation, forKey: "fade")
        almostThereLabel.layer.add(animation, forKey: "fade");
        updateToTuesdayHelper()
        
        DispatchQueue.main.async {
            self.rectLeading.constant = -(self.movingRect.frame.width - self.almostThereLabel.frame.width);
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil);
        }
    }
    
    private func updateToTuesdayHelper()
    {
        //change the text and views accordingly when it goes to tuesday classes
        var text = NSMutableAttributedString (string: "Tuesday Classes\n", attributes: [.font: UIFont(name: "Georgia-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)])
        text.append (NSMutableAttributedString(string: "What's your day like?", attributes: [.font: UIFont(name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)]));
        dayGreetingLabel.attributedText = text;
        
        //update the almost there label
        text = NSMutableAttributedString(string: "Last Bit! ", attributes: [.font: UIFont (name: "SitkaBanner", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth)])
        text.append (NSMutableAttributedString(string: "What are your classes?", attributes: [.font: UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth) ?? UIFont.systemFont(ofSize: 20/375.0*screenWidth, weight: .bold)]))
        almostThereLabel.attributedText = text;
        
        almostThereLabel.sizeToFit();
        
        //clean the textfields
        for period in stackView.arrangedSubviews
        {
            let period = period as! PeriodTextField;
            period.record(ADay: true);
            period.clean();
        }
    }
    
    private func updateToNextView ()
    {
        //clean the textFields;
        for period in stackView.arrangedSubviews
        {
            let period = period as! PeriodTextField;
            period.record (ADay: false);
        }
        performSegue(withIdentifier: "toAppEntryView", sender: self);
    }
    
    @objc func donePressed ()
    {
        currDay += 1;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layoutIfNeeded()
        textFieldCoordinateY = textField.superview?.convert(textField.frame.origin, to: view).y ?? 0;
        print (textFieldCoordinateY)
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    @objc func keyboardWillShow (notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardHeight = keyboardSize.height
            let targetY = self.view.frame.height - self.keyboardHeight - 50/812.0*screenHeight;
            let textFieldY = self.topConstraint.constant + self.textFieldCoordinateY
            let difference = targetY - textFieldY;
            let targetOffset = self.topConstraint.constant + difference;
            if (difference < 0)
            {
                DispatchQueue.main.async
                    {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.topConstraint.constant = targetOffset;
                            self.view.layoutIfNeeded();
                        }, completion: nil)
                }
            }
        }
    }
    
    @objc func keyboardWillDisappear (notification: NSNotification)
    {
        DispatchQueue.main.async
            {
                UIView.animate (withDuration: 0.3, animations: {
                    self.topConstraint.constant = 0;
                    self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
}

class PeriodTextField : UIView {
    override init(frame: CGRect) {
        super.init (frame: frame);
    }
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    lazy var textField: UITextField = {
        let field = UITextField();
        field.textColor = .white;
        field.font = UIFont (name: "Georgia-Bold", size: 16/375.0*screenWidth)
        field.tintColor = .white;
        field.adjustsFontSizeToFitWidth = true;
        field.backgroundColor = .clear;
        field.returnKeyType = .done;
        field.borderStyle = .none
        field.layer.masksToBounds = false;
        field.layer.backgroundColor = UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1).cgColor
        field.layer.shadowColor = UIColor.white.cgColor
        field.layer.shadowOffset = CGSize (width: 0.0, height: 2.0)
        field.layer.shadowOpacity = 1.0
        field.layer.shadowRadius = 0.0
        return field;
    }()
    
    lazy var label: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear;
        label.textColor = UIColor(red: 189/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1)
        label.font = UIFont (name: "Georgia", size: 14/375.0*screenWidth);
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    var periodNumber = 0;
    
    init (periodNumber: Int, delegate: UITextFieldDelegate)
    {
        super.init (frame: CGRect());
        textField.delegate = delegate
        self.periodNumber = periodNumber;
        label.text = "Period " + String(periodNumber)
        setup ()
    }
    
    private func setup ()
    {
        addSubview (textField);
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.widthAnchor.constraint (equalToConstant: 325/375.0*screenWidth).isActive = true;
        textField.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        textField.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        textField.heightAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.topAnchor.constraint (equalTo: textField.bottomAnchor).isActive = true;
        label.leadingAnchor.constraint (equalTo: textField.leadingAnchor).isActive = true;
        label.trailingAnchor.constraint (equalTo: textField.trailingAnchor).isActive = true;
        label.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
    }
    
    func record (ADay: Bool)
    {
        UserTimetable.update(ADay: ADay, flipped: false, classnumber: periodNumber, newValue: textField.text ?? "")
    }
    
    func clean ()
    {
        textField.text = "";
    }
}
