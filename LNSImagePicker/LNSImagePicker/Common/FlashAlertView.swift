//
//  FlashAlertView.swift
//  LNSImagePicker
//
//  Created by linus on 5/24/19.
//  Copyright © 2019 linus. All rights reserved.
//

import UIKit

class FlashAlertView: UIAlertView {
    fileprivate var flashTime: TimeInterval = 1.25
    
    init(message: String, delegate: UIAlertViewDelegate? = nil) {
        self.init(title: nil, message: message, delegate: delegate, cancelButtonTitle: nil)
    }
    
    init(message: String, delegate: UIAlertViewDelegate? = nil, flashTime: TimeInterval) {
        self.init(title: nil, message: message, delegate: delegate, cancelButtonTitle: nil)
        self.flashTime = flashTime
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func show() {
        DispatchQueue.main.async(execute: {
            super.show()
            Timer.scheduledTimer(timeInterval: self.flashTime, target: self, selector: #selector(FlashAlertView.hideAlertView), userInfo: nil, repeats: false)
        })
    }
    
    @objc func hideAlertView() {
        self.dismiss(withClickedButtonIndex: 0, animated: true)
    }
}
