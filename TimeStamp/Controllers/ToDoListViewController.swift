//
//  ToDoListViewController.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-22.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    //initializes the addbutton
    let addButton: UIButton = {
        let button = UIButton ();
        button.setBackgroundImage (UIImage (named: "addItem"), for: .normal);
        return button
    }()
    
    //initializes the cancel button
    let cancelButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    //initializes the list button
    let listButton: UIButton = {
        let button = UIButton();
        button.setBackgroundImage(UIImage (named: "listIcon"), for: .normal);
        button.backgroundColor = .clear;
        return button;
    }()
    
    //initialize the black view that comes up when the side menus are shown
    let blackView: UIView = {
        let view = UIView ();
        view.backgroundColor = UIColor (white: 0, alpha: 0.5);
        view.isHidden = true;
        return view;
    }()
    
    //initilize the table view for tasks
    let tableView: UITableView = {
        let view = UITableView ();
        view.translatesAutoresizingMaskIntoConstraints = false;
        return view;
    }()
    
    //initializes the event side menu
    let eventMenu = EventMenuView();
    var eventMenuTrailing = NSLayoutConstraint()

    //initializes the task side menu
    let taskMenu = TaskMenuView();
    var taskMenuTrailing = NSLayoutConstraint()
    
    //the current constraint
    var currentTrailing = NSLayoutConstraint()
    
    let taskeventmenu = TaskEventMenu();
    
    let screenWidth = UIScreen.main.bounds.width;
    let screenHeight = UIScreen.main.bounds.height;
    
    //random cell id
    //table view properties
    let cellId = "cellId"
    var tasksData = [[ToDo_Task]]()
    var isExpanded = [true, true, true, true];
    let headerNames = ["Today", "Upcoming", "No Due Date", "Completed"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0);
        setConstraints ()
        // Do any additional setup after loading the view.
    }
    
    private func setConstraints ()
    {
        addButton.addTarget(self, action: #selector (toItem), for: .touchUpInside);
        view.addSubview(addButton);
        addButton.translatesAutoresizingMaskIntoConstraints = false;
        addButton.heightAnchor.constraint (equalToConstant: 80/812.0*screenHeight).isActive = true;
        addButton.widthAnchor.constraint (equalToConstant: 80/812.0*screenHeight).isActive = true;
        addButton.bottomAnchor.constraint (equalTo: view.bottomAnchor, constant: -50/812.0*screenHeight).isActive = true;
        addButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 40/375.0*screenWidth).isActive = true;
        addButton.layoutIfNeeded();
        //creates a shadow
        let shadowLayer = CAShapeLayer();
        shadowLayer.path = UIBezierPath(roundedRect: addButton.bounds, cornerRadius: addButton.frame.height/2).cgPath;
        shadowLayer.borderColor = UIColor.black.cgColor;
        shadowLayer.borderWidth = 1;
        shadowLayer.fillColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1).cgColor;
        shadowLayer.shadowPath = shadowLayer.path;
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0);
        shadowLayer.shadowOpacity = 0.7;
        shadowLayer.shadowRadius = 4;
        //adds the layer;
        addButton.layer.insertSublayer(shadowLayer, at: 0);
        
        //sets up the cancel button
        cancelButton.addTarget(self, action: #selector (back), for: .touchUpInside);
        view.addSubview (cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.heightAnchor.constraint (equalToConstant: 20/812.0*screenHeight).isActive = true;
        cancelButton.widthAnchor.constraint (equalTo: cancelButton.heightAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 60/812.0*screenHeight).isActive = true;
        cancelButton.leadingAnchor.constraint (equalTo: view.leadingAnchor, constant: 30/375.0*screenWidth).isActive = true;
        
        //sets up the taskeventmenu
        view.addSubview (taskeventmenu);
        taskeventmenu.translatesAutoresizingMaskIntoConstraints = false;
        taskeventmenu.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        taskeventmenu.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        taskeventmenu.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        taskeventmenu.widthAnchor.constraint (equalToConstant: 200/812.0*screenHeight).isActive = true;
        //rounded corner
        taskeventmenu.roundCorners()
        
        //sets up the listButton
        listButton.addTarget(self, action: #selector (popOutList), for: .touchUpInside);
        view.addSubview (listButton);
        listButton.translatesAutoresizingMaskIntoConstraints = false;
        listButton.heightAnchor.constraint (equalToConstant: 40/812.0*screenHeight).isActive = true;
        listButton.widthAnchor.constraint (equalTo: listButton.heightAnchor).isActive = true;
        listButton.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: -60/812.0*screenWidth).isActive = true;
        listButton.centerYAnchor.constraint (equalTo: cancelButton.centerYAnchor).isActive = true;
        
        //set up the side menus
        let panGestureRecognizer1 = UIPanGestureRecognizer(target: self, action: #selector (panned(sender:)));
        view.addSubview (taskMenu);
        taskMenu.translatesAutoresizingMaskIntoConstraints = false;
        taskMenu.addGestureRecognizer(panGestureRecognizer1);
        taskMenu.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        taskMenu.widthAnchor.constraint (equalTo: view.widthAnchor, multiplier: 0.75).isActive = true;
        taskMenu.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        taskMenuTrailing = taskMenu.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: 0.75*screenWidth);
        taskMenuTrailing.isActive = true;
        
        let panGestureRecognizer2 = UIPanGestureRecognizer(target: self, action: #selector (panned(sender:)));
        view.addSubview (eventMenu);
        eventMenu.translatesAutoresizingMaskIntoConstraints = false;
        eventMenu.addGestureRecognizer(panGestureRecognizer2);
        eventMenu.heightAnchor.constraint (equalToConstant: screenHeight).isActive = true;
        eventMenu.widthAnchor.constraint (equalTo: view.widthAnchor, multiplier: 0.75).isActive = true;
        eventMenu.centerYAnchor.constraint (equalTo: view.centerYAnchor).isActive = true;
        eventMenuTrailing = eventMenu.trailingAnchor.constraint (equalTo: view.trailingAnchor, constant: 0.75*screenWidth);
        eventMenuTrailing.isActive = true;
        
        //set up the black view
        let tapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector (dismissMenu));
        blackView.addGestureRecognizer(tapGestureRecognizer);
        view.addSubview(blackView);
        blackView.translatesAutoresizingMaskIntoConstraints = false;
        view.addContraintsWithFormat("H:|[v0]|", views: blackView);
        view.addContraintsWithFormat("V:|[v0]|", views: blackView);
        
        //set up the table View
        view.addSubview(tableView);
    
        tableView.topAnchor.constraint (equalTo: taskeventmenu.bottomAnchor, constant: 10/812.0*screenHeight).isActive = true;
        tableView.bottomAnchor.constraint (equalTo: view.bottomAnchor).isActive = true;
        view.addContraintsWithFormat("H:|[v0]|", views: tableView);
        tableView.register(TaskView.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = .clear
        //remove unnecessary lines
        tableView.tableFooterView = UIView();
        
        //set the views in appropriate order
        view.bringSubviewToFront(addButton);
        view.bringSubviewToFront(blackView);
        view.bringSubviewToFront(eventMenu);
        view.bringSubviewToFront(taskMenu);
        
        createSomeTasks() //delete later
        setupTableView ()
    }
    
    //MARK: TableView
    func setupTableView ()
    {
        var noDueDate = [ToDo_Task]();
        var yesDueDate = [ToDo_Task]();
        var completed = [ToDo_Task]();
        var today = [ToDo_Task]();
        var upcoming = [ToDo_Task]();
        
        if let l = UserDataSettings.fetchAllTasks()
        {
            for task in l
            {
                if task.dueDate == nil
                {
                    if (task.completed)
                    {
                        completed.append (task);
                    }
                    else
                    {
                        noDueDate.append (task);
                    }
                }
                else
                {
                    yesDueDate.append (task);
                }
            }
        }
        yesDueDate.sort(by: { (a, b) -> Bool in
            return !(a.dueDate! as Date > b.dueDate! as Date || (a.dueDate! as Date == b.dueDate! as Date && a.title.compare (b.title) == .orderedDescending));
        })
        noDueDate.sort { (a, b) -> Bool in
            a.title.compare(b.title) == .orderedAscending;
        }
        let date = Util.next(days: 0) as Date;
        let tomodate = Util.next(days: 1) as Date;
        for task in yesDueDate
        {
            if (task.completed)
            {
                completed.append (task);
                continue;
            }
            if (date > task.dueDate! as Date)
            {
                continue;
            }
            if (tomodate > task.dueDate! as Date)
            {
                today.append (task);
                continue;
            }
            upcoming.append (task);
        }
        tasksData.append (today);
        tasksData.append (upcoming);
        tasksData.append (noDueDate);
        tasksData.append (completed);
        tableView.reloadData()
    }
    
    func createSomeTasks ()
    {
        guard let entity = NSEntityDescription.entity (forEntityName: "ToDo_TaskTag", in: CoreDataStack.managedObjectContext) else
        {
            fatalError ("Could not find entity description!")
        }
        let newTag = ToDo_TaskTag(entity: entity, insertInto: CoreDataStack.managedObjectContext)
        newTag.colour = .black;
        newTag.name = "Hello";
        let newTag2 = ToDo_TaskTag (entity: entity, insertInto: CoreDataStack.managedObjectContext);
        newTag2.colour = .red;
        newTag2.name = "Jason";
        UserDataSettings.addTask(dueDate: Date(), completed: false, title: "Hello", detail: "Great", tag: newTag)
        UserDataSettings.addTask(dueDate: Util.next(days: 2) as Date, completed: false, title: "Do Homework", detail: "Better do do", tag: newTag2)
        CoreDataStack.saveContext()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tasksData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isExpanded [section])
        {
            return 0;
        }
        return tasksData [section].count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskView;
        cell.task = tasksData [indexPath.section][indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //hides the section header if there is now rows in the section and if the section is expanded
        if (tableView.numberOfRows(inSection: section) == 0 && isExpanded [section])
        {
            return CGFloat.leastNormalMagnitude;
        }
        return 30/812.0*screenHeight;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        //this is the view for the section headers
        button.backgroundColor = UIColor (red: 219/255.0, green: 103/255.0, blue: 103/255.0, alpha: 1);
        button.setTitle(headerNames [section], for: .normal);
        button.setTitle(headerNames [section], for: .highlighted);
        button.setTitleColor(.white, for: .normal);
        button.setTitleColor(.white, for: .highlighted);
        button.titleLabel?.textAlignment = .center;
        button.titleLabel?.font = UIFont (name: "SegoeUI-Bold", size: 16/812.0*screenHeight);
        button.addTarget(self, action: #selector(sectionHeaderPressed), for: .touchUpInside);
        //set the button's tag to its corresponding section number for reference in sectionHeadeerPressed(button:_);
        button.tag = section;
        return button;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .none
        {
            tasksData [indexPath.section].remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40/812.0*screenHeight;
    }
    
    @objc func sectionHeaderPressed (button: UIButton)
    {
        let section = button.tag;
        var indexPaths = [IndexPath]();
        for row in tasksData [section].indices
        {
            indexPaths.append (IndexPath(row: row, section: section));
        }
        //if this section is expanded, set it to it's not expanded and vice versa
        isExpanded [section] = !isExpanded [section];
        
        //tableView.beginUpdates () and .endUpdates () are for updating a bunch of views so that all the animations can run together instead of one after another
        tableView.beginUpdates()
        if (isExpanded [section]) //if now this is expanded, then add the rows
        {
            tableView.insertRows(at: indexPaths, with: .fade);
        }
        else //otherwise delete them
        {
            tableView.deleteRows(at: indexPaths, with: .fade);
        }
        tableView.endUpdates()
    }
    
    func updateCompletionStatus (sender: TaskView) //delegate method
    {
        let indexPath = tableView.indexPath(for: sender)!;
        tableView.beginUpdates();
        if ((sender.task?.completed)!)
        {
            //move it to the completion section
            let temp = tasksData [indexPath.section].remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
            tasksData [3].append (temp);
            sender.leading.constant = 0;
            sender.wrapperView.layer.opacity = 1;
            if (isExpanded [3])
            {
                tableView.insertRows(at: [IndexPath(row: tasksData [3].count - 1, section: 3)], with: .fade);
            }
        }
        else
        {
            let temp = tasksData [indexPath.section].remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .fade);
            sender.leading.constant = 0;
            sender.wrapperView.layer.opacity = 1;
            if (sender.task?.dueDate == nil) //inefficient but works
            {
                var x = 0;
                while (x < tasksData [2].count && sender.task?.title.compare(tasksData [2][x].title) == .orderedDescending)
                {
                    x += 1;
                }
                tasksData [2].insert(temp, at: x);
                if (isExpanded [2])
                {
                    tableView.insertRows(at: [IndexPath(row: x, section: 2)], with: .fade);
                }
            }
            else if (Util.next(days: 1) as Date > (sender.task?.dueDate)! as Date)
            {
                var x = 0;
                while (x < tasksData [0].count && sender.task?.title.compare(tasksData [0][x].title) == .orderedDescending)
                {
                    x += 1;
                }
                tasksData [0].insert(temp, at: x);
                if (isExpanded [0])
                {
                    tableView.insertRows(at: [IndexPath(row: x, section: 0)], with: .fade);
                }
            }
            else
            {
                var x = 0;
                while (x < tasksData [1].count && ((sender.task?.dueDate)! as Date > tasksData [1][x].dueDate! as Date || (sender.task?.dueDate)! as Date == tasksData [1][x].dueDate! as Date && sender.task?.title.compare(tasksData [1][x].title) == .orderedDescending))
                {
                    x += 1;
                }
                tasksData [1].insert(temp, at: x);
                if (isExpanded [1])
                {
                    tableView.insertRows(at: [IndexPath(row: x, section: 1)], with: .fade);
                }
            }
        }
        tableView.endUpdates()
    }
    
    //MARK: Segues
    @objc func back ()
    {
        performSegue (withIdentifier: "returnFromToDoList", sender: self);
    }
    
    @objc func toItem ()
    {
        if (taskeventmenu.selectedFirst)
        {
            performSegue (withIdentifier: "toTaskItem", sender: self);
        }
        else
        {
            performSegue(withIdentifier: "toEventItem", sender: self);
        }
    }
    
    //MARK: Side Menus
    
    @objc func popOutList ()
    {
        currentTrailing = (taskeventmenu.selectedFirst ? taskMenuTrailing : eventMenuTrailing);
        currentTrailing.constant = 0;
        self.blackView.layer.opacity = 0;
        self.blackView.isHidden = false;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded();
            self.blackView.layer.opacity = 1;
        }, completion: nil)

    }
    
    @objc func dismissMenu ()
    {
        currentTrailing.constant = 0.75*screenWidth;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded();
            self.blackView.layer.opacity = 0;
        }) { (Finished) in
            self.blackView.isHidden = true;
        }
    }
    
    @objc func panned (sender: UIPanGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            //if panned over half, then dismiss
            if (currentTrailing.constant > 0.75*screenWidth/2)
            {
                currentTrailing.constant = 0.75*screenWidth;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.blackView.layer.opacity = 0;
                }) { (Finished) in
                    self.blackView.isHidden = true;
                }
            }
            else //otherwise, go back
            {
                currentTrailing.constant = 0;
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.blackView.layer.opacity = 1;
                }, completion: nil);
            }
        }
        else
        {
            let translation = sender.translation(in: view);
            let newval = currentTrailing.constant + translation.x;
            let newval2 = blackView.layer.opacity - Float(translation.x/(0.75*screenWidth));
            currentTrailing.constant = max(0, newval);
            blackView.layer.opacity = min (1, newval2);
            sender.setTranslation(.zero, in: view);
        }
    }
    
    @IBAction func returnFromItem (sender: UIStoryboardSegue) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
