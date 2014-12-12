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

@optional

-(void)datePicker:(THDatePickerViewController *)datePicker selectedDate:(NSDate *)selectedDate;

@end

@interface THDatePickerViewController : UIViewController <THDateDayDelegate>

+(THDatePickerViewController *)datePicker;

@property (strong, nonatomic) NSDate * date;
@property (weak, nonatomic) id<THDatePickerDelegate> delegate;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *currentDateColor;
@property (strong, nonatomic) UIColor *currentDateColorSelected;

- (void)setDateHasItemsCallback:(BOOL (^)(NSDate * date))callback;

/*! Enable Clear Date Button
 * \param allow should show "clear date" button
 */
- (void)setAllowClearDate:(BOOL)allow;

/*! Enable Ok Button when selected Date has already been selected
 * \param allow should show ok button
 */
- (void)setAllowSelectionOfSelectedDate:(BOOL)allow;

/*! Use Clear Date Button as "got to Today"
 * \param beTodayButton should use "clear date" button as today
 */
- (void)setClearAsToday:(BOOL)beTodayButton;

/*! Should the view be closed on selection of a date
 * \param autoClose should close view on selection
 */
- (void)setAutoCloseOnSelectDate:(BOOL)autoClose;

/*! Should it be possible to select dates in history
 * \param disableHistorySelection should it be possible?
 */
- (void)setDisableHistorySelection:(BOOL)disableHistorySelection;

/*! Should it be possible to select dates in future
 * \param disableFutureSelection should it be possible?
 */
- (void)setDisableFutureSelection:(BOOL)disableFutureSelection;

@end
