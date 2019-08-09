//
//  TaskListView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-09.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

//a list of tasks
class TaskListView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style);
        setup ();
    }
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    //table view properties
    let cellId = "cellId"
    var tasksData = [[ToDo_Task]]()
    var isExpanded = [true, true, true, true];
    let headerNames = ["Today", "Upcoming", "No Due Date", "Completed"];
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    private func setup ()
    {
        backgroundColor = .clear;
        register(TaskListTableViewCell.self, forCellReuseIdentifier: cellId)
        delegate = self;
        dataSource = self;
        backgroundColor = .clear
        //remove unnecessary lines
        tableFooterView = UIView();
        createSomeTasks()
        setupTableView()
    }
    
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
        reloadData()
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
    
    //conform to protocol
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TaskListTableViewCell;
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
        self.beginUpdates()
        if (isExpanded [section]) //if now this is expanded, then add the rows
        {
            self.insertRows(at: indexPaths, with: .fade);
        }
        else //otherwise delete them
        {
            self.deleteRows(at: indexPaths, with: .fade);
        }
        self.endUpdates()
    }
    
    func updateCompletionStatus (sender: TaskListTableViewCell) //delegate method
    {
        let indexPath = self.indexPath(for: sender)!;
        self.beginUpdates();
        if ((sender.task?.completed)!)
        {
            //move it to the completion section
            let temp = tasksData [indexPath.section].remove(at: indexPath.row);
            self.deleteRows(at: [indexPath], with: .fade);
            tasksData [3].append (temp);
            sender.leading.constant = 0;
            sender.wrapperView.layer.opacity = 1;
            if (isExpanded [3])
            {
                self.insertRows(at: [IndexPath(row: tasksData [3].count - 1, section: 3)], with: .fade);
            }
        }
        else
        {
            let temp = tasksData [indexPath.section].remove(at: indexPath.row);
            self.deleteRows(at: [indexPath], with: .fade);
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
                    self.insertRows(at: [IndexPath(row: x, section: 2)], with: .fade);
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
                    self.insertRows(at: [IndexPath(row: x, section: 0)], with: .fade);
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
                    self.insertRows(at: [IndexPath(row: x, section: 1)], with: .fade);
                }
            }
        }
        self.endUpdates()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
