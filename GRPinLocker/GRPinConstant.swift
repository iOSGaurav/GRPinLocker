//
//  GRPinConstant.swift
//  GRPinLocker
//
//  Created by Gaurav Parmar on 07/05/22.
//

import Foundation

public enum GRPinConstant {
    static let kStoryboard = "GRPin"
    static let kViewController = "GRPinViewController"
    static let kPincode = "userPinCode"
    static let kLocalizedReason = "Unlock with sensor"
    static let duration = 0.3 // Duration of indicator filling
    static let maxPinLength = 4
    
    enum button: Int {
        case delete = 1000
        case cancel = 1001
    }
}

