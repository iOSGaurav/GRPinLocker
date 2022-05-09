//
//  GRPinViewController.swift
//  GRPinLocker
//
//  Created by Gaurav Parmar on 07/05/22.
//

import UIKit
import AudioToolbox

public class GRPinViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var lblTitle : UILabel!
    @IBOutlet private weak var lblSubTitle : UILabel!
    @IBOutlet private weak var imgBackground : UIImageView!
    @IBOutlet private weak var imgTop : UIImageView!
    @IBOutlet private var pinInput: [GRPinInputView]!
    
    // MARK: - Local Variables
    fileprivate var config : GRConfig?
    private var imgConfig : GRImageConfig? {
        didSet {
            guard let conf = imgConfig else {
                self.imgTop.isHidden = true
                return
            }
            self.setTopImage(conf)
        }
    }
    
    // MARK: - Local Storage Variables
    private var enteredPin = ""
    private var storedPin = ""
    private var currentStep : GRSteps = .new
    
    private enum GRSteps {
        case new
        case confirm
    }
    
    // MARK: - Delegate
    public weak var delegate : GRPInValidateDelegate?
    
    // This Variable is use to set the title message
    private var titleMessage : String? {
        get {
            return self.lblTitle.text ?? ""
        }
        set {
            guard let newValue = newValue else { return }
            self.lblTitle.text = newValue
        }
    }
    
    private var titleMessageColor : UIColor? = .black {
        didSet {
            self.lblTitle.textColor = titleMessageColor
        }
    }
    
    // This variable is use to set the subtitle message
    private var subTitleMessage : String? {
        get{
            return self.lblSubTitle.text ?? ""
        }
        set {
            guard let newValue = newValue else { return }
            self.lblSubTitle.text = newValue
        }
    }
    
    private var subTitleMessageColor : UIColor? = .black {
        didSet {
            self.lblSubTitle.textColor = subTitleMessageColor
        }
    }
    
    // This variable will set the backround image as the application background image.
    private var backgroundImage : UIImage? {
        didSet {
            if let img = backgroundImage {
                self.view.backgroundColor = .clear
                self.imgBackground.image = img
                self.imgBackground.isHidden = false
            }
        }
    }
    
    // This variable will set the background color which is passed from the developer
    private var backgroundColor : UIColor? {
        didSet {
            if let color = backgroundColor {
                self.imgBackground.isHidden = true
                self.view.backgroundColor = color
            }
        }
    }
    
    private var topImage : UIImage? {
        didSet {
            self.imgTop.image = config?.imageConfig?.image
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.pinInput.forEach { view in
            view.layer.cornerRadius = view.bounds.size.height / 2
            view.clipsToBounds = true
        }
        if let con = config {
            titleMessage = con.title
            titleMessageColor = con.titleColor
            subTitleMessageColor = con.subtitleColor
            backgroundImage = con.backgroundImage
            backgroundColor = con.backgroundColor
            imgConfig = con.imageConfig
            delegate = con.delegate
        }
    }
    
    // MARK: - IBAction Methods
    @IBAction private func btnNumberPadTapped(_ sender : UIButton) {
        switch sender.tag {
        case GRPinConstant.button.delete.rawValue:
            self.drawing(isNeedClear: true)
        case GRPinConstant.button.cancel.rawValue:
            self.clearView()
        default:
            self.drawing(isNeedClear: false, tag: sender.tag)
        }
        
    }
    
    // MARK: - Writing Methods
    private func drawing(isNeedClear: Bool, tag: Int? = nil) { // Fill or cancel fill for indicators
        let results = pinInput.filter { $0.isNeedClear == isNeedClear }
        let pinView = isNeedClear ? results.last : results.first
        pinView?.isNeedClear = !isNeedClear
        
        UIView.animate(withDuration: GRPinConstant.duration, animations: {
            pinView?.backgroundColor = isNeedClear ? .clear : .white
        }) { _ in
            isNeedClear ? self.enteredPin = String(self.enteredPin.dropLast()) : self.pincodeChecker(tag ?? 0)
        }
    }
    
    private func pincodeChecker(_ pinNumber: Int) {
        if self.enteredPin.count < GRPinConstant.maxPinLength {
            self.enteredPin.append("\(pinNumber)")
            if self.enteredPin.count == GRPinConstant.maxPinLength {
                switch self.config?.mode ?? .create {
                case .create:
                    createModeAction()
                case .change:
                    changeModeAction()
                case .deactive:
                    deactiveModeAction()
                case .validate:
                    validateModeAction()
                }
            }
        }
    }
    
    
    // MARK: - Mode Handling
    private func createModeAction() {
        if self.currentStep == .new {
            self.currentStep = .confirm
            self.storedPin = self.enteredPin
            self.clearView()
            lblSubTitle.text = "Confirm your pincode"
        } else {
            confirmPin()
        }
    }
    
    private func changeModeAction() {
        if self.enteredPin == self.storedPin {
            self.precreateSettings()
        } else {
            self.delegate?.didFailed(self, with: self.config?.mode ?? .create)
            incorrectPinAnimation()
        }
    }
    
    private func precreateSettings () {
        self.config?.mode = .create
        clearView()
    }
    
    private func deactiveModeAction() {
        if self.enteredPin == self.storedPin {
            removePin()
        } else {
            self.delegate?.didFailed(self, with: self.config?.mode ?? .create)
            incorrectPinAnimation()
        }
    }
    
    private func validateModeAction() {
        if self.enteredPin == self.storedPin {
            dismiss(animated: true) {
                self.delegate?.didSuccessfull(self, with: self.config?.mode ?? .create, of: self.enteredPin)
            }
        } else {
            self.delegate?.didFailed(self, with: self.config?.mode ?? .create)
            incorrectPinAnimation()
        }
    }
    
    private func removePin() {
        dismiss(animated: true) {
            self.delegate?.didDismiss(self)
        }
    }
    
    private func confirmPin() {
        if self.enteredPin == self.storedPin {
            self.storedPin = self.enteredPin
            dismiss(animated: true) {
                self.delegate?.didSuccessfull(self, with: self.config?.mode ?? .create, of: self.enteredPin)
            }
        } else {
            self.delegate?.didFailed(self, with: self.config?.mode ?? .create)
            incorrectPinAnimation()
        }
    }
    
    private func incorrectPinAnimation() {
        pinInput.forEach { view in
            view.shake(delegate: self)
            view.backgroundColor = .clear
        }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    fileprivate func clearView() {
        self.enteredPin = ""
        pinInput.forEach { view in
            view.isNeedClear = false
            UIView.animate(withDuration: GRPinConstant.duration, animations: {
                view.backgroundColor = .clear
            })
        }
    }
    
    
    
    // MARK: - Custom Methods
    private func setTopImage(_ config : GRImageConfig) {
        
        if let show = config.displayImage {
            self.imgTop.isHidden = !show
        }
        if let img = config.image {
            self.imgTop.image = img
        }
        
        switch config.style {
        case .rounded:
            self.setRoundedImageView(config.borderWidth ?? 0.0, withColor: config.borderColor ?? .clear)
        case .square:
            self.setSqauredImageView(config.borderWidth ?? 0.0, withColor: config.borderColor ?? .clear)
        case .none:
            self.setSqauredImageView(config.borderWidth ?? 0.0, withColor: config.borderColor ?? .clear)
        }
    }
    
    private func setSqauredImageView(_ borderWidth : CGFloat = 0,withColor borderColor : UIColor = .clear) {
        self.imgTop.layer.cornerRadius = 0
        self.imgTop.layer.borderWidth = borderWidth
        self.imgTop.layer.borderColor = borderColor.cgColor
        self.imgTop.clipsToBounds = true
    }
    
    private func setRoundedImageView(_ borderWidth : CGFloat = 0,withColor borderColor : UIColor = .clear) {
        self.imgTop.layer.cornerRadius = self.imgTop.bounds.size.height / 2
        self.imgTop.layer.borderWidth = borderWidth
        self.imgTop.layer.borderColor = borderColor.cgColor
        self.imgTop.clipsToBounds = true
    }
    
    
}

// MARK: - CAAnimationDelegate
extension GRPinViewController: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        clearView()
    }
}
// MARK: - GRPinViewController Extension
public extension GRPinViewController {
    
    class func present(with config: GRConfig, over viewController : UIViewController? = nil) {
        var window = UIWindow()
        
        if #available(iOS 13, *)
        {
            if let scene: UIScene = UIApplication.shared.connectedScenes.first
            {
                if let sceneDelegate = scene.delegate as? UIWindowSceneDelegate {
                    window = sceneDelegate.window!!
                }
            }
        }
        else
        {
            guard let appDelegate = UIApplication.shared.delegate else { fatalError() }
            window = appDelegate.window!!
        }
        
        let bundle = Bundle(identifier: "com.codeliners.GRPinLocker")
        let st = UIStoryboard.init(name: GRPinConstant.kStoryboard, bundle: bundle)
        guard let vc = st.instantiateViewController(withIdentifier: GRPinConstant.kViewController) as? GRPinViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.config = config
        
        if let tmpVc = viewController {
            tmpVc.present(vc, animated: true)
        }else {
            window.rootViewController?.present(vc, animated: true)
        }
        
    }
}
