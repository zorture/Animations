//
//  ViewController.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/3/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var arcButton: UIButton!
    @IBOutlet weak var btcButton: UIButton!
    var snapButton: FanButton!
    var arcAnim: ArcAnimation!
    override func viewDidLoad() {
        super.viewDidLoad()
        arcAnim = ArcAnimation(animateForView: arcButton)
        snapButton = FanButton(frame: .zero)
        view.addSubview(snapButton)
        
        snapButton.translatesAutoresizingMaskIntoConstraints = false
        snapButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        snapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true        
    }

    @IBAction func btcHandler(_ sender: UIButton) {
        
        if sender == btcButton {
            let pulse = Pulsating(pulseCount: 1, radius: 110, position: sender.center)
            pulse.pulseDuration = 1
            view.layer.insertSublayer(pulse, below: sender.layer)
        } else {
            arcAnim.startAnimating()
        }
    }
    
    func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }
    
}


