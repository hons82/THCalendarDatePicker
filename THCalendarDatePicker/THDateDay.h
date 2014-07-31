//
//  THDateDay.h
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class THDateDay;

@protocol THDateDayDelegate <NSObject>
-(void)dateDayTapped:(THDateDay *)dateDay;
@end

@interface THDateDay : UIView

@property (weak, nonatomic) id<THDateDayDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) UIColor *selectedBackgroundColor;
@property (strong, nonatomic) UIColor *currentDateColor;


-(void)setLightText:(BOOL)light;
- (IBAction)dateButtonTapped:(id)sender;
-(void)setSelected:(BOOL)selected;
-(void)indicateDayHasItems:(BOOL)indicate;
@property (weak, nonatomic) IBOutlet UIImageView *hasItemsIndicator;

@end
