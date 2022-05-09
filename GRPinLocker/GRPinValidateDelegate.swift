//
//  GRPinValidateDelegate.swift
//  GRPinLocker
//
//  Created by Gaurav Parmar on 09/05/22.
//

import Foundation


public protocol GRPInValidateDelegate : NSObject {
    func didSuccessfull(_ viewController : GRPinViewController,with mode: GRMode,of pin : String)
    func didFailed(_ viewController: GRPinViewController, with mode: GRMode)
    func didDismiss(_ viewController : GRPinViewController)
}
