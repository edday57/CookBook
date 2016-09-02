//
//  NoPasteTextField.swift
//  CookBook
//
//  Created by Edward Day on 02/09/2016.
//  Copyright © 2016 Edward Day. All rights reserved.
//

import UIKit
import Foundation

class NoPasteTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}
