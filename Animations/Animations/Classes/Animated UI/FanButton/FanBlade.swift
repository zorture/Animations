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
    let direction: ElasticDirection!
    fileprivate let parentView: UIView!
    fileprivate var bottomBlade: FanBlade?
    fileprivate var bladeLayout = FanBladeLayout()

    
    required init(onView view: UIView, ElasticDirection direction: ElasticDirection) {
        self.direction = direction
        self.parentView = view
        super.init(frame: .zero)
        
    }
    
    convenience init(onView view: UIView, withBottomBlade blade: FanBlade, fromElasticDirection direction: ElasticDirection) {
        self.init(onView: view, ElasticDirection: direction)
        self.bottomBlade = blade
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBlade() {
        parentView.addSubview(self)
        
        //backgroundColor = .orange
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        setSizeLayout(withConstant: 50)
        parentView.layoutSubviews()
        self.setOriginLayout(withDirection: self.direction, andConstant: -10)
        parentView.layoutSubviews()
        let animator = Animator(forView: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            self.bladeLayout.disableAllConstraints()
            if self.direction == .bottom {
                self.bladeLayout.bottomLC?.isActive = false
            } else if self.direction == .right {
                self.bladeLayout.rightLC?.isActive = false
            }
            var deflection: CGFloat = 10.0
            if let bottomBlade = self.bottomBlade {
                deflection = bottomBlade.frame.origin.y - 70
                print(bottomBlade.frame.origin.y)
                print(deflection)
            }
            animator.addSpringAnimation(fromDirection: self.direction, withDeflection: deflection, completion: { value in
                if self.direction == .bottom {
                    self.bladeLayout.bottomLC?.constant = -10
                    self.bladeLayout.bottomLC?.isActive = true
                } else if self.direction == .right {
                    self.bladeLayout.rightLC?.constant = -10
                    self.bladeLayout.rightLC?.isActive = true
                }
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
        case .top:
            self.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constant).isActive = true
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: distance).isActive = true
        case .bottom:
            self.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constant).isActive = true
            bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: abs(distance))
            bladeLayout.bottomLC?.isActive = true
        case .left:
            self.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: distance).isActive = true
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constant).isActive = true
        case .right:
            bladeLayout.rightLC = self.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: abs(distance))
            bladeLayout.rightLC?.isActive = true
            if let bottomBlade = self.bottomBlade {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: bottomBlade.topAnchor, constant: -20)
            } else {
                bladeLayout.bottomLC = self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constant)
            }
            bladeLayout.bottomLC?.isActive = true

        }
    }
    
}

