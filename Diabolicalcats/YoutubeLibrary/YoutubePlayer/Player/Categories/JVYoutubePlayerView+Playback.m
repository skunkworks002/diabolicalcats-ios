//
//  JVYoutubePlayerView+Playback.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayerView+Playback.h"
#import "UIWebView+Addons.h"


@implementation JVYoutubePlayerView (Playback)

#pragma mark - Playback status

- (float)videoLoadedFraction
{
    return [[self.webView stringFromEvaluatingJavaScript:@"player.getVideoLoadedFraction();"] floatValue];
}


- (JVPlayerState)playerState
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getPlayerState();"];
    return [JVYoutubePlayerView playerStateForString:returnValue];
}


- (float)currentTime
{
    return [[self.webView stringFromEvaluatingJavaScript:@"player.getCurrentTime();"] floatValue];
}


#pragma mark - Playback quality

- (JVPlaybackQuality)playbackQuality
{
    NSString *qualityValue = [self.webView stringFromEvaluatingJavaScript:@"player.getPlaybackQuality();"];
    return [JVYoutubePlayerView playbackQualityForString:qualityValue];
}

- (void)setPlaybackQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.setPlaybackQuality('%@');", qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (NSArray *)availableQualityLevels
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getAvailableQualityLevels();"];
    
    NSData *availableQualityLevelsData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    
    NSArray *rawQualityValues = [NSJSONSerialization JSONObjectWithData:availableQualityLevelsData
                                                                options:kNilOptions
                                                                  error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
    {
        return nil;
    }
    
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    for (NSString *rawQualityValue in rawQualityValues) {
        JVPlaybackQuality quality = [JVYoutubePlayerView playbackQualityForString:rawQualityValue];
        [levels addObject:[NSNumber numberWithInt:quality]];
    }
    
    return levels;
}


#pragma mark - Public Methods

+ (JVPlaybackQuality)playbackQualityForString:(NSString *)qualityString
{
    JVPlaybackQuality quality = kJVPlaybackQualityUnknown;
    
    if ([qualityString isEqualToString:kJVPlaybackQualitySmallQuality])
    {
        quality = kJVPlaybackQualitySmall;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityMediumQuality])
    {
        quality = kJVPlaybackQualityMedium;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityLargeQuality])
    {
        quality = kJVPlaybackQualityLarge;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHD720Quality])
    {
        quality = kJVPlaybackQualityHD720;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHD1080Quality])
    {
        quality = kJVPlaybackQualityHD1080;
    }
    else if ([qualityString isEqualToString:kJVPlaybackQualityHighResQuality])
    {
        quality = kJVPlaybackQualityHighRes;
    }
    
    return quality;
}


+ (NSString *)stringForPlaybackQuality:(JVPlaybackQuality)quality
{
    switch (quality) {
        case kJVPlaybackQualitySmall:
            return kJVPlaybackQualitySmallQuality;
        case kJVPlaybackQualityMedium:
            return kJVPlaybackQualityMediumQuality;
        case kJVPlaybackQualityLarge:
            return kJVPlaybackQualityLargeQuality;
        case kJVPlaybackQualityHD720:
            return kJVPlaybackQualityHD720Quality;
        case kJVPlaybackQualityHD1080:
            return kJVPlaybackQualityHD1080Quality;
        case kJVPlaybackQualityHighRes:
            return kJVPlaybackQualityHighResQuality;
        default:
            return kJVPlaybackQualityUnknownQuality;
    }
}


+ (JVPlayerState)playerStateForString:(NSString *)stateString
{
    JVPlayerState state = kJVPlayerStateUnknown;
    
    if ([stateString isEqualToString:kJVPlayerStateUnstartedCode])
    {
        state = kJVPlayerStateUnstarted;
    }
    else if ([stateString isEqualToString:kJVPlayerStateEndedCode])
    {
        state = kJVPlayerStateEnded;
    }
    else if ([stateString isEqualToString:kJVPlayerStatePlayingCode])
    {
        state = kJVPlayerStatePlaying;
    }
    else if ([stateString isEqualToString:kJVPlayerStatePausedCode])
    {
        state = kJVPlayerStatePaused;
    }
    else if ([stateString isEqualToString:kJVPlayerStateBufferingCode])
    {
        state = kJVPlayerStateBuffering;
    }
    else if ([stateString isEqualToString:kJVPlayerStateCuedCode])
    {
        state = kJVPlayerStateQueued;
    }
    
    return state;
}


+ (NSString *)stringForPlayerState:(JVPlayerState)state
{
    switch (state) {
        case kJVPlayerStateUnstarted:
            return kJVPlayerStateUnstartedCode;
        case kJVPlayerStateEnded:
            return kJVPlayerStateEndedCode;
        case kJVPlayerStatePlaying:
            return kJVPlayerStatePlayingCode;
        case kJVPlayerStatePaused:
            return kJVPlayerStatePausedCode;
        case kJVPlayerStateBuffering:
            return kJVPlayerStateBufferingCode;
        case kJVPlayerStateQueued:
            return kJVPlayerStateCuedCode;
        default:
            return kJVPlayerStateUnknownCode;
    }
}

@end
