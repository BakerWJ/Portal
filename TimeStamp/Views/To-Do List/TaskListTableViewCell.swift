//
//  TaskView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-11.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell
{
    var task: ToDo_Task? {
        didSet {
            reload()
        }
    }
    
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
 
    //the delegate for passing in values for adjusting the views
    weak var delegate: TaskListView?
    
    var tagWidth = NSLayoutConstraint ()
    var leading = NSLayoutConstraint()
    
    //date formatter
    let formatter = DateFormatter();
    
    //initialize the completed (or not) button
    let checkMark: UIButton = {
        let button = UIButton();
        button.backgroundColor = .clear;
        button.setBackgroundImage(UIImage(named: "notChecked"), for: .normal);
        button.setBackgroundImage(UIImage(named: "notChecked"), for: [.normal, .highlighted]);
        button.setBackgroundImage(UIImage(named: "checked"), for: .selected)
        button.setBackgroundImage(UIImage(named: "checked"), for: [.selected, .highlighted]);
        button.translatesAutoresizingMaskIntoConstraints = false;
        return button;
    }()
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear;
        label.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 1;
        label.textAlignment = .center;
        label.layer.cornerRadius = 15/812.0*screenHeight;
        label.layer.borderWidth = 2/812.0*screenHeight;
        return label;
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 1;
        label.backgroundColor = .clear;
        label.textAlignment = .left;
        label.textColor = .black;
        return label;
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel ()
        label.font = UIFont (name: "SegoeUI", size: 16/812.0*screenHeight);
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.numberOfLines = 1;
        label.backgroundColor = .clear;
        label.textAlignment = .right;
        label.textColor = UIColor(red: 132/255.0, green: 132/255.0, blue: 132/255.0, alpha: 1);
        return label;
    }()
    
    let wrapperView = UIView ();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init (style: style, reuseIdentifier: reuseIdentifier);
        setup ();
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        reload();
    }
    
    required init? (coder: NSCoder)
    {
        super.init (coder: coder);
    }
    
    private func setup ()
    {
        backgroundColor = .clear;
        formatter.dateFormat = "MMM d"
        
        //this wrapper view is created so the leading constraint can be manipulated
        addSubview(wrapperView);
        wrapperView.translatesAutoresizingMaskIntoConstraints = false;
        wrapperView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true;
        leading = wrapperView.leadingAnchor.constraint (equalTo: leadingAnchor);
        leading.isActive = true;
        addConstraintsWithFormat("V:|[v0]|", views: wrapperView);
        
        wrapperView.addSubview (checkMark);
        wrapperView.addSubview (titleLabel);
        wrapperView.addSubview (tagLabel);
        wrapperView.addSubview(dateLabel);
        
        //set constraints
        checkMark.leadingAnchor.constraint (equalTo: wrapperView.leadingAnchor, constant: 12/375.0*screenWidth).isActive = true;
        checkMark.centerYAnchor.constraint (equalTo: wrapperView.centerYAnchor).isActive = true;
        checkMark.heightAnchor.constraint (equalTo: wrapperView.heightAnchor, multiplier: 0.6).isActive = true;
        checkMark.widthAnchor.constraint (equalTo: checkMark.heightAnchor).isActive = true;
        checkMark.addTarget(self, action: #selector (buttonPressed), for: .touchUpInside);
        
        titleLabel.leadingAnchor.constraint (equalTo: checkMark.trailingAnchor, constant: 12/375.0*screenWidth).isActive = true;
        titleLabel.heightAnchor.constraint (equalTo: wrapperView.heightAnchor).isActive = true;
        titleLabel.centerYAnchor.constraint (equalTo: wrapperView.centerYAnchor).isActive = true;
        titleLabel.widthAnchor.constraint (equalToConstant: 180/375.0*screenWidth).isActive = true;
        
        dateLabel.trailingAnchor.constraint (equalTo: wrapperView.trailingAnchor, constant: -12/375.0*screenWidth).isActive = true;
        dateLabel.widthAnchor.constraint (equalToConstant: 35/275.0*screenWidth).isActive = true;
        dateLabel.centerYAnchor.constraint (equalTo: wrapperView.centerYAnchor).isActive = true;
        dateLabel.heightAnchor.constraint (equalTo: wrapperView.heightAnchor).isActive = true;
        
        //max 80
        tagLabel.trailingAnchor.constraint (equalTo: dateLabel.leadingAnchor, constant: -12/375.0*screenWidth).isActive = true;
        tagLabel.centerYAnchor.constraint (equalTo: wrapperView.centerYAnchor).isActive = true;
        tagLabel.heightAnchor.constraint (equalToConstant: 30/812.0*screenHeight).isActive = true;
        tagWidth = tagLabel.widthAnchor.constraint (equalToConstant: 0/375.0*screenWidth)
        tagWidth.isActive = true;
        
        //add a pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer (target: self, action: #selector (panned));
        wrapperView.addGestureRecognizer(panGestureRecognizer);
    }
    
    //update the appearance by reading the values of the stored task and displaying it onto the view
    func reload ()
    {
        var targetOpacity: Float = 1.0;
        if ((task?.completed)!)
        {
            checkMark.isSelected = true;
            targetOpacity = 0.4
        }
        else
        {
            checkMark.isSelected = false;
            targetOpacity = 1;
        }
        titleLabel.text = task?.title;
        if let date = task?.dueDate
        {
            dateLabel.text = formatter.string(from: date as Date);
        }
        else
        {
            dateLabel.text = "";
        }
        tagLabel.text = task?.tag.name;
        tagLabel.layer.borderColor = task?.tag.colour.cgColor;
        tagLabel.textColor = task?.tag.colour;
        let tagsize = tagLabel.text?.size(withAttributes: [NSAttributedString.Key.font : tagLabel.font]);
        guard let tagsize2 = tagsize else {return};
        tagWidth.constant = min (tagsize2.width + 20/375*screenWidth, 80/375*screenWidth);
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            self.titleLabel.layer.opacity = targetOpacity;
            self.dateLabel.layer.opacity = targetOpacity;
            self.tagLabel.layer.opacity = targetOpacity;
        })
    }
    
    @objc func panned (sender: UIPanGestureRecognizer)
    {
        if (sender.state == .ended)
        {
            if (leading.constant > screenWidth*0.25)
            {
                leading.constant = screenWidth;
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded();
                }) { (Finished) in
                    self.wrapperView.layer.opacity = 0;
                    self.leading.constant = 0;
                    self.setCompleted(!((self.task?.completed)!));
                }
            }
            else
            {
                leading.constant = 0;
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded();
                }, completion: nil);
            }
        }
        else
        {
            let translation = sender.translation(in: self);
            leading.constant += translation.x;
            sender.setTranslation(.zero, in: self);
        }
    }
    
    @objc func buttonPressed ()
    {
        if ((task?.completed)!)
        {
            setCompleted(false);
        }
        else
        {
            setCompleted(true);
        }
    }
    
    func setCompleted (_ completed: Bool)
    {
        task?.completed = completed;
        CoreDataStack.saveContext();
        
        //reload the data every time the state of the task changes
        reload();
        
        //call on this method to move the cell to the completion section or out of there
        delegate?.updateCompletionStatus(sender: self);
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
