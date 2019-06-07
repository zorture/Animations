//
//  FanBlade.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/6/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

enum BladeType {
    case main
    case other
}

enum SpinDirection {
    case left
    case right
    case top
    case bottom
}

protocol FanBladeDelegate {
    func fabBlade(didSelected fanBlade: FanBlade)
}

class FanBlade: UIButton {
    
    let type: BladeType!
    var directionLC: NSLayoutConstraint!
    var snapDistance: CGFloat = 60
    var direction: SpinDirection = .bottom
    var delegate: FanBladeDelegate?
    fileprivate let parentView: UIView!
    
    required init(onView view: UIView, ofType type: BladeType) {
        self.type = type
        self.parentView = view
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBlade() {
        parentView.addSubview(self)
        backgroundColor = .orange
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        setSizeLayout(forView: self, withConstant: 50)
        setOriginLayout(forView: self, withConstant: -5)
        
    }
    
    @objc func buttonAction(){
        guard let delegate = self.delegate else { return }
        delegate.fabBlade(didSelected: self)
    }
    
    
    private func setSizeLayout(forView view: UIView, withConstant constant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: constant).isActive = true
        view.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    private func setOriginLayout(forView view: UIView, withConstant constant: CGFloat){
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constant).isActive = true
        switch direction {
        case .top:
            directionLC = view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: constant + snapDistance)
        case .bottom:
            directionLC = view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: constant + snapDistance)
        case .left:
            directionLC = view.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: constant + snapDistance)
        case .right:
            directionLC = view.rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: constant + snapDistance)
        }
        
        directionLC.isActive = true
        //bottomView = view
    }
    

}
