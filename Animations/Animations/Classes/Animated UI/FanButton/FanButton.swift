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
    fileprivate var mainBlade: FanBlade!
    fileprivate let time = 0.3

    init(onView view: UIView) {
        parentView = view
        mainView = UIView.init(frame: .zero)
        parentView.addSubview(mainView)
        setupFanButton()
    }

    private func setupFanButton() {
        setupMainView()
        addRootButton(fromDirection: .bottom)
    }
    
    //common func to init our view
    private func setupMainView() {
        mainView.backgroundColor = .red
        //mainView.clipsToBounds = true
        setSizeLayout(withConstant: size)
    }
    
    private func addRootButton(fromDirection direction: ElasticDirection) {
        mainBlade = FanBlade(onView: mainView, ElasticDirection: direction)
        mainBlade.backgroundColor = .orange
        mainBlade.delegate = self
        mainBlade.setupBlade()
    }
    
    private func addButton(withBottomBlade blade: FanBlade, fromDirection direction: ElasticDirection) -> FanBlade {
        let blade = FanBlade(onView: mainView, withBottomBlade: blade, fromElasticDirection: direction)
        blade.backgroundColor = .green
        blade.delegate = self
        blade.setupBlade()
        return blade
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

        let count = dataSource?.numberOfBlades(in: self) ?? 0
        self.heightLC.constant += self.size * CGFloat(count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            var blade = self.mainBlade
            for _ in 0..<count {
                let newBlade = self.addButton(withBottomBlade: blade!, fromDirection: .right)
                blade = newBlade
            }
        })
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
