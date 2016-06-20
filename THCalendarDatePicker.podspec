Pod::Spec.new do |s|
  s.name         		= "THCalendarDatePicker"
  s.version      		= "1.2.8"
  s.summary      		= "A DatePicker based on a custom calendar view"
  s.homepage     		= "https://github.com/hons82/THCalendarDatePicker"
  s.license      		= { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       		= { "Hannes Tribus" => "hons82@gmail.com" }
  s.source       		= { :git => "https://github.com/hons82/THCalendarDatePicker.git", :tag => "v#{s.version}" }
  s.platform     		= :ios, '6.1'
  s.requires_arc 		= true
  s.header_mappings_dir	= 'THCalendarDatePicker'
  s.source_files 		= 'THCalendarDatePicker/*.{h,m}'
  s.resources 	 		= ["THCalendarDatePicker/*.xib", "THCalendarDatePicker/Images.xcassets"]
  s.frameworks   	 	=  'QuartzCore'
  s.dependency 			'KNSemiModalViewController_hons82', '~> 0.4.5'
  s.prefix_header_contents = <<-EOS
	  #define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
	  #define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
	  #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
	  #define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
	  #define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
    EOS
end
