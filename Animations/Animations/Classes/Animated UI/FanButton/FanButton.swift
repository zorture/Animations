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
    //func fanButton(_ fanButton: FanButton, fanBladeForRowAt index: Int) -> FanBlade
}

class FanButton: UIView {
    
    
    var bottomLC: NSLayoutConstraint!
    var heightLC: NSLayoutConstraint!
    let size: CGFloat = 70
    var dataSource: FanButtonDataSource? {
        didSet {
           print("Did Set DataSource")
        }
    }
    var delegate: FanButtonDelegate? {
        didSet {
           print("Did Set Delegate")
        }
    }

    fileprivate var mainBlade: FanBlade!
    fileprivate let time = 0.3
    fileprivate var bladeIndexCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        setupFanButton()
    }
    
    fileprivate func setupFanButton() {
        backgroundColor = .red
        //clipsToBounds = true
        setSizeLayout(withConstant: size)
        addRootButton(fromDirection: .bottom)
    }

    
    private func addRootButton(fromDirection direction: ElasticDirection) {
        mainBlade = FanBlade(atIndex: bladeIndexCount)
        mainBlade.backgroundColor = .orange
        mainBlade.direction = .bottom
        mainBlade.delegate = self
        self.addSubview(mainBlade)
    }
    
    private func addButton(withBottomBlade blade: FanBlade, atIndex index: Int) -> FanBlade {
        let blade = FanBlade(withBottomBlade: blade, atIndex: index)
        blade.backgroundColor = .green
        blade.delegate = self
        self.addSubview(blade)
        return blade
    }
    
    private func setSizeLayout(withConstant constant: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        let widthLC = widthAnchor.constraint(equalToConstant: constant)
        heightLC = heightAnchor.constraint(equalToConstant: constant)
        NSLayoutConstraint.activate([widthLC,heightLC])
    }
    
    private func handle(rootBlade fanblade: FanBlade) {

        let count = dataSource?.numberOfBlades(in: self) ?? 0
        self.heightLC.constant += self.size * CGFloat(count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            guard var blade = self.mainBlade else { return }
            for _ in 0..<count {
                self.bladeIndexCount += 1
                let newBlade = self.addButton(withBottomBlade: blade, atIndex: self.bladeIndexCount)
                blade = newBlade
            }
        })
    }
    
    private func handle(childBlade fanblade: FanBlade) {
        delegate?.fanButton(self, didSelectBlade: fanblade)
    }
}

extension FanButton: FanBladeDelegate {
    
    func fanBlade(didSelected fanBlade: FanBlade) {
        if fanBlade.index == 0 {
             handle(rootBlade: fanBlade)
        } else {
            handle(childBlade: fanBlade)
        }
    }
    
    func fanBlade(didPause fanBlade: FanBlade) {
        
    }
    
    func fanBlade(didResume fanBlade: FanBlade) {
        
    }

}
