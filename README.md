THCalendarDatePicker
===

[![Build Status](https://travis-ci.org/hons82/THCalendarDatePicker.png)](https://travis-ci.org/hons82/THCalendarDatePicker)
[![Pod Version](http://img.shields.io/cocoapods/v/THCalendarDatePicker.svg?style=flat)](http://cocoadocs.org/docsets/THCalendarDatePicker/)
[![Pod Platform](http://img.shields.io/cocoapods/p/THCalendarDatePicker.svg?style=flat)](http://cocoadocs.org/docsets/THCalendarDatePicker/)
[![Pod License](http://img.shields.io/cocoapods/l/THCalendarDatePicker.svg?style=flat)](http://opensource.org/licenses/MIT)
[![Coverage Status](https://coveralls.io/repos/hons82/THCalendarDatePicker/badge.svg)](https://coveralls.io/r/hons82/THCalendarDatePicker)

This control is based on the [datepicker-ios](https://github.com/ccwasden/datepicker-ios) control combined with the [KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController).

The original controller was not aware of orientation changes and was missing some customization features that I needed for my project, so I decided to rewrite part of the controller to fit to my needs

# Screenshots

![iPhone Portrait](/Screenshots/Screenshot1.png?raw=true)
![iPhone Landscape](/Screenshots/Screenshot2.png?raw=true)

# Installation

### CocoaPods

Install with [CocoaPods](http://cocoapods.org) by adding the following to your Podfile:

####Objective-C

``` ruby
platform :ios, '6.1'
pod 'THCalendarDatePicker', '~> 1.2.6'
```
####Swift

``` ruby
platform :ios, '8.0'
use_frameworks!
pod 'THCalendarDatePicker', '~> 1.2.6'
```

**Note**: We follow http://semver.org for versioning the public API.

### Manually

Or copy the `THCalendarDatePicker/` directory from this repo into your project. As it is using the [KNSemiModalViewController](https://github.com/kentnguyen/KNSemiModalViewController) internally as dependency you'll need to add and wire those files as well.

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

or how you could do it in Swift

```Swift
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellowColor()
        return dp
    }()

    @IBAction func dateButtonTouched(sender: AnyObject) {
        datePicker.date = curDate
        datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        presentSemiViewController(datePicker, withOptions: [
            KNSemiModalOptionKeys.pushParentBack    : NSNumber(bool: false),
            KNSemiModalOptionKeys.animationDuration : NSNumber(float: 1.0),
            KNSemiModalOptionKeys.shadowOpacity     : NSNumber(float: 0.3)
            ])
    }
```

# Features

### V1.2.X

- Fixed issue [#28](https://github.com/hons82/THCalendarDatePicker/issues/28)
- Fixed issue [#30](https://github.com/hons82/THCalendarDatePicker/issues/30)
- Fixed issue [#69](https://github.com/hons82/THCalendarDatePicker/issues/69)
- Fixed issue [#71](https://github.com/hons82/THCalendarDatePicker/issues/71)
- Pull request [#40](https://github.com/hons82/THCalendarDatePicker/pull/40)
- Pull request [#41](https://github.com/hons82/THCalendarDatePicker/pull/41)
- Pull request [#53](https://github.com/hons82/THCalendarDatePicker/pull/53) 
- Pull request [#70](https://github.com/hons82/THCalendarDatePicker/pull/70) 

### V1.1.X

- Fixed issue [#29](https://github.com/hons82/THCalendarDatePicker/issues/29)
- Fixed issue [#27](https://github.com/hons82/THCalendarDatePicker/issues/27)

### V1.0.X

- Fixed issue [#23](https://github.com/hons82/THCalendarDatePicker/issues/23) 
- Fixed issue [#22](https://github.com/hons82/THCalendarDatePicker/issues/22) 
- Pull request [#21](https://github.com/hons82/THCalendarDatePicker/pull/21), [#20](https://github.com/hons82/THCalendarDatePicker/pull/20) 
- Fixed issues [#18](https://github.com/hons82/THCalendarDatePicker/issues/18), [#17](https://github.com/hons82/THCalendarDatePicker/issues/17), [#16](https://github.com/hons82/THCalendarDatePicker/issues/16), [#15](https://github.com/hons82/THCalendarDatePicker/issues/15) 
- Pull request [#13](https://github.com/hons82/THCalendarDatePicker/pull/13)
- iOS8 deprecation warnings removed
- Fixed issues [#12](https://github.com/hons82/THCalendarDatePicker/issues/12), [#11](https://github.com/hons82/THCalendarDatePicker/issues/11), [#7](https://github.com/hons82/THCalendarDatePicker/issues/7), [#5](https://github.com/hons82/THCalendarDatePicker/issues/5) 
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
- [jeremiescheer](https://github.com/jeremiescheer)
- [powfulhong](https://github.com/powfulhong)
- [sparkdreamstudio](https://github.com/sparkdreamstudio)
- [Ignacio pascualin](https://github.com/pascualin)

# License

Source code of this project is available under the standard MIT license. Please see [the license file](LICENSE.md).