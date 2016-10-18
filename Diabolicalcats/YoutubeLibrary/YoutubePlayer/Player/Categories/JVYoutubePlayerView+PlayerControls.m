//
//  JVYoutubePlayerView+PlayerControls.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayerView+PlayerControls.h"
#import "UIWebView+Addons.h"
#import "NSString+Addons.h"

@implementation JVYoutubePlayerView (PlayerControls)

- (void)playVideo
{
    if (self.playerWithTimer)
    {
        [self schedulePauseVideo];
    }
    
    NSLog(@"%d",self.playerWithTimer);
    
    [self.webView stringFromEvaluatingJavaScript:@"player.playVideo();"];
}


- (void)pauseVideo
{
    [self.webView stringFromEvaluatingJavaScript:@"player.pauseVideo();"];
}


- (void)stopVideo
{
    [self.webView stringFromEvaluatingJavaScript:@"player.stopVideo();"];
}


- (void)seekToSeconds:(float)seekToSeconds allowSeekAhead:(BOOL)allowSeekAhead
{
    NSNumber *secondsValue = [NSNumber numberWithFloat:seekToSeconds];
    NSString *allowSeekAheadValue = [NSString stringForJSBoolean:allowSeekAhead];
    NSString *command = [NSString stringWithFormat:@"player.seekTo(%@, %@);", secondsValue, allowSeekAheadValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)clearVideo
{
    [self.webView stringFromEvaluatingJavaScript:@"player.clearVideo();"];
}


- (void)schedulePauseVideo
{
    [self performSelector:@selector(pauseVideo) withObject:self afterDelay:self.stopTimer];
}


#pragma mark - Playing a video in a playlist

- (void)nextVideo
{
    [self.webView stringFromEvaluatingJavaScript:@"player.nextVideo();"];
}


- (void)previousVideo
{
    [self.webView stringFromEvaluatingJavaScript:@"player.previousVideo();"];
}


- (void)playVideoAt:(int)index
{
    NSString *command = [NSString stringWithFormat:@"player.playVideoAt(%@);", [NSNumber numberWithInt:index]];
    [self.webView stringFromEvaluatingJavaScript:command];
}


@end
