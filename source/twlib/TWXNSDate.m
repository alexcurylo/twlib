//
//  TWXNSDate.m
//
//  Copyright 2011 Trollwerks Inc. All rights reserved.
//

#import "TWXNSDate.h"

@implementation NSDate (TWXNSDate)

// http://stackoverflow.com/questions/3725690/nsdate-for-first-day-of-the-month

+ (NSDate *)dayOfCurrentGregorianYear:(NSInteger)zeroBasedDay
{
   NSCalendar *gregorian = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
   //NSDateComponents* firstDayComps = [[[NSDateComponents alloc] init] autorelease];
   NSDateComponents *yearAndDay = [gregorian components:(NSYearCalendarUnit | /*NSMonthCalendarUnit |*/ NSDayCalendarUnit) fromDate:[NSDate date]];
   [yearAndDay setDay:zeroBasedDay + 1];
   NSDate *dayOfYearDate = [gregorian dateFromComponents:yearAndDay];
   return dayOfYearDate;
}

- (NSUInteger)dayOfYearGregorian
{
   NSCalendar *gregorian = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
   NSDateComponents *firstDayComps = [gregorian components:(NSYearCalendarUnit | /*NSMonthCalendarUnit |*/ NSDayCalendarUnit) fromDate:[NSDate date]];
   [firstDayComps setDay:1];
   NSDate* firstDayDate = [gregorian dateFromComponents:firstDayComps];

   NSDateComponents* diffComps = [gregorian components:NSDayCalendarUnit 
                                      fromDate:firstDayDate
                                        toDate:self
                                       options:0];
   NSUInteger dayOfYearGregorian = diffComps.day + 1;
   return dayOfYearGregorian;
}

// http://stackoverflow.com/questions/2078372/how-do-i-calculate-the-number-of-days-in-this-year-in-objective-c

- (BOOL)isLeapYear
{
   /*
    if ((year % 4 is 0) && (year % 100 != 0) || (year % 400 == 0))
    then 366 // Leap Year
    else
    365 // Non-Leap Year
    */
   NSInteger yearDays = self.getDaysInYearGregorian;
   BOOL isLeapYear = kLeapYearDays == yearDays;
   twcheck(isLeapYear || (kYearDays == yearDays));
   return isLeapYear;
}

- (NSUInteger)getDaysInYearGregorian
{
   NSCalendar *gregorian = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSGregorianCalendar];
   return [self getDaysInYear:gregorian];
}

- (NSUInteger)getDaysInYear:(NSCalendar *)c
{
   // Get the current calendar
   if (!c)
      c = [NSCalendar currentCalendar];
   
   // Find the range for days and months in this calendar
   NSRange dayRange = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
   NSRange monthRange = [c rangeOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:self];
   
   // Get the year from the suppled date
   NSDateComponents* yearComps = [c components:NSYearCalendarUnit fromDate:self];
   NSInteger thisYear = [yearComps year];
   
   // Create the first day of the year in the current calendar
   NSUInteger firstDay = dayRange.location;
   NSUInteger firstMonth = monthRange.location;
   NSDateComponents* firstDayComps = [[[NSDateComponents alloc] init] autorelease];
   [firstDayComps setDay:firstDay];
   [firstDayComps setMonth:firstMonth];
   [firstDayComps setYear:thisYear];
   NSDate* firstDayDate = [c dateFromComponents:firstDayComps];
   
   // Create the last day of the year in the current calendar
   NSUInteger lastDay = dayRange.length;
   NSUInteger lastMonth = monthRange.length;
   NSDateComponents* lastDayComps = [[[NSDateComponents alloc] init] autorelease];
   [lastDayComps setDay:lastDay];
   [lastDayComps setMonth:lastMonth];
   [lastDayComps setYear:thisYear];
   NSDate* lastDayDate = [c dateFromComponents:lastDayComps];
   
   // Find the difference in days between the first and last days of the year
   NSDateComponents* diffComps = [c components:NSDayCalendarUnit 
                                      fromDate:firstDayDate
                                        toDate:lastDayDate
                                       options:0];
   
   // We have to add one since this was subtraction but we really want to
   // give the total days in the year
   return [diffComps day] + 1;
}

@end
