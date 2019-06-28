//
//  SlideOutView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SlideOutView: UIView
{
    
    var events = [Event]();
    
    //the three stackviews and scrollviews + the labels and images
    let stackviewToday = UIStackView();
    let scrollviewToday = UIScrollView();
    let stackviewWeek = UIStackView();
    let scrollviewWeek = UIScrollView();
    let stackviewMonth = UIStackView();
    let scrollviewMonth = UIScrollView();
    
    //the views that can be tapped and things will slide out. This view contrains the arrow and the title
    let todayTapView = UIView();
    let weekTapView = UIView();
    let monthTapView = UIView();
    
    //the labels in the tapViews;
    let todayTitleLabel = UILabel();
    let weekTitleLabel = UILabel();
    let monthTitleLabel = UILabel();
    
    //the images in the tapViews
    let todayImage = UIImageView(image: UIImage(named: "arrow"));
    let weekImage = UIImageView (image: UIImage (named: "arrow"));
    let monthImage = UIImageView (image: UIImage (named: "arrow"));
    
    //arrays that contains those objects to make life easier
    var stackviews = [UIStackView]();
    var scrollviews = [UIScrollView]();
    var tapviews = [UIView]();
    var titlelabels = [UILabel]();
    var images = [UIImageView]();
    
    weak var delegate: MainPageViewController?
    
    //screenwidth and height
    let screenWidth = UIScreen.main.bounds.size.width;
    let screenHeight = UIScreen.main.bounds.size.height;
    
    //the constraints that control the height
    var todayHeight: NSLayoutConstraint!
    var weekHeight: NSLayoutConstraint!
    var monthHeight: NSLayoutConstraint!
    
    //if the sliders are open or not
    var todayOpen: Bool = true;
    var weekOpen: Bool = false;
    var monthOpen: Bool = false;
    
    //maximum heights
    let MAXH: CGFloat = 350.0/812.0*UIScreen.main.bounds.size.height;
    var maxToday: CGFloat = 0;
    var maxWeek: CGFloat = 0;
    var maxMonth: CGFloat = 0;
    
    //formats the date
    let formatter = DateFormatter()
    
    //gets the current user calendar
    let calendar = Calendar.current;
    
    init (events: [Event], delegate: MainPageViewController)
    {
        super.init (frame: CGRect());
        self.events = events;
        self.delegate = delegate;
        formatter.dateFormat = "E, MMM d, yyyy";
        setup();
    }
    override init (frame: CGRect)
    {
        super.init (frame: frame);
    }
    required init? (coder: NSCoder)
    {
        super.init (coder: coder);
    }
    
    private func setup ()
    {
        self.isUserInteractionEnabled = true;
        addToLists();
        setRedundantConstraints()
        setNonRedundantConstraints()
        addData()
    }
    
    private func addToLists ()
    {
        stackviews.append (stackviewToday);
        stackviews.append(stackviewWeek);
        stackviews.append (stackviewMonth);
        scrollviews.append (scrollviewToday);
        scrollviews.append (scrollviewWeek);
        scrollviews.append (scrollviewMonth);
        tapviews.append (todayTapView);
        tapviews.append (weekTapView);
        tapviews.append (monthTapView);
        titlelabels.append (todayTitleLabel);
        titlelabels.append (weekTitleLabel);
        titlelabels.append (monthTitleLabel);
        images.append (todayImage);
        images.append (weekImage);
        images.append (monthImage);
    }
    
    private func setRedundantConstraints ()
    {
        for x in 0..<3
        {
            addSubview (scrollviews [x]);
            scrollviews [x].addSubview (stackviews [x]);
            scrollviews [x].translatesAutoresizingMaskIntoConstraints = false;
            stackviews [x].translatesAutoresizingMaskIntoConstraints = false;
            
            //set constraints for stackview within scrollview
            stackviews [x].centerXAnchor.constraint (equalTo: scrollviews [x].centerXAnchor).isActive = true;
            stackviews [x].topAnchor.constraint (equalTo: scrollviews [x].topAnchor).isActive = true;
            stackviews [x].bottomAnchor.constraint (equalTo: scrollviews [x].bottomAnchor).isActive = true;
            stackviews [x].leadingAnchor.constraint (equalTo: scrollviews [x].leadingAnchor).isActive = true;
            stackviews [x].trailingAnchor.constraint (equalTo: scrollviews [x].trailingAnchor).isActive = true;
            
            stackviews [x].axis = .vertical;
            stackviews [x].alignment = .center;
            
            //set constraints for titleLabel and images relative to tapviews
            addSubview(tapviews [x]);
            tapviews [x].translatesAutoresizingMaskIntoConstraints = false;
            tapviews [x].addSubview (titlelabels [x]);
            tapviews [x].addSubview (images [x]);
            titlelabels [x].translatesAutoresizingMaskIntoConstraints = false;
            images [x].translatesAutoresizingMaskIntoConstraints = false;
            tapviews [x].heightAnchor.constraint (equalToConstant: 15/812.0*screenHeight).isActive = true;
            tapviews [x].centerXAnchor.constraint (equalTo: self.centerXAnchor).isActive = true;
            tapviews [x].widthAnchor.constraint (equalToConstant: screenWidth).isActive = true;
            tapviews [x].isUserInteractionEnabled = true;
            images [x].leadingAnchor.constraint (equalTo: tapviews [x].leadingAnchor, constant: 10/375.0*screenWidth).isActive = true;
            images [x].heightAnchor.constraint (equalTo: tapviews [x].heightAnchor).isActive = true;
            images [x].widthAnchor.constraint (equalToConstant: 15/812.0*screenHeight).isActive = true;
            images [x].topAnchor.constraint (equalTo: tapviews [x].topAnchor).isActive = true;
            titlelabels [x].heightAnchor.constraint (equalTo: tapviews [x].heightAnchor).isActive = true;
            titlelabels [x].leadingAnchor.constraint (equalTo: images [x].trailingAnchor, constant: 10/375.0*screenWidth).isActive = true;
            titlelabels [x].trailingAnchor.constraint (equalTo: tapviews [x].trailingAnchor).isActive = true;
            titlelabels [x].topAnchor.constraint (equalTo: tapviews [x].topAnchor).isActive = true;
            
            //other setups
            titlelabels [x].textAlignment = .left
            titlelabels [x].font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
            titlelabels [x].textColor = .black;
            titlelabels [x].backgroundColor = .clear;
            
            //set constraints for scrollviews relative to tapviews
            scrollviews [x].topAnchor.constraint (equalTo: tapviews [x].bottomAnchor, constant: 7/812.0*screenHeight).isActive = true;
            scrollviews [x].widthAnchor.constraint (equalTo: tapviews [x].widthAnchor).isActive = true;
            scrollviews [x].centerXAnchor.constraint (equalTo: tapviews [x].centerXAnchor).isActive = true;
        }
    }
    
    private func setNonRedundantConstraints ()
    {
        todayTitleLabel.text = "Today";
        weekTitleLabel.text = "This Week";
        monthTitleLabel.text = "This Month";
        
        todayTapView.topAnchor.constraint (equalTo: self.topAnchor).isActive = true;
        weekTapView.topAnchor.constraint (equalTo: scrollviewToday.bottomAnchor, constant: 7/812.0*screenHeight).isActive = true;
        monthTapView.topAnchor.constraint (equalTo: scrollviewWeek.bottomAnchor, constant: 7/812.0*screenHeight).isActive = true;
        
        //initilize HeightConstraints
        todayHeight = scrollviewToday.heightAnchor.constraint(equalToConstant: MAXH);
        weekHeight = scrollviewWeek.heightAnchor.constraint (equalToConstant: 0);
        monthHeight = scrollviewMonth.heightAnchor.constraint(equalToConstant: 0);
        todayHeight.isActive = true;
        weekHeight.isActive = true;
        monthHeight.isActive = true;
        
        //rotate the todayimage 90°
        todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        
        //add gesture recognizers
        todayTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.todayClicked)));
        weekTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (self.weekClicked)));
        monthTapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (self.monthClicked)));
    }
    
    private func addData ()
    {
        let today = Util.next (days: 0) as Date;
        let daylater = Util.next(days: 1) as Date;
        let weeklater = Util.next(days: 7) as Date;
        let monthlater = Util.next(days: 30) as Date;
        
        var currDate = today;
        
        for x in 0..<events.count
        {
            let start = events [x].startTime as Date
            if (today > start)
            {
                continue;
            }
            if (daylater > start)
            {
                let event = EventView (event: events [x], delegate: self.delegate!);
                stackviewToday.addArrangedSubview(event);
                event.translatesAutoresizingMaskIntoConstraints = false;
                event.centerXAnchor.constraint (equalTo: stackviewToday.centerXAnchor).isActive = true;
                event.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
            }
            else if (weeklater > start)
            {
                if (currDate != calendar.startOfDay(for: start))
                {
                    let label = UILabel();
                    label.font = UIFont(name: "SegoeUI-Bold", size: 16/812.0*screenHeight);
                    label.text = formatter.string(from: start);
                    label.backgroundColor = .clear;
                    label.textAlignment = .left;
                    stackviewWeek.addArrangedSubview(label);
                    label.translatesAutoresizingMaskIntoConstraints = false;
                    label.centerXAnchor.constraint (equalTo: stackviewWeek.centerXAnchor).isActive = true;
                    label.widthAnchor.constraint (equalToConstant: screenWidth*0.8).isActive = true;
                    currDate = calendar.startOfDay(for: start)
                }
                let event = EventView (event: events [x], delegate: self.delegate!);
                stackviewWeek.addArrangedSubview(event);
                event.translatesAutoresizingMaskIntoConstraints = false;
                event.centerXAnchor.constraint (equalTo: stackviewToday.centerXAnchor).isActive = true;
                event.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
                
            }
            else if (monthlater > start)
            {
                if (currDate != calendar.startOfDay(for: start))
                {
                    let label = UILabel();
                    label.font = UIFont(name: "SegoeUI-Bold", size: 16/812.0*screenHeight);
                    label.text = formatter.string(from: start);
                    label.backgroundColor = .clear;
                    label.textAlignment = .left;
                    stackviewMonth.addArrangedSubview(label);
                    label.translatesAutoresizingMaskIntoConstraints = false;
                    label.centerXAnchor.constraint (equalTo: stackviewMonth.centerXAnchor).isActive = true;
                    label.widthAnchor.constraint (equalToConstant: screenWidth*0.8).isActive = true;
                    currDate = calendar.startOfDay(for: start);
                }
                let event = EventView (event: events [x], delegate: self.delegate!);
                stackviewMonth.addArrangedSubview(event);
                event.translatesAutoresizingMaskIntoConstraints = false;
                event.centerXAnchor.constraint (equalTo: stackviewMonth.centerXAnchor).isActive = true;
                event.widthAnchor.constraint (equalToConstant: 0.8*screenWidth).isActive = true;
            }
        }
        
        for x in 0..<3
        {
            stackviews [x].layoutIfNeeded();
            if (stackviews [x].frame.height > MAXH)
            {
                scrollviews [x].isScrollEnabled = true;
                scrollviews [x].alwaysBounceVertical = true;
            }
            else
            {
                scrollviews [x].isScrollEnabled = false;
            }
            stackviews [x].isUserInteractionEnabled = true;
            scrollviews [x].isUserInteractionEnabled = true;
        }
        maxToday = (stackviewToday.frame.height > MAXH ? MAXH : stackviewToday.frame.height);
        maxWeek = (stackviewWeek.frame.height > MAXH ? MAXH : stackviewWeek.frame.height);
        maxMonth = (stackviewMonth.frame.height > MAXH ? MAXH : stackviewMonth.frame.height);
        todayHeight.constant = maxToday;
    }
    
    @objc func todayClicked ()
    {

        if (todayOpen)
        {
            todayOpen = false;
            self.todayHeight.constant = 0;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                self.scrollviewToday.center.y -= self.maxToday/2;
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            todayOpen = true;
            todayHeight.constant = maxToday;
            if (weekOpen)
            {
                weekOpen = false;
                weekHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewWeek.center.y -= self.maxWeek/2;
                    self.scrollviewToday.center.y += self.maxToday/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else if (monthOpen)
            {
                monthOpen = false;
                monthHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewMonth.center.y -= self.maxMonth/2;
                    self.scrollviewToday.center.y += self.maxToday/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else
            {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.scrollviewToday.center.y += self.maxToday/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func weekClicked ()
    {
        if (weekOpen)
        {
            weekOpen = false;
            weekHeight.constant = 0;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                self.scrollviewWeek.center.y -= self.maxWeek/2;
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            weekOpen = true;
            weekHeight.constant = maxWeek;
            if (todayOpen)
            {
                todayOpen = false
                todayHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewToday.center.y -= self.maxToday/2;
                    self.scrollviewWeek.center.y += self.maxWeek/2;
                    self.layoutIfNeeded()
                }, completion: nil)

            }
            else if (monthOpen)
            {
                monthOpen = false;
                monthHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewMonth.center.y -= self.maxMonth/2;
                    self.scrollviewWeek.center.y += self.maxWeek/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else
            {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.scrollviewWeek.center.y += self.maxWeek/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    @objc func monthClicked ()
    {
        if (monthOpen)
        {
            monthOpen = false;
            monthHeight.constant = 0;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                self.scrollviewMonth.center.y -= self.maxMonth/2;
                self.layoutIfNeeded()
            }, completion: nil)
        }
        else
        {
            monthOpen = true;
            monthHeight.constant = maxMonth;
            if (todayOpen)
            {
                todayOpen = false;
                todayHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.todayImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewToday.center.y -= self.maxToday/2;
                    self.scrollviewMonth.center.y += self.maxMonth/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else if (weekOpen)
            {
                weekOpen = false;
                weekHeight.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.weekImage.transform = CGAffineTransform(rotationAngle: CGFloat(0));
                    self.scrollviewWeek.center.y -= self.maxWeek/2;
                    self.scrollviewMonth.center.y += self.maxMonth/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
            else
            {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.monthImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
                    self.scrollviewMonth.center.y -= self.maxMonth/2;
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
