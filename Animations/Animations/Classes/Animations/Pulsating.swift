//
//  Pulsating.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/3/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

class Pulsating: CALayer {
    
    var pulseCount = 0
    var nextPulse:TimeInterval = 0
    var radius:CGFloat = 100
    var pulseScale:Float = 100
    var pulseDuration:TimeInterval = 1
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(pulseCount: Int, radius: CGFloat, position: CGPoint) {
        super.init()
        self.backgroundColor = UIColor.orange.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.pulseCount = pulseCount
        self.position = position
        self.bounds = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        // Make it circle
        self.cornerRadius = radius
        
        DispatchQueue.global(qos: .default).async {
            let animationGroup = self.setupAnimation()
            DispatchQueue.main.async {
                self.add(animationGroup, forKey: "pulsating")
            }
        }
    }
    
    func setupAnimation() -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.repeatCount = 1
        
        let animTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        animationGroup.timingFunction = animTimingFunction
        animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
        
        return animationGroup
    }

    func createScaleAnimation() -> CABasicAnimation {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnim.fromValue = NSNumber(value: 0)
        scaleAnim.toValue = NSNumber(value: 1)
        scaleAnim.duration = pulseDuration
        return scaleAnim
    }
    
    func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnim = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnim.duration = 1
        opacityAnim.values = [0.2, 0.4, 0.6, 0.8, 0]
        opacityAnim.keyTimes = [0, 0.2, 0.4, 0.5, 1]
        return opacityAnim
    }
    
    
}
