//
//  NSString+Addons.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "NSString+Addons.h"


@implementation NSString (Addons)

+ (NSString *)stringForJSBoolean:(BOOL)boolValue
{
    return boolValue ? @"true" : @"false";
}


+ (NSString *)stringFromVideoIdArray:(NSArray *)videoIds
{
    NSMutableArray *formattedVideoIds = [[NSMutableArray alloc] init];
    
    for (id unformattedId in videoIds)
    {
        [formattedVideoIds addObject:[NSString stringWithFormat:@"'%@'", unformattedId]];
    }
    
    return [NSString stringWithFormat:@"[%@]", [formattedVideoIds componentsJoinedByString:@", "]];
}

@end
