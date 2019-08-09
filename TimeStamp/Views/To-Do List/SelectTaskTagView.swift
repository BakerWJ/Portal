//
//  SelectTagView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-31.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import CoreData

//this is the pop up view that appears with a list of existing tags and allows the users to add new tags
class SelectTaskTagView: UIView, UITableViewDataSource, UITableViewDelegate
{
    override init(frame: CGRect) {
        super.init(frame: frame);
        setUp()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    let tableView = UITableView()
    var tasksTags = [ToDo_TaskTag]()
    let cellId = "cellId";
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    lazy var addTagButton: UIButton = {
        let button = UIButton ()
        button.setTitle("Add Tag", for: .normal);
        button.setTitle("Add Tag", for: .selected);
        button.setTitleColor(.black, for: .normal);
        button.setTitleColor(.black, for: .selected);
        button.backgroundColor = .clear;
        button.addTarget(self, action: #selector(addTag), for: .touchUpInside);
        return button;
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton ()
        button.backgroundColor = .clear;
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .normal);
        button.setBackgroundImage(UIImage(named: "cancelIcon"), for: .selected);
        button.addTarget (self, action: #selector(cancel), for: .touchUpInside);
        return button;
    }()
    
    let addTaskTagView = AddTaskTagView()
    
    func reload()
    {
        getData()
        tableView.reloadData()
    }
    
    private func getData ()
    {
        guard let tags = UserDataSettings.fetchAllTaskTags() else {return}
        tasksTags = tags
    }
    
    private func setUp()
    {
        translatesAutoresizingMaskIntoConstraints = false;
        heightAnchor.constraint(equalToConstant: 400/812.0*screenHeight).isActive = true;
        backgroundColor = .white;
        
        addSubview (addTagButton);
        addTagButton.translatesAutoresizingMaskIntoConstraints = false;
        addTagButton.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        addTagButton.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        addTagButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true;
        addTagButton.heightAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        
        addSubview(cancelButton);
        cancelButton.translatesAutoresizingMaskIntoConstraints = false;
        cancelButton.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        cancelButton.widthAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        cancelButton.heightAnchor.constraint (equalTo: cancelButton.widthAnchor).isActive = true;
        cancelButton.topAnchor.constraint (equalTo: topAnchor).isActive = true;
    
        //adds the tableview
        addSubview (tableView);
        
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.topAnchor.constraint (equalTo: cancelButton.bottomAnchor).isActive = true;
        tableView.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        tableView.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        tableView.bottomAnchor.constraint (equalTo: bottomAnchor).isActive = true;
        
        tableView.register(SelectTaskTagTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = .clear;
        tableView.tableFooterView = UIView()
        
        addSubview(addTaskTagView);
        addTaskTagView.translatesAutoresizingMaskIntoConstraints = false;
        addTaskTagView.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        addTaskTagView.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
        addTaskTagView.widthAnchor.constraint (equalToConstant: 300/812.0*screenHeight).isActive = true;
        addTaskTagView.heightAnchor.constraint (equalToConstant: 330/812.0*screenHeight).isActive = true;
        addTaskTagView.isHidden = true;
        addTaskTagView.layoutIfNeeded()
        addTaskTagView.colourPicker.layout()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectTaskTagTableViewCell
        cell.tasktag = tasksTags [indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40/812.0*screenHeight;
    }
    
    //when user wants to add a new tag
    @objc func addTag ()
    {
        addTaskTagView.isHidden = false;
    }
    
    //called when the user wants to cancel selecting a new tag
    @objc func cancel()
    {
        self.isHidden = true;
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
