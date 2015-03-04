Pod::Spec.new do |s|
  s.name         		= "THCalendarDatePicker"
  s.version      		= "1.0.0"
  s.summary      		= "A DatePicker based on a custom calendar view"
  s.homepage     		= "https://github.com/hons82/THCalendarDatePicker"
  s.license      		= { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       		= { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       		= { :git => "https://github.com/hons82/THCalendarDatePicker.git", :tag => "v#{s.version}" }
  s.platform     		= :ios, '6.1'
  s.requires_arc 		= true
  s.source_files 		= 'THCalendarDatePicker/*.{h,m}'
  s.resources 	 		= ["THCalendarDatePicker/*.xib"]
  s.resource_bundles 	= {'THCalendarDatePickerImages' => ['THCalendarDatePicker/Images.xcassets']}
  s.frameworks   	 	=  'QuartzCore'
  s.dependency 			'KNSemiModalViewController', '~> 0.3'
end
