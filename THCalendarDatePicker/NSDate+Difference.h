//
//  NSDate+Difference.h
//  Pods
//
//  Created by Hannes Tribus on 03/09/15.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Difference)

- (NSDate *)dateWithOutTime;
- (NSInteger)daysFromDate:(NSDate *)pDate;

@end
