Pod::Spec.new do |s|
  s.name             = 'GRPinLocker'
  s.version          = '0.1.0'
  s.summary          = 'A short description of GRPinLocker.'

  s.homepage         = 'https://github.com/iOSGaurav/GRPinLocker'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'Gaurav Parmar' => 'parmargaurav069@gmail.com' }
  s.source           = { :git => 'https://github.com/iOSGaurav/GRPinLocker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'GRPinLocker/**/*'
end