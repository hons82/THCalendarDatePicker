//
//  THDatePickerViewController.h
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <KNSemiModalViewController/UIViewController+KNSemiModal.h>

#import "THDateDay.h"

@class THDatePickerViewController;
@protocol THDatePickerDelegate <NSObject>
-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker;
-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker;
@end

@interface THDatePickerViewController : UIViewController <THDateDayDelegate>

+(THDatePickerViewController *)datePicker;

@property (strong, nonatomic) NSDate * date;
@property (weak, nonatomic) id<THDatePickerDelegate> delegate;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *currentDateColor;

- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback;
- (void)setAllowClearDate:(BOOL)allow;
- (void)setAutoCloseOnSelectDate:(BOOL)autoClose;
- (void)setDisableFutureSelection:(BOOL)disableFutureSelection;

@end
