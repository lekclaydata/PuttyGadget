//
//  PGUtil.m
//  PuttyGadget
//
//  Created by Frank An on 22/05/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "PGUtil.h"

@implementation PGUtil

+(NSString *)getDateTime:(NSString *)format
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:[NSDate date]];

}

+(NSString*)getAMPM
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"a"];
    return [dateFormatter stringFromDate:[NSDate date]];

}

@end
