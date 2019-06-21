//
//  FanButton.swift
//  Animations
//
//  Created by Kanwar Zorawar Singh Rana on 6/5/19.
//  Copyright © 2019 Kanwar Zorawar Singh Rana. All rights reserved.
//

import UIKit

protocol FanButtonDelegate {
    func fanButton(_ fanButton: FanButton, didSelectBlade fanBlade: FanBlade)
}

protocol FanButtonDataSource {
    func numberOfBlades(in fanButton: FanButton) -> Int
}

class FanButton {
    
    
    var bottomLC: NSLayoutConstraint!
    var heightLC: NSLayoutConstraint!
    let size: CGFloat = 70
    var dataSource: FanButtonDataSource?
    var delegate: FanButtonDelegate?
    fileprivate var mainView: UIView!
    fileprivate var parentView: UIView!
    fileprivate var bottomView: UIView!

    init(onView view: UIView) {
        parentView = view
        mainView = UIView.init(frame: .zero)
        parentView.addSubview(mainView)
        setupFanButton()
    }

    private func setupFanButton() {
        setupMainView()
        addButton(fromDirection: .right)
    }
    
    //common func to init our view
    private func setupMainView() {
        mainView.backgroundColor = .red
        //mainView.clipsToBounds = true
        setSizeLayout(withConstant: size)
    }
    
    private func addButton(fromDirection direction: ElasticDirection) {
        let mainBlade = FanBlade(onView: mainView, ElasticDirection: direction)
        mainBlade.delegate = self
        mainBlade.setupBlade()
    }
    
    private func setSizeLayout(withConstant constant: CGFloat){
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthLC = mainView.widthAnchor.constraint(equalToConstant: constant)
        heightLC = mainView.heightAnchor.constraint(equalToConstant: constant)
        let leftLC = mainView.leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 10)
        let bottomLC = mainView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -50)
        NSLayoutConstraint.activate([widthLC,heightLC,leftLC,bottomLC])
    }
    
    private func handle(rootBlade blade: FanBlade) {
        heightLC.constant += size
        addButton(fromDirection: .left)
//        guard let dataSource = dataSource else { return }
//        let count = dataSource.numberOfBlades(in: self)
//        if count > 0 {
//            addButton()
//        }
    }
    
    private func handle(childBlade blade: FanBlade) {
        
    }
    
}

extension FanButton: FanBladeDelegate {
    
    func fanBlade(didSelected fanBlade: FanBlade) {
        //fanBlade.type == BladeType.root ? handle(rootBlade: fanBlade) : handle(childBlade: fanBlade)
        handle(rootBlade: fanBlade)
    }
    
    func fanBlade(didPause fanBlade: FanBlade) {
        
    }
    
    func fanBlade(didResume fanBlade: FanBlade) {
        
    }

}
