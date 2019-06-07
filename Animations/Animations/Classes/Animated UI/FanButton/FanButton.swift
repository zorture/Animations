//
//  FanButton.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/5/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

class FanButton: UIView {
    
    fileprivate var bottomView: UIView!
    var animator: UIDynamicAnimator!
    var bottomLC: NSLayoutConstraint!
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        bottomView = self
        animator = UIDynamicAnimator(referenceView: self)
        setupFanButton()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFanButton()
    }
    
    func addBlades(_ blade: FanBlade) {
        super.addSubview(blade)
    }
    
    private func setupFanButton() {
        setupMainView()
        addMainButton()
    }
    
    //common func to init our view
    private func setupMainView() {
        self.backgroundColor = .red
        self.clipsToBounds = true
        setSizeLayout(forView: self, withConstant: 70)
    }
    
    private func addMainButton() {
        let mainBlade = FanBlade(onView: self, ofType: .main)
        mainBlade.delegate = self
        mainBlade.direction = .bottom
        mainBlade.setupBlade()
        //animator = UIDynamicAnimator(referenceView: mainBlade)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.addBehavior(forBlade: mainBlade)
        })
    }
    
    func addBehavior(forBlade blade: FanBlade) {
        addSnapBehavior(toView: blade, toPoint: CGPoint(x: blade.center.x, y: blade.center.y - blade.snapDistance))
    }
    
    private func setSizeLayout(forView view: UIView, withConstant constant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: constant).isActive = true
        view.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    private func setOriginLayout(forView view: UIView, withConstant constant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: constant).isActive = true
        bottomLC = view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: constant + 60)
        bottomLC.isActive = true
        bottomView = view
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
            //self.bottomLC.constant = 0
        }
        animator.addBehavior(snapBehavior)
    }
    
}

extension FanButton: FanBladeDelegate {
    func fabBlade(didSelected fanBlade: FanBlade) {
    }
}
