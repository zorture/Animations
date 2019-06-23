//
//  FanBlade.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/6/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit


protocol FanBladeDelegate {
    func fanBlade(didSelected fanBlade: FanBlade)
    func fanBlade(didPause fanBlade: FanBlade)
    func fanBlade(didResume fanBlade: FanBlade)
}

class FanBlade: UIButton {
    
    var directionLC: NSLayoutConstraint!
    var distance: CGFloat = -60
    var delegate: FanBladeDelegate?
    var direction: ElasticDirection = .right
    let index: Int!
    var adjacentBlade: FanBlade?
    fileprivate var parentView: UIView!
    fileprivate var bladeLayout = FanBladeLayout()

    required init(atIndex index: Int) {
        self.index = index
        super.init(frame: .zero)
    }
    
    convenience init(withadjacentBlade blade: FanBlade, atIndex index: Int) {
        self.init(atIndex: index)
        self.adjacentBlade = blade
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        guard let superView = self.superview else { return }
        parentView = superView
        setupBlade()
    }
    
    fileprivate func setupBlade() {
        parentView.addSubview(self)
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        setSizeLayout(withConstant: 50)
        self.setOriginLayout(withDirection: self.direction, andConstant: -10)
        let animator = Animator(forView: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            //self.bladeLayout.disableAllConstraints()
            var deflection: CGFloat = 10.0
            if let adjacentBlade = self.adjacentBlade {
                deflection = adjacentBlade.frame.origin.y - 70
            }
            animator.addSpringAnimation(fromDirection: self.direction, withDeflection: deflection, completion: { value in
                if self.direction == .bottom {
                    if self.adjacentBlade == .none {
                        self.bladeLayout.bottomLC?.constant = -10
                    }
                } else if self.direction == .right {
                    self.bladeLayout.rightLC?.constant = -10
                } else if self.direction == .left {
                    self.bladeLayout.leftLC?.constant = 10
                }
                //self.bladeLayout.enableAllConstraints()
            })
        })
    }
    
    @objc func buttonAction(){
        guard let delegate = self.delegate else { return }
        delegate.fanBlade(didSelected: self)
    }
    
    private func setSizeLayout(withConstant constant: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        let widthLC = self.widthAnchor.constraint(equalToConstant: constant)
        let heightLC =  self.heightAnchor.constraint(equalToConstant: constant)
        NSLayoutConstraint.activate([widthLC, heightLC])
    }
    
    private func setOriginLayout(withDirection direction: ElasticDirection, andConstant constant: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        switch direction {
        case .bottom:
            self.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constant).isActive = true
            bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: abs(distance))
            bladeLayout.bottomLC?.isActive = true
        case .left:
            bladeLayout.leftLC = self.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: distance)
            bladeLayout.leftLC?.isActive = true
            if let adjacentBlade = self.adjacentBlade {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: adjacentBlade.topAnchor, constant: -20)
            } else {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constant)
            }
            bladeLayout.bottomLC?.isActive = true
        case .right:
            bladeLayout.rightLC = self.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: abs(distance))
            bladeLayout.rightLC?.isActive = true
            if let adjacentBlade = self.adjacentBlade {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: adjacentBlade.topAnchor, constant: -20)
            } else {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constant)
            }
            bladeLayout.bottomLC?.isActive = true
        }
    }
    
}

