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
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    //collectionView that contains the the two views
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal;
        layout.minimumLineSpacing = 0;
        let cv = UICollectionView (frame: .zero, collectionViewLayout: layout);
        cv.backgroundColor = .clear;
        cv.showsVerticalScrollIndicator = false;
        cv.showsHorizontalScrollIndicator = false;
        cv.delegate = self;
        cv.dataSource = self;
        return cv;
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        //as the name suggests, fetches schedules from core Data and stores them in the array "schedules"
        fetchSchedules ()
        setup ()
    }
    
    private func setup ()
    {
        self.automaticallyAdjustsScrollViewInsets = false;
        
        //set up the collectionView
        //register the todaytomorrowview as the cell type
        collectionView.register(TodayTomorrowView.self, forCellWithReuseIdentifier: cellId);
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
        
    }
    
    //COLLECTION VIEW DELEGATE METHODS
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayTomorrowView
        cell.reloadData(schedules: schedules, today: todaytomorrowviews [indexPath.item], weeklySchedule: weeklySchedule, delegate: self, reload: cell.loaded ? false : true);
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize (width: screenWidth, height: screenHeight);
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! TodayTomorrowView
        cell.timer.suspend();
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
        for view in collectionView.subviews
        {
            if let view = view as? TodayTomorrowView
            {
                view.timer.suspend();
            }
        }
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

/*
extension TodayViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TodayToTomorrowAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TomorrowToTodayAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil;
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil;
    }
}
 */

