//
//  SecondViewController.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-03.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import CoreData

class ScheduleViewController: UIViewController, KeyboardShiftingDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    //MARK: Properties
    //firebase real time database reference
    let ref = Database.database().reference();
    //firebase firestore reference
    let refstore = Firestore.firestore();
    //an array of schedules for the day.
    var schedules = [Schedule]()
    //an weekly schedule object
    var weeklySchedule: WeeklySchedule?
    
    //constraint for keyboard shifting
    var topConstraint: NSLayoutConstraint!

    var keyboardHeight = 0.0;
    var textFieldCoordinate = CGPoint ();
    
    //collection view cell id
    let cellId = "cellId";
    
    var todaytomorrowviews = [true, false];
    
    var daysDisplayed = [Date]();
    var scheduleDisplayed = [Schedule?]();
    var coloursDisplayed = [UIColor]();
    var ADaysDisplayed = [Bool]()
    var flippedDisplayed = [Bool]();
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    //current user calendar
    let calendar = Calendar.current;
    
    //collectionView that contains the the two views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 32;
        let cv = UICollectionView (frame: .zero, collectionViewLayout: layout);
        cv.backgroundColor = .clear;
        cv.showsVerticalScrollIndicator = false;
        cv.showsHorizontalScrollIndicator = false;
        cv.contentInset = UIEdgeInsets(top: 0, left: 33/375.0*screenWidth, bottom: 0, right: 33/375.0*screenWidth)
        cv.delegate = self;
        cv.dataSource = self;
        return cv;
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel ()
        label.text = "What's Going On Today?     ";
        label.font = UIFont (name: "SitkaBanner", size: 40/375.0*screenWidth);
        label.textColor = .white;
        label.textAlignment = .left;
        label.numberOfLines = 0;
        label.baselineAdjustment = .alignCenters;
        return label;
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white;
        //as the name suggests, fetches schedules from core Data and stores them in the array "schedules"
        fetchSchedules ()
        reloadScheduleData()
        setup ()
        view.backgroundColor = coloursDisplayed [0]
    }
    
    private func setup ()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        //set up the collectionView
        //register the todaytomorrowview as the cell type
        collectionView.register(DailyScheduleCell.self, forCellWithReuseIdentifier: cellId);
        //so the user can pan
        collectionView.isPagingEnabled = true;
        
        //set constraints
        view.addSubview(collectionView);
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        topConstraint = collectionView.topAnchor.constraint (equalTo: view.topAnchor);
        topConstraint.isActive = true;
        collectionView.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        collectionView.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        collectionView.widthAnchor.constraint (equalToConstant: screenWidth).isActive = true;
        
        //setUp the top label
        view.addSubview (topLabel);
        topLabel.translatesAutoresizingMaskIntoConstraints = false;
        topLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 45/812.0*screenHeight).isActive = true;
        topLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        topLabel.heightAnchor.constraint (equalToConstant: 100/812.0*screenHeight).isActive = true;
        topLabel.widthAnchor.constraint (equalToConstant: 276/375.0*screenWidth).isActive = true;
    }
    
    private func reloadScheduleData()
    {
        daysDisplayed = [Date]()
        scheduleDisplayed = [Schedule?]()
        ADaysDisplayed = [Bool]()
        flippedDisplayed = [Bool]();
        coloursDisplayed = [UIColor]()
        for x in 0..<5
        {
            daysDisplayed.append (Util.next(days: x) as Date);
        }
        for day in daysDisplayed
        {
            let weekday = calendar.component(.weekday, from: day);
            var selected: Schedule?
            selected = nil;
            for schedule in schedules
            {
                if (schedule.value == Int32((weeklySchedule?.typeOfDay [weekday - 1])!))
                {
                    selected = schedule;
                    break;
                }
            }
            scheduleDisplayed.append (selected);
            ADaysDisplayed.append ((weeklySchedule?.abDay [weekday - 1])!);
            flippedDisplayed.append (((weeklySchedule?.flipOrNot [weekday - 1])!));
        }
        coloursDisplayed.append (UIColor(red: 183/255.0, green: 139/255.0, blue: 122/255.0, alpha: 1.0));
        coloursDisplayed.append (UIColor(red: 40/255.0, green: 73/255.0, blue: 164/255.0, alpha: 1.0));
        coloursDisplayed.append (UIColor(red: 91/255.0, green: 21/255.0, blue: 42/255.0, alpha: 1.0));
        coloursDisplayed.append (UIColor(red: 42/255.0, green: 138/255.0, blue: 135/255.0, alpha: 1.0));
        coloursDisplayed.append (UIColor(red: 42/255.0, green: 90/255.0, blue: 138/255.0, alpha: 1.0));
    }
    //COLLECTION VIEW DELEGATE METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysDisplayed.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DailyScheduleCell
        cell.reloadData(schedule: scheduleDisplayed [indexPath.item], day: daysDisplayed [indexPath.item], ADay: ADaysDisplayed [indexPath.item], flipped: flippedDisplayed [indexPath.item], delegate: self, reload: true)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: 303/375.0*screenWidth, height: screenHeight);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //add observer of the keyboard showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //When the keyboard hides, then animate back to the normal position
    @objc func keyboardWillHide (notification: NSNotification)
    {
        UIView.animate (withDuration: 0.3, animations: {
            self.topConstraint.constant = 0;
            self.view.layoutIfNeeded()
        }, completion: nil)
        collectionView.isScrollEnabled = true;
    }
    
    //When the keyboard will show, get the keyboard height and animate the textfield to the appropriate position by changing the top constraint of the outerView
    @objc func keyboardWillShow (notification: NSNotification)
    {
        collectionView.isScrollEnabled = false;
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardHeight = Double(keyboardSize.height)
            let periodheight = 60/812.0*self.screenHeight;
            let targetY = CGFloat(self.screenHeight - CGFloat(self.keyboardHeight) - periodheight);
            let textFieldY = textFieldCoordinate.y;
            let difference = targetY - textFieldY;
            if (difference < 0)
            {
                UIView.animate(withDuration: 0.3, animations: {
                    self.topConstraint.constant = difference;
                    self.view.layoutIfNeeded();
                }, completion: nil)
            }
        }
    }
    
    //conform to protocol
    func didReceiveData(_ data: CGPoint)
    {
        textFieldCoordinate = data;
    }
    
    //This method uploads the schedules stored in core data into the "schedule" array.
    func fetchSchedules ()
    {
        //fetch data from core data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (entityName: "Schedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest) as? [Schedule]
            {
                schedules = results;
            }
        }
        catch
        {
            fatalError ("There was an error fetching the list of schedules!")
        }
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult> (entityName: "WeeklySchedule");
        do
        {
            if let results = try CoreDataStack.managedObjectContext.fetch (fetchRequest2) as? [WeeklySchedule]
            {
                weeklySchedule = results [0]
            }
        }
        catch
        {
            fatalError("There was an error fetching the list of weeklySchedules!")
        }
    }
}
