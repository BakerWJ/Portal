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
    var coloursDisplayedRGB = [(CGFloat, CGFloat, CGFloat)]() //r, g, b;
    var ADaysDisplayed = [Bool]()
    var flippedDisplayed = [Bool]();
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    //current user calendar
    let calendar = Calendar.current;
    
    var defaultIndex : (Date, Bool) = (Date(), false)
    
    //collectionView that contains the the two views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 0;
        let cv = UICollectionView (frame: .zero, collectionViewLayout: layout);
        cv.backgroundColor = .clear;
        cv.showsVerticalScrollIndicator = false;
        cv.showsHorizontalScrollIndicator = false;
        cv.isUserInteractionEnabled = true;
        cv.bounces = false;
        if #available(iOS 11, *)
        {
            cv.contentInsetAdjustmentBehavior = .never;
        }
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 32/375.0*screenWidth)
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
    
    let blockView = UIView ();
    let containerView = UIView ();
    
    lazy var fifthContentWidth = 327/375.0*screenWidth;
    lazy var cellWidth = 335/375.0*screenWidth
    lazy var movingImageConstraintMaxOffset = -151/812.0*screenHeight;
    var lastIndex = 0;
    
    var firstTimeLoad = true;
    
    //MARK: Override
    override func viewDidLoad() {
        view.backgroundColor = .white;
        //as the name suggests, fetches schedules from core Data and stores them in the array "schedules"
        fetchSchedules ()
        reloadScheduleData()
        setup ()
    }
    
    //this function is called when the collection view is loaded, so here we can access the first element and set its constant
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //refresh when the view appears;
        self.refresh()
        //add observer of the keyboard showing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaultIndex.1 = false;
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (defaultIndex.1)
        {
            for x in 0..<daysDisplayed.count
            {
                if (daysDisplayed [x] == defaultIndex.0)
                {
                    collectionView.scrollToItem(at: IndexPath(row: x, section: 0), at: .left, animated: true);
                }
            }
        }
    }
    
    func refresh()
    {
        fetchSchedules();
        reloadScheduleData();
        collectionView.reloadData();
        collectionView.layoutIfNeeded();
        collectionView.isUserInteractionEnabled = true;
        DispatchQueue.main.async {
            let numCellsShifted = abs(self.collectionView.contentOffset.x/(355/375.0*self.screenWidth));
            let roundedCell = Int (round (numCellsShifted + 0.1));
            if let currCell = self.collectionView.cellForItem(at: IndexPath(row: roundedCell, section: 0)) as? DailyScheduleCell
            {
                currCell.imageTop.constant = self.movingImageConstraintMaxOffset
                currCell.displayedEventView.layer.opacity = 1;
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setup ()
    {
        self.setNeedsStatusBarAppearanceUpdate()
        
        view.backgroundColor = UIColor.getColor(coloursDisplayedRGB [0].0, coloursDisplayedRGB [0].1, coloursDisplayedRGB [0].2)
        
        view.addSubview(containerView);
        containerView.translatesAutoresizingMaskIntoConstraints = false;
        view.addConstraintsWithFormat("H:|[v0]|", views: containerView);
        containerView.heightAnchor.constraint (equalTo: view.heightAnchor).isActive = true;
        topConstraint = containerView.topAnchor.constraint (equalTo: view.topAnchor);
        topConstraint.isActive = true;
        containerView.backgroundColor = .clear;
        
        self.automaticallyAdjustsScrollViewInsets = false;
        //set up the collectionView
        //register the todaytomorrowview as the cell type
        collectionView.register(DailyScheduleCell.self, forCellWithReuseIdentifier: cellId);
        
        //set constraints
        containerView.addSubview(collectionView);
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.topAnchor.constraint (equalTo: containerView.topAnchor).isActive = true;
        collectionView.leadingAnchor.constraint (equalTo: containerView.leadingAnchor).isActive = true;
        collectionView.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        collectionView.widthAnchor.constraint (equalToConstant: screenWidth).isActive = true;
        collectionView.reloadData()
        DispatchQueue.main.async {
            if let firstCell = self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? DailyScheduleCell
            {
                firstCell.imageTop.constant = -151/812.0*self.screenHeight;
            }
        }
        
        //setUp the top label
        containerView.addSubview (topLabel);
        topLabel.translatesAutoresizingMaskIntoConstraints = false;
        topLabel.topAnchor.constraint (equalTo: containerView.topAnchor, constant: 45/812.0*screenHeight).isActive = true;
        topLabel.leadingAnchor.constraint (equalTo: containerView.leadingAnchor, constant: 34/375.0*screenWidth).isActive = true;
        topLabel.heightAnchor.constraint (equalToConstant: 100/812.0*screenHeight).isActive = true;
        topLabel.widthAnchor.constraint (equalToConstant: 276/375.0*screenWidth).isActive = true;
        
        //blocks everything and prevents them from interfering with the status bar above when keyboard is shown
        view.addSubview(blockView);
        blockView.translatesAutoresizingMaskIntoConstraints = false;
        blockView.topAnchor.constraint (equalTo: view.topAnchor).isActive = true;
        blockView.leadingAnchor.constraint (equalTo: view.leadingAnchor).isActive = true;
        blockView.trailingAnchor.constraint (equalTo: view.trailingAnchor).isActive = true;
        blockView.heightAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        //hidden when keyboard is not shown
        blockView.layer.opacity = 0;
    }
    
    private func reloadScheduleData()
    {
        daysDisplayed = [Date]()
        scheduleDisplayed = [Schedule?]()
        ADaysDisplayed = [Bool]()
        flippedDisplayed = [Bool]();
        coloursDisplayedRGB = [(CGFloat, CGFloat, CGFloat)]()
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
        coloursDisplayedRGB.append ((183, 139, 122));
        coloursDisplayedRGB.append ((40, 73, 164));
        coloursDisplayedRGB.append((91, 21, 42));
        coloursDisplayedRGB.append ((42, 138, 135));
        coloursDisplayedRGB.append ((42, 90, 138));
    }
    //COLLECTION VIEW DELEGATE METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysDisplayed.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DailyScheduleCell
        cell.reloadData(schedule: scheduleDisplayed [indexPath.item], day: daysDisplayed [indexPath.item], ADay: ADaysDisplayed [indexPath.item], flipped: flippedDisplayed [indexPath.item], delegate: self, reload: true)
        //hides the two section indicators
        cell.layoutIfNeeded()
        cell.pickerView.subviews [1].isHidden = true;
        cell.pickerView.subviews [2].isHidden = true;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: 335/375.0*screenWidth, height: screenHeight);
    }
    
    //customize the paging effect
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //stops the scrollview from sliding (stop the physics)
        targetContentOffset.pointee = scrollView.contentOffset
        if (abs (velocity.x) > 0.5)
        {
            var target = lastIndex + (velocity.x > 0 ? 1 : -1);
            target = min(max (0, target), 4);
            collectionView.scrollToItem(at: IndexPath(row: target, section: 0), at: .left, animated: true)
        }
        else
        {
            let numCellsShifted = abs(scrollView.contentOffset.x/(335/375.0*screenWidth));
            let roundedCell = Int(round(numCellsShifted + 0.1));
            let indexOfMajorCell = min(roundedCell, 4);
            let indexPath = IndexPath (row: indexOfMajorCell, section: 0);
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true);
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let numCellsShifted = abs(scrollView.contentOffset.x/(355/375.0*screenWidth));
        let roundedCell = Int (round (numCellsShifted + 0.1));
        lastIndex = roundedCell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currOffset = scrollView.contentOffset.x;
        let indexLo = Int(currOffset/cellWidth);
        let progress = (currOffset - CGFloat(indexLo)*cellWidth)/(indexLo == 3 ? fifthContentWidth : cellWidth)
        let colour1 = coloursDisplayedRGB [indexLo];
        let colour2 = coloursDisplayedRGB [indexLo + 1];
        view.backgroundColor = UIColor(red: (colour1.0 + (colour2.0 - colour1.0)*progress)/255.0, green: (colour1.1 + (colour2.1 - colour1.1)*progress)/255.0, blue: (colour1.2 + (colour2.2 - colour1.2)*progress)/255.0, alpha: 1);
        blockView.backgroundColor = view.backgroundColor
        
        guard let thisCell = collectionView.cellForItem(at: IndexPath(row: indexLo, section: 0)) as? DailyScheduleCell,
        let nextCell = collectionView.cellForItem(at: IndexPath(row: indexLo + 1, section: 0)) as? DailyScheduleCell
        else {return;}
        
        nextCell.imageTop.constant = progress*(movingImageConstraintMaxOffset);
        nextCell.displayedEventView.layer.opacity = Float(progress*1.0);
        thisCell.imageTop.constant = movingImageConstraintMaxOffset - nextCell.imageTop.constant;
        thisCell.displayedEventView.layer.opacity = Float(1.0 - progress*1.0);
    }
    
    //When the keyboard hides, then animate back to the normal position
    @objc func keyboardWillHide (notification: NSNotification)
    {
        DispatchQueue.main.async {
            UIView.animate (withDuration: 0.3, animations: {
                self.topConstraint.constant = 0;
                self.view.layoutIfNeeded()
            }) { (Finished) in
                self.collectionView.isScrollEnabled = true;
                self.blockView.layer.opacity = 0;
            }
        }
    }
    
    //When the keyboard will show, get the keyboard height and animate the textfield to the appropriate position by changing the top constraint of the outerView
    @objc func keyboardWillShow (notification: NSNotification)
    {
        collectionView.isScrollEnabled = false;
        self.blockView.layer.opacity = 1;
        if let keyboardSize = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            keyboardHeight = Double(keyboardSize.height)
            let periodheight = 30/812.0*self.screenHeight;
            let targetY = CGFloat(self.screenHeight - CGFloat(self.keyboardHeight) - periodheight);
            let textFieldY = textFieldCoordinate.y;
            let difference = targetY - textFieldY;
            if (difference < 0)
            {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.topConstraint.constant = difference;
                        self.view.layoutIfNeeded();
                    }, completion: nil)
                }
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
