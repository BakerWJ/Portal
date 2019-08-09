//
//  AddTagView.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-07-31.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit
import ChromaColorPicker

class AddTaskTagView: UIView, UITextFieldDelegate, ChromaColorPickerDelegate
{
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colourPicker.togglePickerColorMode();
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        colourPicker.togglePickerColorMode()
    }
    
    override init(frame: CGRect) {
        super.init (frame: frame);
        setup ()
    }
    required init?(coder: NSCoder) {
        super.init (coder: coder);
    }
    
    let namePlaceHolder = "name";
    let screenHeight = UIScreen.main.bounds.height;
    let screenWidth = UIScreen.main.bounds.width;
    
    lazy var colourPicker: ChromaColorPicker = {
        let picker = ChromaColorPicker(frame: CGRect(x: 0, y: 30/812.0*screenHeight, width: 300/812.0*screenHeight, height: 300/812.0*screenHeight));
        picker.padding = 5;
        picker.stroke = 10;
        //picker.isUserInteractionEnabled = true;
        //picker.isEnabled = true;
        picker.delegate = self;
        picker.togglePickerColorMode()
        picker.hexLabel.textColor = .black;
        return picker;
    }()
    
    //reference to the task tag
    var tasktag: ToDo_TaskTag?
    
    lazy var nameText: UITextField = {
        let text = UITextField ();
        text.translatesAutoresizingMaskIntoConstraints = false;
        text.backgroundColor = .clear;
        text.delegate = self;
        text.text = namePlaceHolder
        text.textColor = .lightGray
        text.font = UIFont (name: "SegoeUI", size: 14);
        return text;
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal);
        button.setTitle("Save", for: .selected);
        button.backgroundColor = .clear;
        button.setTitleColor(.black, for: .normal);
        button.setTitleColor(.black, for: .selected);
        button.addTarget(self, action: #selector (save), for: .touchUpInside);
        return button;
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == namePlaceHolder)
        {
            textField.text = "";
            textField.textColor = .black
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "")
        {
            textField.text = namePlaceHolder;
            textField.textColor = .lightGray;
        }
        textField.resignFirstResponder()
    }
    
    private func setup ()
    {
        backgroundColor = .white;
        addSubview(nameText);
        nameText.translatesAutoresizingMaskIntoConstraints = false;
        nameText.topAnchor.constraint (equalTo: topAnchor).isActive = true;
        nameText.leadingAnchor.constraint (equalTo: leadingAnchor).isActive = true;
        nameText.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        nameText.heightAnchor.constraint(equalToConstant: 30/812.0*screenHeight).isActive = true;
        
        addSubview(colourPicker);
        colourPicker.translatesAutoresizingMaskIntoConstraints = false;
        colourPicker.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        colourPicker.trailingAnchor.constraint (equalTo: trailingAnchor).isActive = true;
        colourPicker.topAnchor.constraint (equalTo: nameText.bottomAnchor).isActive = true;
        colourPicker.bottomAnchor.constraint (equalTo: bottomAnchor).isActive = true;
        colourPicker.layout()
    }
    
    @objc func save ()
    {
        if let tasktag = tasktag
        {
            CoreDataStack.saveContext()
        }
        else
        {
            if (nameText.text != namePlaceHolder && nameText.text != nil && nameText.text != "")
            {
                UserDataSettings.addTaskTag(colour: colourPicker.currentColor, name: nameText.text!);
            }
        }
        self.isHidden = false;
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
