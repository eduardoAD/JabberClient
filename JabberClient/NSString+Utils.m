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

- (NSString *) substituteEmoticons {
    //See http://www.easyapns.com/iphone-emoji-alerts for a list of emoticons available
    NSString *res = [self stringByReplacingOccurrencesOfString:@":)" withString:@"\ue415"];
    res = [res stringByReplacingOccurrencesOfString:@":(" withString:@"\ue403"];
    res = [res stringByReplacingOccurrencesOfString:@";-)" withString:@"\ue405"];
    res = [res stringByReplacingOccurrencesOfString:@":-x" withString:@"\ue418"];
    return res;
}

@end
