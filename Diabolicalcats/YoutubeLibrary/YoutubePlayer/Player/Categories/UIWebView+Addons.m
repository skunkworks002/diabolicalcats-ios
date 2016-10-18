//
//  UIWebView+Addons.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "UIWebView+Addons.h"


@implementation UIWebView (Addons)

- (NSString *)stringFromEvaluatingJavaScript:(NSString *)jsToExecute
{
    return [self stringByEvaluatingJavaScriptFromString:jsToExecute];
}

@end
