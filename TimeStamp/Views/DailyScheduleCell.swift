//
//  DailyScheduleCell.swift
//  TimeStamp
//
//  Created by Catherine He on 2019-07-24.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class DailyScheduleCell: UICollectionViewCell {
    
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
    
    let scrollView = UIScrollView()
    
    var loaded = false; //indicate if the view is loaded
    var schedule: Schedule?
    var day = Date()
    var ADay = false;
    var flipped = false;
    
    let formatter = DateFormatter()
    
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
        whiteView.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        whiteView.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        whiteView.topAnchor.constraint (equalTo: topAnchor, constant: 296/812.0*screenHeight).isActive = true;
        whiteView.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -110/812.0*screenHeight).isActive = true;
        
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
    }
    private func showNoDataLabel ()
    {
        noDataLabel.layer.opacity = 1;
    }
    private func hideNoDataLabel ()
    {
        noDataLabel.layer.opacity = 0;
    }
}
