# GRPinLocker

GRPinLocker is use for the User Authentication for accessing application information. Main use of GRPinLocker can be done in Banking, Wallets etc.

### Modes
```swift
enum GRMode {
  case validate
  case change
  case deactive
  case create
}
```

### Configuration
```swift
struct GRConfig {
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
```
### Delegate
Simple Callback Delegate for all type of operation
```swift
func didSuccessfull(_ viewController : GRPinViewController,with mode: GRMode,of pin : String)
func didFailed(_ viewController: GRPinViewController, with mode: GRMode)
func didDismiss(_ viewController : GRPinViewController)
```

### Example
#### Simple call of controller
```swift
var config =  GRConfig()
config.backgroundColor = .red
config.title = "Example"
config.titleColor = .blue
config.subtitleColor = .blue
config.mode = .create // validate, deactive, change
config.delegate = self

GRPinViewController.present(with: config)
```

## Requirements
GRPinLocker is written in Swift 5.0. iOS 11.0+ Required

## CocoaPods
```
  pod 'GRPinLocker'
```


## Author

Gaurav Parmar, parmargaurav069@gmail.com

## Inspired
https://github.com/Ryasnoy/AppLocker
