//
//  Interactor.swift
//  TimeStamp
//
//  Created by Jacky He on 2019-06-23.
//  Copyright © 2019 Baker Jackson. All rights reserved.
//

import UIKit

class Interactor: UIPercentDrivenInteractiveTransition
{
    var hasStarted = false;   //whether an interaction is underway (true), otherwise (false)
    var shouldFinish = false; //whether the interaction should complete (true), or roll back (false)
}
