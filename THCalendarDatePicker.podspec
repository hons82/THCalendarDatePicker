Pod::Spec.new do |s|
  s.name         	= "THCalendarDatePicker"
  s.version      	= "0.0.1"
  s.summary      	= "UITextView with the look of a Notebook"
  s.homepage     	= "https://github.com/hons82/THCalendarDatePicker"
  s.license      	= { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       	= { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       	= { :git => "https://github.com/hons82/THCalendarDatePicker.git", :tag => "v0.0.1" }
  s.platform     	= :ios, '6.1'
  s.requires_arc 	= true
  s.source_files 	= 'THCalendarDatePicker/*.{h,m}'
  s.resources 	 	= ["THCalendarDatePicker/Images/*.png"]
  s.frameworks   	=  'QuartzCore'
  s.dependency 		'KNSemiModalViewController', '~> 0.3'
end