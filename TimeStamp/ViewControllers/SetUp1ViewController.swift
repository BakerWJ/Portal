//
//  SetUp1ViewController.swift
//  TimeStamp
//
//  Created by Baker Jackson on 2019-04-28.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class SetUp1ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mondayTextView: UITextField!
    @IBOutlet weak var tuesdayTextView: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var ImdoneButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var tellusmoreLabel: UILabel!
    @IBOutlet weak var tellusmoreExplainLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    
    var classnumber: Int = 1;
    var progress: [UIImageView] = [UIImageView] ()
    let stackview = UIStackView ();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mondayTextView.delegate = self
        tuesdayTextView.delegate = self
        ImdoneButton.isHidden = true;
        ImdoneButton.layer.opacity = 0;
        nextButton.isHidden = false;
        skipButton.isHidden = false;
        setUpProgress()
        setConstraints ()
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func returnText (classnumber: Int) -> String
    {
        if (classnumber == 1)
        {
            return "FIRST";
        }
        if (classnumber == 2)
        {
            return "SECOND";
        }
        if (classnumber == 3)
        {
            return "THIRD"
        }
        if (classnumber == 4)
        {
            return "FOURTH"
        }
        return "FIFTH";
    }
    
    @IBAction func isClicked(_ sender: Any) {
        let variableName = UserTimetable()
        variableName.update(ADay: true, flipped: false, classnumber: classnumber, newValue: mondayTextView.text ?? "Period \(classnumber)")
        variableName.update(ADay: false, flipped: false, classnumber: classnumber, newValue: tuesdayTextView.text ?? "Period \(classnumber)")
        mondayTextView.text = "";
        tuesdayTextView.text = "";
        classnumber += 1;
        updateProgress ();
        doAnimations ();
    }
    
    //updates the progress bar
    func updateProgress ()
    {
        if (classnumber <= 5)
        {
            progress [classnumber - 1].isHighlighted = true;
            progress [classnumber - 2].isHighlighted = false;
        }
    }
    
    //sets up the progress bar
    func setUpProgress ()
    {
        view.addSubview (stackview);
        stackview.axis = .horizontal;
        stackview.spacing = view.frame.height/812.0*42;
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false;
        stackview.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        stackview.topAnchor.constraint (equalTo: view.topAnchor, constant: 593/812.0*view.frame.height).isActive = true;
        for _ in 0..<5
        {
            let imageView = UIImageView (image: UIImage(named: "Ellipse 39-1"), highlightedImage: UIImage (named: "Ellipse 39"))
            progress.append (imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false;
            imageView.heightAnchor.constraint (equalToConstant: 15.0/812*view.frame.height).isActive = true;
            imageView.widthAnchor.constraint (equalToConstant: 15.0/812*view.frame.height).isActive = true;
            stackview.addArrangedSubview (imageView);
        }
        progress [0].isHighlighted = true;
    }
    
    //does some animations
    func doAnimations ()
    {
        UIView.animate (withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations:
        {
                self.questionLabel.layer.opacity = 0;
        }) {(Finished) in
            self.questionLabel.text = "WHAT IS YOUR \(self.returnText (classnumber: self.classnumber)) PERIOD CLASS?";
            UIView.animate (withDuration: 0.2, delay: 0.0, options:.curveEaseInOut, animations:
                {
                    self.questionLabel.layer.opacity = 1;
            }, completion: nil)
        }
        if (classnumber == 5)
        {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                self.nextButton.layer.opacity = 0;
                self.skipButton.layer.opacity = 0;
            }) { (Finished) in
                self.nextButton.isHidden = true;
                self.skipButton.isHidden = true
                self.ImdoneButton.isHidden = false;
                UIView.animate (withDuration: 0.2 , delay: 0.0, options: .curveEaseInOut, animations:
                    {
                        self.ImdoneButton.layer.opacity = 1;
                }, completion: nil)
            }
        }
    }
    
    //sets constraints
    private func setConstraints ()
    {
        skipButton.translatesAutoresizingMaskIntoConstraints = false;
        tellusmoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        tellusmoreExplainLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false;
        mondayTextView.translatesAutoresizingMaskIntoConstraints = false
        tuesdayTextView.translatesAutoresizingMaskIntoConstraints = false
        mondayLabel.translatesAutoresizingMaskIntoConstraints = false;
        tuesdayLabel.translatesAutoresizingMaskIntoConstraints = false
        ImdoneButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        skipButton.titleLabel?.numberOfLines = 1;
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true;
        tellusmoreLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        tellusmoreLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 31.0/812).isActive = true;
        tellusmoreLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 118/812.0*view.frame.height).isActive = true
        tellusmoreExplainLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        tellusmoreExplainLabel.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 49.0/812).isActive = true;
        tellusmoreExplainLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 145/812.0*view.frame.height).isActive = true
        questionLabel.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        questionLabel.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 104/812.0).isActive = true;
        questionLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 208/812.0*view.frame.height).isActive = true;
        mondayTextView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        mondayTextView.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 30/812.0).isActive = true;
        mondayTextView.topAnchor.constraint (equalTo: view.topAnchor, constant: 363/812.0*view.frame.height).isActive = true;
        
        mondayTextView.borderStyle = .none
        mondayTextView.layer.masksToBounds = false;
        mondayTextView.layer.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0).cgColor
        mondayTextView.layer.shadowColor = UIColor(red: 132.0/255, green: 132.0/255, blue: 132.0/255, alpha: 1.0).cgColor
        mondayTextView.layer.shadowOffset = CGSize (width: 0.0, height: 1.0)
        mondayTextView.layer.shadowOpacity = 1.0
        mondayTextView.layer.shadowRadius = 0.0
        
        tuesdayTextView.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        tuesdayTextView.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 30/812.0).isActive = true;
        tuesdayTextView.topAnchor.constraint (equalTo: view.topAnchor, constant: 474/812.0*view.frame.height).isActive = true;
        
        tuesdayTextView.borderStyle = .none
        tuesdayTextView.layer.masksToBounds = false;
        tuesdayTextView.layer.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1.0).cgColor
        tuesdayTextView.layer.shadowColor = UIColor(red: 132.0/255, green: 132.0/255, blue: 132.0/255, alpha: 1.0).cgColor
        tuesdayTextView.layer.shadowOffset = CGSize (width: 0.0, height: 1.0)
        tuesdayTextView.layer.shadowOpacity = 1.0
        tuesdayTextView.layer.shadowRadius = 0.0
        
        mondayLabel.leadingAnchor.constraint(equalTo: mondayTextView.leadingAnchor).isActive = true;
        mondayLabel.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 23.0/812.0).isActive = true;
        mondayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 320/812.0*view.frame.height).isActive = true
        tuesdayLabel.leadingAnchor.constraint(equalTo: tuesdayTextView.leadingAnchor).isActive = true;
        tuesdayLabel.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 23.0/812.0).isActive = true;
        tuesdayLabel.topAnchor.constraint (equalTo: view.topAnchor, constant: 431/812.0*view.frame.height).isActive = true;
        ImdoneButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true;
        ImdoneButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 43.0/812.0).isActive = true
        ImdoneButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 648/812.0*view.frame.height).isActive = true
        nextButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 43.0/812.0).isActive = true;
        nextButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 648/812.0*view.frame.height).isActive = true
        skipButton.centerXAnchor.constraint (equalTo: view.centerXAnchor).isActive = true
        skipButton.heightAnchor.constraint (equalTo: view.heightAnchor, multiplier: 23/812.0).isActive = true
        skipButton.topAnchor.constraint (equalTo: view.topAnchor, constant: 710/812.0*view.frame.height).isActive = true;
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
}
