//
//  TodayViewController.swift
//  Portal
//
//  Created by Jacky He on 2019-08-26.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    lazy var scheme = "com.googleusercontent.apps.367766824243-2lift2fsdd0d6nmvi4uic7grt3e60r1l://";
    
    lazy var nextPeriodView : NextPeriodView = {
        let view = NextPeriodView()
        view.layer.borderColor = UIColor.clear.cgColor;
        return view;
    }()
    
    lazy var blueBubble: UIView = {
        let layer = UIView()
        layer.layer.cornerRadius = 15/375.0*screenWidth
        layer.backgroundColor = UIColor(red: 0.46, green: 0.75, blue: 0.85, alpha: 1)
        layer.clipsToBounds = true;
        return layer
    }()
    
    lazy var distortion: UIView = {
        let layer = UIView()
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: -2.007128639793479)
        layer.transform = transform
        layer.layer.cornerRadius = 0
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.18)
        return layer
    }()
    
    lazy var topArticleLabel: UILabel = {
        let label = UILabel();
        label.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        label.numberOfLines = 1
        label.textAlignment = .left;
        label.baselineAdjustment = .alignCenters;
        label.backgroundColor = .clear;
        label.text = "Top Article";
        label.adjustsFontSizeToFitWidth = true;
        return label;
    }()
    
    lazy var readMoreLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 14/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.layer.borderColor = UIColor.white.cgColor;
        textLayer.layer.borderWidth = 2/375.0*screenWidth;
        textLayer.textAlignment = .center;
        textLayer.baselineAdjustment = .alignCenters;
        textLayer.minimumScaleFactor = 0.5
        textLayer.text = "READ MORE"
        return textLayer
    }()
    
    lazy var genreLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner", size: 17/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 1
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.7
        return textLayer
    }()
    
    lazy var titleLabel: UILabel = {
        let textLayer = UILabel()
        textLayer.font = UIFont(name: "SitkaBanner-Bold", size: 20/375 * screenWidth)
        textLayer.textColor = UIColor.white
        textLayer.translatesAutoresizingMaskIntoConstraints = false
        textLayer.numberOfLines = 2
        textLayer.adjustsFontSizeToFitWidth = true
        textLayer.minimumScaleFactor = 0.5
        return textLayer
    }()
    
    lazy var eventsLabel : UILabel = {
        let label = UILabel ()
        return label;
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical;
        view.alignment = .center;
        view.distribution = UIStackView.Distribution.fill
        view.spacing = 10/812.0*screenHeight;
        return view;
    }()
    
    lazy var todayLabel : UILabel = {
        let label = UILabel ()
        label.text = "What's going on today?";
        label.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        label.textColor = .black;
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = true;
        return label;
    }()
    
    lazy var typeDayLabel : UILabel = {
        let label = UILabel ()
        label.textColor = .black;
        label.font = UIFont (name: "SitkaBanner-Bold", size: 20/375.0*screenWidth);
        label.textAlignment = .left;
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = true;
        return label;
    }()
    
    var featuredArticle : Article? {
        didSet {
            genreLabel.text = featuredArticle?.genre.uppercased();
            titleLabel.text = featuredArticle?.title;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        // Do any additional setup after loading the view.
    }
    
    private func setup ()
    {
        //add tap gesture recognizer
        
        view.addSubview (typeDayLabel);
        typeDayLabel.translatesAutoresizingMaskIntoConstraints = false;
        typeDayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 18/812.0*screenHeight).isActive = true;
        typeDayLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        typeDayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30/375.0*screenWidth).isActive = true;
        typeDayLabel.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        
        view.addSubview(nextPeriodView);
        nextPeriodView.translatesAutoresizingMaskIntoConstraints = false;
        nextPeriodView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        nextPeriodView.topAnchor.constraint(equalTo: typeDayLabel.bottomAnchor, constant: 10/812.0*screenHeight).isActive = true;
        nextPeriodView.widthAnchor.constraint(equalToConstant: 334/375.0*screenWidth).isActive = true;
        nextPeriodView.heightAnchor.constraint(equalToConstant: 54/812.0*screenHeight).isActive = true;
        nextPeriodView.layoutIfNeeded()
        nextPeriodView.layer.cornerRadius = nextPeriodView.frame.height/2;
        nextPeriodView.refresh()
        let tg1 = UITapGestureRecognizer(target: self, action: #selector(launchMain));
        nextPeriodView.addGestureRecognizer(tg1);
        
        view.addSubview(topArticleLabel);
        topArticleLabel.translatesAutoresizingMaskIntoConstraints = false;
        topArticleLabel.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        topArticleLabel.topAnchor.constraint (equalTo: nextPeriodView.bottomAnchor, constant: 50/812.0*screenHeight).isActive = true;
        topArticleLabel.widthAnchor.constraint(equalToConstant: 100/375.0*screenWidth).isActive = true;
        topArticleLabel.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        
        view.addSubview(blueBubble)
        blueBubble.translatesAutoresizingMaskIntoConstraints = false;
        blueBubble.widthAnchor.constraint(equalToConstant: 300/375.0*screenWidth).isActive = true
        blueBubble.heightAnchor.constraint(equalToConstant: 144/812.0*screenHeight).isActive = true
        blueBubble.topAnchor.constraint(equalTo: topArticleLabel.bottomAnchor, constant: 10/812.0*screenHeight).isActive = true;
        blueBubble.leadingAnchor.constraint (equalTo: topArticleLabel.leadingAnchor).isActive = true;
        let tg2 = UITapGestureRecognizer(target: self, action: #selector(launchFeatured));
        blueBubble.addGestureRecognizer(tg2);
        
        blueBubble.addSubview (distortion);
        distortion.translatesAutoresizingMaskIntoConstraints = false;
        distortion.topAnchor.constraint (equalTo: blueBubble.topAnchor, constant: 53.53/812.0*screenHeight).isActive = true;
        distortion.leadingAnchor.constraint(equalTo: blueBubble.leadingAnchor, constant: 230/375.0*screenWidth).isActive = true;
        distortion.widthAnchor.constraint(equalToConstant: 100/375.0*screenWidth).isActive = true;
        distortion.heightAnchor.constraint(equalTo: distortion.widthAnchor).isActive = true;
        
        blueBubble.addSubview(readMoreLabel)
        readMoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        readMoreLabel.widthAnchor.constraint(equalToConstant: 121/375.0*screenWidth).isActive = true
        readMoreLabel.heightAnchor.constraint(equalToConstant: 27/375.0*screenWidth).isActive = true
        readMoreLabel.topAnchor.constraint(equalTo: blueBubble.topAnchor, constant: 98/812.0*screenHeight).isActive = true
        readMoreLabel.leadingAnchor.constraint (equalTo: blueBubble.leadingAnchor, constant: 16/375.0*screenWidth).isActive = true;
        
        //set the corner radius
        readMoreLabel.layoutIfNeeded();
        readMoreLabel.layer.cornerRadius = readMoreLabel.frame.height/2;
        
        blueBubble.addSubview(genreLabel);
        genreLabel.translatesAutoresizingMaskIntoConstraints = false;
        genreLabel.leadingAnchor.constraint (equalTo: blueBubble.leadingAnchor, constant: 16/375.0*screenWidth).isActive = true;
        genreLabel.topAnchor.constraint (equalTo: blueBubble.topAnchor, constant: 27/812.0*screenHeight).isActive = true;
        genreLabel.trailingAnchor.constraint(equalTo: blueBubble.trailingAnchor, constant: 16/375.0*screenWidth).isActive = true;
        genreLabel.heightAnchor.constraint (equalToConstant: 22/812.0*screenHeight).isActive = true;
        
        blueBubble.addSubview(titleLabel);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.leadingAnchor.constraint (equalTo: genreLabel.leadingAnchor).isActive = true;
        titleLabel.trailingAnchor.constraint (equalTo: genreLabel.trailingAnchor).isActive = true;
        titleLabel.topAnchor.constraint (equalTo: blueBubble.topAnchor, constant: 48/812.0*screenHeight).isActive = true;
        titleLabel.heightAnchor.constraint (equalToConstant: 38/812.0*screenHeight).isActive = true;
        
        view.addSubview(todayLabel);
        todayLabel.translatesAutoresizingMaskIntoConstraints = false;
        todayLabel.leadingAnchor.constraint (equalTo: blueBubble.leadingAnchor).isActive = true;
        todayLabel.trailingAnchor.constraint (equalTo: blueBubble.trailingAnchor).isActive = true;
        todayLabel.topAnchor.constraint (equalTo: blueBubble.bottomAnchor, constant: 50/812.0*screenHeight).isActive = true;
        
        view.addSubview(stackView);
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.leadingAnchor.constraint(equalTo: blueBubble.leadingAnchor).isActive = true;
        stackView.trailingAnchor.constraint (equalTo: blueBubble.trailingAnchor).isActive = true;
        stackView.topAnchor.constraint (equalTo: todayLabel.bottomAnchor, constant: 10/812.0*screenHeight).isActive = true;
        let tg3 = UITapGestureRecognizer(target: self, action: #selector(launchToday));
        stackView.addGestureRecognizer(tg3);
        self.refresh ()
    }
    
    
    private func refresh ()
    {
        refreshTypeDay()
        nextPeriodView.refresh()
        refreshArticle ()
        refreshEvents ()
    }
    
    private func refreshTypeDay ()
    {
        guard let schedules = UserDataSettings.fetchAllSchedules(),
            let weekly = UserDataSettings.fetchWeeklySchedule()
            else {return}
        let weekday = Calendar.current.component(.weekday, from: Date());
        let temp = weekly.typeOfDay[weekday - 1];
        for each in schedules
        {
            if (each.value == temp)
            {
                typeDayLabel.text = format(str: each.kind);
                return;
            }
        }
    }
    
    private func format (str : String) -> String
    {
        var res = ""
        let arr = str.split(separator: " ");
        for each in arr
        {
            res += each.prefix(1).uppercased() + each.lowercased().dropFirst();
            res += " ";
        }
        return res;
    }
    
    private func refreshArticle ()
    {
        featuredArticle = nil;
        if let articles = UserDataSettings.fetchAllArticles()
        {
            var res : (Int, Article?) = (0, nil);
            for each in articles
            {
                if (each.likes > res.0)
                {
                    res = (Int(each.likes), each);
                }
            }
            featuredArticle = res.1;
        }
    }
    
    private func refreshEvents ()
    {
        for each in stackView.subviews
        {
            each.removeFromSuperview()
        }
        guard let events = UserDataSettings.fetchAllEventsFor(day: Util.next(days: 0) as Date) else {return}
        for each in events
        {
            let label = UILabel()
            stackView.addArrangedSubview(label);
            label.translatesAutoresizingMaskIntoConstraints = false;
            label.textColor = .black;
            label.font = UIFont (name: "SitkaBanner", size: 15/375.0*screenWidth);
            label.textAlignment = .center;
            label.numberOfLines = 0;
            label.text = each.titleDetail.trimmingCharacters(in: .whitespacesAndNewlines) + "\n" + each.time.trimmingCharacters(in: .whitespacesAndNewlines);
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.refresh()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 1000/812.0*screenHeight) : maxSize
    }
    
    //goes to the schedule for today
    @objc func launchToday ()
    {
        let url: URL = URL(string: scheme + "today")!
        extensionContext?.open(url, completionHandler: nil);
    }
    
    //goes to the article view controller of the featured page
    @objc func launchFeatured()
    {
        let url: URL = URL(string: scheme + "featured")!
        extensionContext?.open(url, completionHandler: nil);
    }
    
    //goes to the main page
    @objc func launchMain()
    {
        let url: URL = URL(string: scheme + "main")!
        extensionContext?.open(url, completionHandler: nil);
    }
    
}
