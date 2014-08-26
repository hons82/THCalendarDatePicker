Pod::Spec.new do |s|
  s.name         	= "THCalendarDatePicker"
  s.version      	= "0.0.2"
  s.summary      	= "UITextView with the look of a Notebook"
  s.homepage     	= "https://github.com/hons82/THCalendarDatePicker"
  s.license      	= { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       	= { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       	= { :git => "https://github.com/hons82/THCalendarDatePicker.git", :tag => "v#{s.version}" }
  s.platform     	= :ios, '6.1'
  s.requires_arc 	= true
  s.source_files 	= 'THCalendarDatePicker/*.{h,m}'
  s.resources 	 	= ["THCalendarDatePicker/Images/*.png",
                      "THCalendarDatePicker/*.xib"]
  s.frameworks   	=  'QuartzCore'
  s.dependency 		'KNSemiModalViewController', '~> 0.3'
end