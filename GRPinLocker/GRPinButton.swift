//
//  GRPinButton.swift
//  GRPinLocker
//
//  Created by Gaurav Parmar on 07/05/22.
//

import UIKit

open class GRPinButton: UIButton {
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawCircle(rect)
    }
}
