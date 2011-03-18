//
//  TWXNSDate.h
//
//  Copyright 2011 Trollwerks Inc. All rights reserved.
//

enum
{
   kYearDays = 365,
   kLeapYearDays = 366,
   kLeapDayArrayIndex = 59,
   kLeapDayOfYear = 60,
};

@interface NSDate (TWXNSDate)

+ (NSDate *)dayOfCurrentGregorianYear:(NSInteger)zeroBasedDay;

- (NSUInteger)dayOfYearGregorian;

- (BOOL)isLeapYear;
- (NSUInteger)getDaysInYearGregorian;
- (NSUInteger)getDaysInYear:(NSCalendar *)c;

@end

