//
//  ArcAnimation.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/3/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

enum Direction {
    case top
    case bottom
}

class ArcAnimation: NSObject {
    
    
    var topLayer: CAShapeLayer!
    var bottomLayer: CAShapeLayer!
    var animatingView: UIView!
    var containerView = UIView()
    
    init(animateForView view: UIView) {
        super.init()
        animatingView = view
        let containerOrigin = CGPoint(x: view.frame.origin.x, y: view.frame.origin.y+24)
        let containerSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        containerView.frame = CGRect(origin: containerOrigin, size: containerSize)
        
        topLayer = createSemiCircle(forDirection: .top)
        topLayer.position =  CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
        bottomLayer = createSemiCircle(forDirection: .bottom)
        bottomLayer.position =  CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)

        containerView.layer.addSublayer(topLayer)
        containerView.layer.addSublayer(bottomLayer)
        view.superview!.insertSubview(containerView, belowSubview: view)
    
        
    }
    
    /* Create Semi Circle shape layer. */
    fileprivate func createSemiCircle(forDirection direction: Direction) -> CAShapeLayer{
        let circleLayer = CAShapeLayer()
        let circlePath:UIBezierPath
        switch direction {
        case .top:
            circlePath = UIBezierPath(arcCenter: .zero, radius: 60, startAngle: deg2rad(180), endAngle: deg2rad(360), clockwise: true)
            circleLayer.strokeColor = UIColor.red.cgColor
        default:
            circlePath = UIBezierPath(arcCenter: .zero, radius: 60, startAngle: deg2rad(0), endAngle: deg2rad(180), clockwise: true)
            circleLayer.strokeColor = UIColor.green.cgColor
        }
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = 10.0
        circleLayer.lineCap = .round
        circleLayer.backgroundColor = UIColor.yellow.cgColor
        circleLayer.position =  CGPoint(x: 0, y: 50)
        return circleLayer
    }

    /* Translate layers at y axis */
    fileprivate func createPositionAnimation(forDirection direction: Direction, forLayer layer: CALayer, completion: (() -> Void)?) {
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            print("position Animation Done")
            completion?()
        })
        
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        positionAnimation.duration = 1
        positionAnimation.fillMode = .forwards
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        positionAnimation.fromValue = 50;
        switch direction {
        case .top:
            positionAnimation.toValue = 40;
            layer.add(positionAnimation, forKey: "topPosition")
        default:
            positionAnimation.toValue = 60;
            layer.add(positionAnimation, forKey: "bottomPosition")
        }
        CATransaction.commit()

    }
    
    /* Rotate layer on it's axis/ xy plane */
    
    fileprivate func createRotationAnimation(forLayer layer: CALayer, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            print("Rotation Animation Done")
            completion?()
        })
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = CGFloat(Float.pi * 2.0)
        rotationAnimation.duration = 1
        //rotationAnimation.delegate = self
        layer.add(rotationAnimation, forKey: "rotation")
        CATransaction.commit()
    }
    
    func deg2rad(_ number: Double) -> CGFloat {
        return CGFloat(number * .pi / 180)
    }
}

extension ArcAnimation {
    func startAnimating() {
        DispatchQueue.main.async {
            self.createRotationAnimation(forLayer: self.containerView.layer, completion: {
                self.createPositionAnimation(forDirection: .top, forLayer: self.topLayer, completion: nil)
                self.createPositionAnimation(forDirection: .bottom, forLayer: self.bottomLayer, completion: nil)
            })
        }
    }
}
