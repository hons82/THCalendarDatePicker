//
//  NSDate+Difference.m
//  Pods
//
//  Created by Hannes Tribus on 03/09/15.
//
//

#import "NSDate+Difference.h"

@implementation NSDate (Difference)

- (NSDate *)dateWithOutTime {
    NSDateComponents* comps = [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:comps];
}

- (NSInteger)daysFromDate:(NSDate *)pDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger startDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitEra
                                          forDate:self];
    NSInteger endDay=[calendar ordinalityOfUnit:NSCalendarUnitDay
                                         inUnit:NSCalendarUnitEra
                                        forDate:pDate];
    return labs(endDay-startDay);
}

@end
