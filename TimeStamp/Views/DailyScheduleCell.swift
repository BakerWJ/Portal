//
//  DailyScheduleCell.swift
//  TimeStamp
//
//  Created by Catherine He on 2019-07-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class DailyScheduleCell: UICollectionViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    override init(frame: CGRect) {
        super.init (frame: frame);
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    lazy var whiteView: UIView = {
        let view = UIView ()
        view.backgroundColor = .white;
        view.layer.cornerRadius = 25/375.0*screenWidth
        view.dropShadow()
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel ()
        label.backgroundColor = .clear
        label.numberOfLines = 0;
        return label
    }()
    
    var titleLabel = UILabel()
    
    lazy var noDataLabel: UILabel = {
        let label = UILabel ()
        label.text = "No Data Available";
        label.numberOfLines = 0;
        label.backgroundColor = .clear;
        label.textAlignment = .center;
        label.baselineAdjustment = .alignCenters;
        label.font = UIFont(name: "SitkaBanner-Bold", size: 15/812.0*screenHeight);
        return label;
    }()
    
    lazy var paragraphLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont (name: "SitkaBanner", size: 20/812.0*screenHeight);
        label.adjustsFontSizeToFitWidth = false;
        label.numberOfLines = 0;
        label.textAlignment = .left;
        label.textColor = .white;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView();
        view.delegate = self;
        view.dataSource = self;
        return view;
    }()
    
    let scrollView = UIScrollView()
    let imageContainerView = UIView()
    let imageView = UIImageView()
    
    var loaded = false; //indicate if the view is loaded
    var schedule: Schedule?
    var day = Date()
    var ADay = false;
    var flipped = false;
    
    let formatter = DateFormatter()
    
    var imageTop = NSLayoutConstraint();
    
    //for events displayed
    var eventsDisplayed = [String]()
    var displayedEventView = UIView()
    var wantedEvents = [Event]()
    
    weak var delegate: KeyboardShiftingDelegate?
    
    func reloadData (schedule: Schedule?, day: Date, ADay: Bool, flipped: Bool, delegate: KeyboardShiftingDelegate, reload: Bool)
    {
        if (!reload)
        {
            return;
        }
        loaded = true;
        self.schedule = schedule;
        self.day = day;
        self.delegate = delegate;
        self.ADay = ADay;
        self.flipped = flipped;
        for each in subviews
        {
            each.removeFromSuperview()
        }
        setUp ();
    }
    
    private func setUp ()
    {
        addSubview(whiteView);
        whiteView.translatesAutoresizingMaskIntoConstraints = false;
        whiteView.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 32/375.0*screenWidth).isActive = true;
        whiteView.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        whiteView.topAnchor.constraint (equalTo: topAnchor, constant: 296/812.0*screenHeight).isActive = true;
        whiteView.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -110/812.0*screenHeight).isActive = true;
        
        addSubview(imageContainerView);
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false;
        imageContainerView.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 32/375.0*screenWidth).isActive = true;
        imageContainerView.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        imageContainerView.heightAnchor.constraint (equalToConstant: 354/812.0*screenHeight).isActive = true;
        imageTop = imageContainerView.topAnchor.constraint (equalTo: whiteView.topAnchor)
        imageTop.isActive = true;
        imageContainerView.clipsToBounds = true;
        imageContainerView.layer.cornerRadius = 25/375.0*screenWidth;
        imageContainerView.layer.masksToBounds = true;
        
        imageContainerView.addSubview(imageView);
        imageContainerView.addConstraintsWithFormat("V:|[v0]|", views: imageView);
        imageContainerView.addConstraintsWithFormat("H:|[v0]|", views: imageView);
        
        bringSubviewToFront(whiteView);
        
        //setup no dataLabel
        whiteView.addSubview(noDataLabel);
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false;
        noDataLabel.centerXAnchor.constraint (equalTo: whiteView.centerXAnchor).isActive = true;
        noDataLabel.centerYAnchor.constraint (equalTo: whiteView.centerYAnchor).isActive = true;
        noDataLabel.heightAnchor.constraint (equalTo: whiteView.heightAnchor).isActive = true;
        noDataLabel.widthAnchor.constraint (equalTo: whiteView.widthAnchor).isActive = true;
        hideNoDataLabel()
        
        whiteView.addSubview(dateLabel);
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        dateLabel.leadingAnchor.constraint (equalTo: whiteView.leadingAnchor, constant: 20/375.0*screenWidth).isActive = true;
        dateLabel.bottomAnchor.constraint (equalTo: whiteView.bottomAnchor, constant: -25/812.0*screenHeight).isActive = true;
        dateLabel.heightAnchor.constraint (equalToConstant: 80/812.0*screenHeight).isActive = true;
        dateLabel.widthAnchor.constraint (equalTo: dateLabel.heightAnchor).isActive = true;
        
        formatter.dateFormat = "dd";
        //add text to date label
        let attributedText = NSMutableAttributedString(string: formatter.string(from: day), attributes: [.font: UIFont(name: "SimSun", size: 60/812.0*screenHeight) ?? UIFont.systemFont(ofSize: 60/812.0*screenHeight)])
        formatter.dateFormat = "EEEE"
        attributedText.append(NSMutableAttributedString(string: " "+formatter.string(from:day).uppercased(), attributes: [.font: UIFont (name: "SitkaBanner", size: 14/812.0*screenHeight) ?? UIFont.systemFont(ofSize: 14/812.0*screenHeight)]));
        dateLabel.attributedText = attributedText;
        
        //make the scrollview and stuff
        //generate scheduleView
        for view in scrollView.subviews
        {
            view.removeFromSuperview();
        }
        
        if let schedule = self.schedule
        {
            whiteView.addSubview(scrollView)
            scrollView.translatesAutoresizingMaskIntoConstraints = false;
            scrollView.leadingAnchor.constraint (equalTo: whiteView.leadingAnchor).isActive = true;
            scrollView.trailingAnchor.constraint (equalTo: whiteView.trailingAnchor).isActive = true;
            scrollView.topAnchor.constraint (equalTo: whiteView.topAnchor, constant: 80/812.0*screenHeight).isActive = true;
            scrollView.heightAnchor.constraint (equalToConstant: 210/812.0*screenHeight).isActive = true;
            
            let scheduleView = ScheduleView(schedule: schedule, ADay: self.ADay, flipped: self.flipped, delegate: self.delegate!)
            scrollView.addSubview(scheduleView)
            scheduleView.translatesAutoresizingMaskIntoConstraints = false;
            scheduleView.centerXAnchor.constraint (equalTo: scrollView.centerXAnchor).isActive = true;
            scheduleView.topAnchor.constraint (equalTo: scrollView.topAnchor).isActive = true;
            scheduleView.bottomAnchor.constraint (equalTo: scrollView.bottomAnchor).isActive = true;
            scheduleView.leadingAnchor.constraint (equalTo: scrollView.leadingAnchor).isActive = true;
            scheduleView.trailingAnchor.constraint (equalTo: scrollView.trailingAnchor).isActive = true;
            scheduleView.spacing = 8;
            scheduleView.backgroundColor = .clear;
            
            scheduleView.layoutIfNeeded();
            if (scheduleView.frame.height < 210/812.0*screenHeight)
            {
                scrollView.isScrollEnabled = false;
            }
            else
            {
                scrollView.isScrollEnabled = true;
                scrollView.alwaysBounceVertical = true;
                scrollView.showsVerticalScrollIndicator = false;
                scrollView.showsHorizontalScrollIndicator = false;
            }
        }
        else
        {
            showNoDataLabel ()
        }
        
        //adds the title label
        titleLabel = UILabel() //create a new label for the title
        titleLabel.baselineAdjustment = .alignCenters;
        titleLabel.textAlignment = .center;
        addSubview (titleLabel);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        addSubview(paragraphLabel);
        paragraphLabel.translatesAutoresizingMaskIntoConstraints = false;
        paragraphLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 198/812.0*screenHeight).isActive = true;
        paragraphLabel.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 36/375.0*screenWidth).isActive = true;
        paragraphLabel.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        paragraphLabel.heightAnchor.constraint (equalToConstant: 140/812.0*screenHeight).isActive = true;
        
        addSubview(pickerView);
        pickerView.translatesAutoresizingMaskIntoConstraints = false;
        pickerView.centerYAnchor.constraint (equalTo: topAnchor, constant: 198/812.0*screenHeight).isActive = true;
        pickerView.leadingAnchor.constraint (equalTo: leadingAnchor, constant: 36/375.0*screenWidth).isActive = true;
        pickerView.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        pickerView.heightAnchor.constraint(equalToConstant: 140/812.0*screenHeight).isActive = true;
        
        //hides the two section indicators
        addEvents()
        addImageAndTitle();
    }
    
    private func addEvents ()
    {
        eventsDisplayed.removeAll()
        guard let events = UserDataSettings.fetchAllEventsFor(day: self.day),
        let settings = UserDataSettings.fetchSettings()
        else {return}
        var acceptableValues = [Int]();
        if (settings.generalNotifications) {acceptableValues.append(1);}
        if (settings.houseNotifications) {acceptableValues.append (2);}
        
        wantedEvents.removeAll()
        for event in events
        {
            if acceptableValues.contains(Int(event.kind))
            {
                wantedEvents.append (event);
            }
        }
        if (wantedEvents.count <= 2)
        {
            displayedEventView = paragraphLabel;
            
            var text = "";
            for x in 0..<wantedEvents.count
            {
                text += wantedEvents[x].titleDetail.trimmingCharacters(in: .whitespacesAndNewlines) + " " + wantedEvents[x].time.trimmingCharacters(in: .whitespacesAndNewlines);
                if (x == wantedEvents.count - 1)
                {
                    text += ".";
                }
                else
                {
                    text += " and ";
                }
            }
            
            paragraphLabel.text = text;
            
            pickerView.isHidden = true;
            paragraphLabel.isHidden = false;
        }
        else
        {
            displayedEventView = pickerView;
            pickerView.isHidden = true;
            pickerView.isHidden = false;
            
            for event in wantedEvents
            {
                eventsDisplayed.append (event.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines) + "\n" + event.time.trimmingCharacters(in: .whitespacesAndNewlines));
            }
            
            pickerView.reloadAllComponents();
            pickerView.layoutIfNeeded();
        }
    }
    
    private func addImageAndTitle ()
    {
        if let schedule = schedule
        {
            if (wantedEvents.count != 0)
            {
                imageView.image = nil;
            }
            else if (schedule.value == 3)
            {
                imageView.image = UIImage(named: "lateStartImage");
            }
            else if (schedule.value == 7)
            {
                imageView.image = UIImage(named: "equitySurveyImage")
            }
            else
            {
                imageView.image = nil;
            }
            titleLabel.text = schedule.kind;
            //titleLabel
            if (schedule.value == 3)
            {
                titleLateStartConfig()
            }
            else
            {
                titleNormalConfig()
            }
        }
        else
        {
            imageView.image = nil;
            titleNormalConfig()
            titleLabel.text = "";
        }
    }
    
    private func titleLateStartConfig()
    {
        titleLabel.font = UIFont(name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        titleLabel.textColor = .white;
        titleLabel.backgroundColor = UIColor.getColor(255, 95, 88);
        titleLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 26/812.0*screenHeight).isActive = true;
        titleLabel.centerXAnchor.constraint (equalTo: whiteView.centerXAnchor).isActive = true;
        titleLabel.widthAnchor.constraint (equalToConstant: 177/375.0*screenWidth).isActive = true;
        titleLabel.heightAnchor.constraint (equalToConstant: 35/812.0*screenHeight).isActive = true;
        titleLabel.clipsToBounds = true;
        titleLabel.layer.masksToBounds = true;
        titleLabel.layoutIfNeeded();
        titleLabel.layer.cornerRadius = titleLabel.frame.height/2;
    }
    
    private func titleNormalConfig ()
    {
        titleLabel.font = UIFont (name: "SitkaBanner", size: 20/375.0*screenWidth);
        titleLabel.textColor = .clear;
        titleLabel.backgroundColor = .clear;
        titleLabel.topAnchor.constraint (equalTo: whiteView.topAnchor, constant: -19/812.0*screenHeight).isActive = true;
        titleLabel.centerXAnchor.constraint (equalTo: whiteView.centerXAnchor).isActive = true;
        titleLabel.heightAnchor.constraint(equalToConstant: 53/812.0*screenHeight).isActive = true;
        titleLabel.widthAnchor.constraint(equalToConstant: 180/375.0*screenWidth).isActive = true;
        titleLabel.clipsToBounds = false;
        titleLabel.layer.masksToBounds = false;
        titleLabel.layoutIfNeeded()
        
        titleLabel.layer.shadowColor = UIColor.black.cgColor;
        titleLabel.layer.shadowOpacity = 0.2;
        titleLabel.layer.masksToBounds = false;
        titleLabel.layer.shadowRadius = 3;
        titleLabel.layer.shadowPath = UIBezierPath(roundedRect: titleLabel.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: titleLabel.frame.height/3, height: titleLabel.frame.height/3)).cgPath
        titleLabel.layer.shadowOffset = CGSize(width: 0.0, height: 1.0);
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.white.cgColor;
        maskLayer.path = UIBezierPath(roundedRect: titleLabel.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: titleLabel.frame.height/3, height: titleLabel.frame.height/3)).cgPath
        titleLabel.layer.insertSublayer(maskLayer, at: 0)

        
        //add a shadow
        let layer2 = CAShapeLayer()
        let shadowOffset = 10/375.0*screenWidth;
        let rectMask = CGRect(x: -shadowOffset, y: titleLabel.frame.height - (shadowOffset*0.25), width: shadowOffset*2 + titleLabel.frame.width, height: shadowOffset)
        layer2.shadowColor = UIColor.black.cgColor
        layer2.shadowPath = UIBezierPath(roundedRect: rectMask, cornerRadius: rectMask.height/2).cgPath
        //shadow radius of 0 makes it less loose
        layer2.shadowRadius = 0;
        //shadow opacity makes it look grey
        layer2.shadowOpacity = 0.2;
        titleLabel.layer.insertSublayer(layer2, at: 0)
        
        //add a subview to show the hidden text
        let textView = UILabel()
        titleLabel.addSubview(textView);
        textView.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.addConstraintsWithFormat("V:|[v0]|", views: textView);
        titleLabel.addConstraintsWithFormat("H:|[v0]|", views: textView);
        textView.font = titleLabel.font;
        textView.text = titleLabel.text;
        textView.adjustsFontSizeToFitWidth = true;
        textView.backgroundColor = .clear;
        textView.textAlignment = .center;
        textView.baselineAdjustment = .alignCenters;
        textView.textColor = .black;
    }
    
    private func showNoDataLabel ()
    {
        noDataLabel.layer.opacity = 1;
    }
    private func hideNoDataLabel ()
    {
        noDataLabel.layer.opacity = 0;
    }
    
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel ()
            pickerLabel?.font = UIFont (name: "SitkaBanner", size: 20/812.0*screenHeight);
            pickerLabel?.textColor = .white;
            pickerLabel?.textAlignment = .center
            pickerLabel?.numberOfLines = 0;
            pickerLabel?.sizeToFit();
            pickerLabel?.lineBreakMode = .byWordWrapping;
        }
        pickerLabel?.text = eventsDisplayed [row];
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45/812.0*screenHeight;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventsDisplayed.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventsDisplayed [row]
    }
}
