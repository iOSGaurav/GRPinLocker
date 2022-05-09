//
//  GRConfig.swift
//  GRPinLocker
//
//  Created by Gaurav Parmar on 07/05/22.
//

import Foundation
import UIKit

public enum GRShapeStyle {
    case rounded
    case square
    case none
}


public struct GRConfig {
    public init() {}
    public var title: String?
    public var titleColor : UIColor?
    public var titleFont : UIFont?
    public var subtitleColor : UIColor?
    public var subtitleFont : UIFont?
    public var backgroundImage : UIImage?
    public var backgroundColor : UIColor?
    public var doUseLocalAuthentication: Bool?
    public var mode : GRMode?
    public var imageConfig : GRImageConfig?
    public var delegate : GRPInValidateDelegate?
}

public struct GRImageConfig {
    public init() {}
    public var displayImage: Bool?
    public var image : UIImage?
    public var style : GRShapeStyle = .rounded
    public var borderWidth : CGFloat?
    public var borderColor : UIColor?
}
