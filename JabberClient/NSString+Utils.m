//
//  NSString+Utils.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 1/2/15.
//  Copyright (c) 2015 Organization. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+ (NSString *)getCurrentTime{
    NSDate *nowUTC = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];

    return [dateFormatter stringFromDate:nowUTC];
}

@end
