//
//  THDateDay.m
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//


#import "THDateDay.h"

@implementation THDateDay

@synthesize selectedBackgroundColor = _selectedBackgroundColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectedBackgroundColor = [UIColor colorWithRed:89/255.0 green:118/255.0 blue:169/255.0 alpha:1];
    }
    return self;
}

-(void)setLightText:(BOOL)light {
    if(light) {
        UIColor * color = [UIColor colorWithWhite:.84 alpha:1];
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        self.hasItemsIndicator.image = [UIImage imageNamed:@"calendar_littledot-disabled"];
    }
    else {
        UIColor * color = [UIColor colorWithWhite:.3 alpha:1];
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        self.hasItemsIndicator.image = [UIImage imageNamed:@"calendar_littledot"];
    }
}

- (IBAction)dateButtonTapped:(id)sender {
    [self.delegate dateDayTapped:self];
}

-(void)setSelected:(BOOL)selected{
    if(selected) {
        [self setBackgroundColor:self.selectedBackgroundColor];
        [self.dateButton setSelected:YES];
        [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.dateButton setSelected:NO];
        [self.dateButton setTitleColor:[UIColor colorWithWhite:.3 alpha:1] forState:UIControlStateNormal];
    }
    if (self.currentDateColor && [self isToday]) {
        [self.dateButton setTitleColor:self.currentDateColor forState:/*selected ? UIControlStateSelected :*/ UIControlStateNormal];
    }
}

-(void)indicateDayHasItems:(BOOL)indicate {
    self.hasItemsIndicator.hidden = !indicate;
}

- (BOOL)isToday
{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

@end
