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
    var fanButton: FanButton!
    var arcAnim: ArcAnimation!
    override func viewDidLoad() {
        super.viewDidLoad()
        arcAnim = ArcAnimation(animateForView: arcButton)
        fanButton = FanButton(frame: .zero)
        fanButton.dataSource = self
        fanButton.delegate = self
        view.addSubview(fanButton)
        fanButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        fanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
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

extension ViewController: FanButtonDelegate, FanButtonDataSource {
    func fanButton(_ fanButton: FanButton, fanBladeForRowAt index: Int) -> FanBlade {
        let blade = FanBlade(atIndex: index)
        if index == 0 {
            blade.direction = .bottom
            blade.backgroundColor = .orange
        } else {
            blade.direction = .right
            blade.backgroundColor = .green
        }
        return blade
    }
    
    func fanButton(_ fanButton: FanButton, didSelectBlade fanBlade: FanBlade) {
        print("\(fanBlade.index) Clicked")
    }
    
    func numberOfBlades(in fanButton: FanButton) -> Int {
        return 4
    }
    
    
}


