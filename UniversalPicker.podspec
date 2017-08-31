
Pod::Spec.new do |s|
  s.name         = "UniversalPicker"
  s.version      = "1.0.2"
  s.summary      = "Universal picker for date, time and other."
  s.description  = "Universal picker that comtains date, time and other prickers."
  s.homepage     = "https://github.com/deonisiy162980"
  s.license      = "MIT"
  s.author       = "Denis Petrov"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/deonisiy162980/UniversalPicker.git", :tag => "1.0.2" }
  s.source_files = "UniversalPicker", "UniversalPicker/**/*.{h,m,swift,xib}"
  s.resources    = "UniversalPicker/PickerView.xib"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
