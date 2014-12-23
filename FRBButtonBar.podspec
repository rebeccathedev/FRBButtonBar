Pod::Spec.new do |spec|
    spec.name         = 'FRBButtonBar'
    spec.platform     = :osx, "10.9"
    spec.version      = '0.1'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/peckrob/FRBButtonBar'
    spec.authors      = { 'Rob Peck' => 'rob@robpeck.com' }
    spec.summary      = 'A button bar designed to resemble Safari\'s bookmarks bar in behavior and appearance.'
    spec.source       = { :git => 'https://github.com/peckrob/FRBButtonBar', :tag => 'v0.1' }
    spec.requires_arc = true
    spec.source_files = 'FRBButtonBar'
    spec.resources    = 'Resources/**'
end