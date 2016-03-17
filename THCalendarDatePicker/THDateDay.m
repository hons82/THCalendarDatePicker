//
//  THDateDay.m
//  THCalendarDatePicker
//
//  Created by chase wasden on 2/10/13.
//  Adapted by Hannes Tribus on 31/07/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//


#import "THDateDay.h"

#import <QuartzCore/QuartzCore.h>

@implementation THDateDay

@synthesize selectedBackgroundColor = _selectedBackgroundColor;
@synthesize currentDateColor = _currentDateColor;
@synthesize currentDateColorSelected = _currentDateColorSelected;
@synthesize rounded = _rounded;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _selectedBackgroundColor = [UIColor colorWithRed:89/255.0 green:118/255.0 blue:169/255.0 alpha:1];
        _currentDateColor = [UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0];
        _currentDateColorSelected = [UIColor whiteColor];
        _rounded = NO;
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = MIN(self.layer.frame.size.height, self.layer.frame.size.width)/2; // this value vary as per your desire
    self.clipsToBounds = YES;
}*/

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self isRounded]) {
        [self addMaskToBounds:self.frame];
    }
}

#pragma mark -

-(void)setLightText:(BOOL)light {
    if(light) {
        UIColor * color = [UIColor colorWithWhite:.84 alpha:1];
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        self.hasItemsIndicator.image = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [UIImage imageNamed:@"calendar_littledot-disabled" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] : [UIImage imageNamed:@"calendar_littledot-disabled"]);
    } else {
        UIColor * color = [UIColor colorWithWhite:.3 alpha:1];
        [self.dateButton setTitleColor:color forState:UIControlStateNormal];
        self.hasItemsIndicator.image = (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") ? [UIImage imageNamed:@"calendar_littledot" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil] : [UIImage imageNamed:@"calendar_littledot"]);
    }
    [self setCurrentColors];
}

- (IBAction)dateButtonTapped:(id)sender {
    [self.delegate dateDayTapped:self];
}

-(void)setSelected:(BOOL)selected {
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
    [self setCurrentColors];
}

- (void)setCurrentColors {
    if (self.currentDateColor && [self isToday]) {
        [self.dateButton setTitleColor:self.currentDateColor forState:UIControlStateNormal];
    }
    if (self.currentDateColorSelected && [self isToday]) {
        [self.dateButton setTitleColor:self.currentDateColorSelected forState:UIControlStateSelected];
    }
}

-(void)setEnabled:(BOOL)enabled {
    [self.dateButton setEnabled:enabled];
    if (!enabled) {
        [self setLightText:!enabled];
    }
}

-(void)indicateDayHasItems:(BOOL)indicate {
    self.hasItemsIndicator.hidden = !indicate;
}

- (BOOL)isToday {
    NSDateComponents *otherDay = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self.date];
    NSDateComponents *today = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    return ([today day] == [otherDay day] &&
            [today month] == [otherDay month] &&
            [today year] == [otherDay year] &&
            [today era] == [otherDay era]);
}

#pragma mark - Circular mask

- (void)addMaskToBounds:(CGRect)maskBounds {
    int minWidthHeight = MIN(maskBounds.size.width, maskBounds.size.height);
    CGRect newFrame = CGRectMake(maskBounds.origin.x + ceil((maskBounds.size.width - minWidthHeight)/2.0), maskBounds.origin.y + ceil((maskBounds.size.height - minWidthHeight)/2.0), minWidthHeight, minWidthHeight);
    NSLog(@"x: %f, y: %f, width: %f, height: %f", newFrame.origin.x, newFrame.origin.y, newFrame.size.width, newFrame.size.height);
    
    CGPathRef maskPath = CGPathCreateWithEllipseInRect(newFrame, NULL);
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.bounds = newFrame;
    maskLayer.path = maskPath;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    CGPathRelease(maskPath);
    
    CGPoint point = CGPointMake(maskBounds.size.width/2, maskBounds.size.height/2);
    maskLayer.position = point;
    
    [self.layer setMask:maskLayer];
}

@end
