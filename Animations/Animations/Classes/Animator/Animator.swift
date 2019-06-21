//
//  Animator.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/8/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

enum ElasticDirection {
    case left
    case right
    case top
    case bottom
}

class Animator: NSObject {
    
    fileprivate var parentView: UIView?
    fileprivate var childView: UIView?
    fileprivate var animator: UIDynamicAnimator!
    
    init(withParent parent: UIView, withChild child: UIView) {
        parentView = parent
        childView = child
        super.init()
        setDynamicAnimator()
    }
    
    init(forView view: UIView) {
        childView = view
    }
    
    func setDynamicAnimator() {
        guard let parent = parentView else { return }
        animator = UIDynamicAnimator(referenceView: parent)
        animator.delegate = self
    }
    
    func addSpringAnimation(fromDirection direction: ElasticDirection, withDeflection deflection: CGFloat, completion: ((Bool) -> Void)? = nil) {
        var transformX: CGFloat = 0.0
        var transformY: CGFloat = 0.0
        switch direction {
        case .top:
            transformY += deflection
            transformX += 10
        case .bottom:
            transformY += deflection
            transformX += 10
        case .left:
            transformX += deflection
            transformY += 10
        case .right:
            transformX += deflection
            transformY += 10
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            guard let view = self.childView else { return }
            view.frame.origin = CGPoint(x: transformX, y: transformY)
            //view.transform = CGAffineTransform(translationX: transformX, y: transformY)
        }) { value in
            completion?(value)
        }
    }
    
    func addBehavior(forBlade blade: FanBlade) {
        addSnapBehavior(toView: blade, toPoint: CGPoint(x: blade.center.x, y: blade.center.y - blade.distance))
    }
    
    func addAttachmentBehavior(toItem item: UIDynamicItem, toPoint point: CGPoint){
        animator.removeAllBehaviors()
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: point)
        attachmentBehavior.damping = 0.1
        animator.addBehavior(attachmentBehavior)
    }
    
    func addSnapBehavior(toView view: UIView, toPoint point: CGPoint){
        animator.removeAllBehaviors()
        let snapBehavior = UISnapBehavior(item: view, snapTo: point)
        snapBehavior.damping = 0.3
        snapBehavior.action = {
            //self.directionLC.constant = -5
        }
        animator.addBehavior(snapBehavior)
    }
    
}

extension Animator: UIDynamicAnimatorDelegate {
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {
        print("Paused")
        //guard let delegate = self.delegate else { return }
        //delegate.fanBlade(didPause: self)
    }
    
    func dynamicAnimatorWillResume(_ animator: UIDynamicAnimator) {
        print("Resume")
        //guard let delegate = self.delegate else { return }
        //delegate.fanBlade(didResume: self)
    }
}
