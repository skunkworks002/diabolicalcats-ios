//
//  UIWebView+Addons.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIWebView (Addons)

/**
 This method for evaluating JavaScript in the WebView.
 
 @param jsToExecute
 The JavaScript code in string format that we want to execute.
 
 @return
 JavaScript response from evaluating code.
 */
- (NSString *)stringFromEvaluatingJavaScript:(NSString *)jsToExecute;

@end
