THCalendarDatePicker
===

[![Pod Version](http://img.shields.io/cocoapods/v/THCalendarDatePicker.svg?style=flat)](http://cocoadocs.org/docsets/THCalendarDatePicker/)
[![Pod Platform](http://img.shields.io/cocoapods/p/THCalendarDatePicker.svg?style=flat)](http://cocoadocs.org/docsets/THCalendarDatePicker/)
[![Pod License](http://img.shields.io/cocoapods/l/THCalendarDatePicker.svg?style=flat)](http://opensource.org/licenses/MIT)

This control is based on the [datepicker-ios](https://github.com/ccwasden/datepicker-ios) control combined with the [KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController).

The original controller was not aware of orientation changes and was missing some customization features that I needed for my project, so I decided to rewrite part of the controller to fit to my needs

# Screenshots

![iPhone Portrait](/Screenshots/Screenshot1.png?raw=true)
![iPhone Landscape](/Screenshots/Screenshot2.png?raw=true)

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

``` ruby
platform :ios, '6.1'
pod 'THCalendarDatePicker', '~> 0.2.8'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

Or copy the `THCalendarDatePicker/` directory from this repo into your project.

# Usage

This is a sample initialization taken from the ExampleProject.

```objective-c
- (IBAction)touchedButton:(id)sender {
    if(!self.datePicker)
        self.datePicker = [THDatePickerViewController datePicker];
    self.datePicker.date = self.curDate;
    self.datePicker.delegate = self;
    [self.datePicker setAllowClearDate:NO];
    [self.datePicker setClearAsToday:YES];
    [self.datePicker setAutoCloseOnSelectDate:YES];
    [self.datePicker setAllowSelectionOfSelectedDate:YES];
    [self.datePicker setDisableHistorySelection:YES];
    [self.datePicker setDisableFutureSelection:NO];
    [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
    [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];

    [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
     int tmp = (arc4random() % 30)+1;
     if(tmp % 5 == 0)
     return YES;
     return NO;
     }];
    //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
    [self presentSemiViewController:self.datePicker withOptions:@{
                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
                                                                  }];
}

```

# Features

### V0.2.X

- Fixed issue [#18](https://github.com/hons82/THCalendarDatePicker/issues/18) 
- Fixed issue [#17](https://github.com/hons82/THCalendarDatePicker/issues/17) 
- Fixed issue [#16](https://github.com/hons82/THCalendarDatePicker/issues/16) 
- Fixed issue [#15](https://github.com/hons82/THCalendarDatePicker/issues/15) 
- Pull request [#13](https://github.com/hons82/THCalendarDatePicker/pull/13)
- iOS8 deprecation warnings removed
- Fixed issue [#12](https://github.com/hons82/THCalendarDatePicker/issues/12) 
- Fixed issue [#11](https://github.com/hons82/THCalendarDatePicker/issues/11) 
- Fixed issue [#7](https://github.com/hons82/THCalendarDatePicker/issues/7) 
- Fixed issue [#5](https://github.com/hons82/THCalendarDatePicker/issues/5) 

### V0.1.X

- Bugfix (Now it's taking the default starting day for the locale; but not the custom setting "Week starts on")
- Configurable if it should show future entries 
- Select a Date from Calendar
- Awareness of the setting 4 the first weekday
- Configurable Colors
- Configurable if it should be allowed to clear the selection
- Configurable if it should close on selection or not

### Future

- reduce size of control if "hasItemCallback" is not used/disabled

#Contributions

...are really welcome. If you have an idea just fork the library change it and if its useful for others and not affecting the functionality of the library for other users I'll insert it

###Contributors

- [Mikko Koppanen](https://github.com/mkoppanen)
- [Kirill Pahnev](https://github.com/pahnev)

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).