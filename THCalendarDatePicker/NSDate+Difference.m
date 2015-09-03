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
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

- (NSInteger)daysFromDate:(NSDate *)pDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger startDay=[calendar ordinalityOfUnit:NSDayCalendarUnit
                                           inUnit:NSEraCalendarUnit
                                          forDate:self];
    NSInteger endDay=[calendar ordinalityOfUnit:NSDayCalendarUnit
                                         inUnit:NSEraCalendarUnit
                                        forDate:pDate];
    return labs(endDay-startDay);
}

@end
