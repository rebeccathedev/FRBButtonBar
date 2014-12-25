Pod::Spec.new do |spec|
    spec.name         = 'FRBButtonBar'
    spec.platform     = :osx, "10.9"
    spec.version      = '0.1'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/peckrob/FRBButtonBar'
    spec.authors      = { 'Rob Peck' => 'rob@robpeck.com' }
    spec.summary      = 'A button bar designed to resemble Safari\'s bookmarks bar in behavior and appearance.'
    spec.source       = { :git => 'https://github.com/peckrob/FRBButtonBar.git', :tag => 'v0.1' }
    spec.requires_arc = true
    spec.public_header_files = "FRBButtonBar/FRBButtonBar.h", "FRBButtonBar/FRBButtonBarProtocols.h", "FRBButtonBar/FRBButtonBarItem.h", "FRBButtonBar/FRBButtonBarControl.h"
    spec.source_files = "FRBButtonBar/*.{h,m}"
    spec.resources    = "FRBButtonBar/*.pdf"
    spec.frameworks   = 'Foundation', 'Cocoa'
end