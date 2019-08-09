//
//  SelectTagTableViewCell.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-31.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SelectTaskTagTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        setup ()
    }
    
    var tasktag: ToDo_TaskTag?
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    //for adjusting the width
    var tagWidth = NSLayoutConstraint()
    
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
    
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    
    private func setup ()
    {
        addSubview (tagLabel);
        tagLabel.translatesAutoresizingMaskIntoConstraints = false;
        tagLabel.centerXAnchor.constraint (equalTo: centerXAnchor).isActive = true;
        tagWidth = tagLabel.widthAnchor.constraint(equalToConstant: 0);
        tagWidth.isActive = true;
        tagLabel.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true;
        tagLabel.centerYAnchor.constraint (equalTo: centerYAnchor).isActive = true;
    }
    
    private func reload ()
    {
        tagLabel.text = tasktag?.name;
        tagLabel.layer.borderColor = tasktag?.colour.cgColor;
        tagLabel.textColor = tasktag?.colour;
        let tagsize = tagLabel.text?.size(withAttributes: [.font : tagLabel.font!]);
        guard let tagsize2 = tagsize else {return}
        tagWidth.constant = min (tagsize2.width + 20/375.0*screenWidth, 80/375.0*screenWidth);
    }

}
