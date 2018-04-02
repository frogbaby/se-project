//
//  StorageUtility.m
//  MyFirstApp
//
//  Created by danping yan on 2/12/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "StorageUtility.h"

@implementation StorageUtility

+(CGFloat)screenWidth{
    return [UIScreen mainScreen].bounds.size.width;
}
+(CGFloat)screenHeight{
    return [UIScreen mainScreen].bounds.size.height;
}


+(NSNumber *)timestamp {
    
    NSDate *now = [NSDate date];
    NSTimeInterval timestampValue = [now timeIntervalSince1970];
    NSNumber *timestamp = [NSNumber numberWithLongLong:timestampValue];
    
    return timestamp;

    
}

+(NSMutableDictionary *) nowDate:(NSNumber *)timestamp {
    
    NSTimeInterval seconds = [timestamp doubleValue];
    NSDate *dateThen = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: dateThen];
    
    NSDate *localeDate = [dateThen  dateByAddingTimeInterval: interval];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    comps = [calendar components:unitFlags fromDate:localeDate];
    long weekNumber = [comps weekday];
    long day=[comps day];
    long year=[comps year];
    long month=[comps month];
    
    NSString *weekDay;
    switch (weekNumber) {
        case 1:
            weekDay=@"Sun";
            break;
        case 2:
            weekDay=@"Mon";
            break;
        case 3:
            weekDay=@"Tue";
            break;
        case 4:
            weekDay=@"Wed";
            break;
        case 5:
            weekDay=@"Thu";
            break;
        case 6:
            weekDay=@"Fri";
            break;
        case 7:
            weekDay=@"Sat";
            break;
            
        default:
            break;
    }
    
    //        long hour=[comps hour];
    //        long minute=[comps minute];
    //        long second=[comps second];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%ld", day] ,@"day",
                                       [NSString stringWithFormat:@"%@", weekDay],@"dayOfWeek",
                                       [NSString stringWithFormat:@"%ld", year],@"year",
                                       [NSString stringWithFormat:@"%ld", month],@"month",
                                       nil];
    
    return dictionary;
    

    
    
    
    
}

@end
