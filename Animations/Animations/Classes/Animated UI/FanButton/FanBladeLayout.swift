//
//  FanBladeLayout.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/21/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

struct FanBladeLayout {
    
    var leftLC: NSLayoutConstraint?
    var rightLC: NSLayoutConstraint?
    var topLC: NSLayoutConstraint?
    var bottomLC: NSLayoutConstraint?
    
    func disableAllConstraints() {
        leftLC?.isActive = false
        rightLC?.isActive = false
        topLC?.isActive = false
        bottomLC?.isActive = false
    }
    
    func enableAllConstraints() {
        leftLC?.isActive = true
        rightLC?.isActive = true
        topLC?.isActive = true
        bottomLC?.isActive = true
    }
    
    func disableRightConstraings(){
        rightLC?.isActive = true
    }

}
