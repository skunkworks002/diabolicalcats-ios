//
//  NSString+Addons.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Addons)

/**
 This method to convert a Objective-C BOOL value to JS boolean value.
 
 @param boolValue
 Objective-C BOOL value.
 
 @return
 JavaScript Boolean value, i.e. "true" or "false".
 */
+ (NSString *)stringForJSBoolean:(BOOL)boolValue;


/**
 This method for converting an NSArray of video IDs into its JavaScript equivalent.
 
 @param videoIds 
    An array of video ID strings to convert into JavaScript format.

 @return 
    A JavaScript array in String format containing video IDs.
 */
+ (NSString *)stringFromVideoIdArray:(NSArray *)videoIds;


@end
