//
//  File.swift
//  UTS APP
//
//  Created by Jacky He on 2019-04-23.
//  Copyright © 2019 Jacky He. All rights reserved.
//

import Foundation
import UIKit

//a random class that I found from the Internet which can create a new thread and make a timer that checks
// in the background for an event and performs some actions everytime it is triggered.
//Apparently this is better than just straight out calling DispatchSourceTimer, no idea why, maybe it looks cleaner

class RepeatingTimer
{
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval)
    {
        self.timeInterval = timeInterval
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.timeInterval, repeating: self.timeInterval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}

