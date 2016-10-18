//
//  JVPlayerConstants.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVPlayerConstants.h"

// Youtube state reference: https://developers.google.com/youtube/iframe_api_reference
NSString *const kJVPlayerStateUnstartedCode = @"-1";
NSString *const kJVPlayerStateEndedCode = @"0";
NSString *const kJVPlayerStatePlayingCode = @"1";
NSString *const kJVPlayerStatePausedCode = @"2";
NSString *const kJVPlayerStateBufferingCode = @"3";
NSString *const kJVPlayerStateCuedCode = @"5";
NSString *const kJVPlayerStateUnknownCode = @"unknown";

// Constants representing playback quality.
NSString *const kJVPlaybackQualitySmallQuality = @"small";
NSString *const kJVPlaybackQualityMediumQuality = @"medium";
NSString *const kJVPlaybackQualityLargeQuality = @"large";
NSString *const kJVPlaybackQualityHD720Quality = @"hd720";
NSString *const kJVPlaybackQualityHD1080Quality = @"hd1080";
NSString *const kJVPlaybackQualityHighResQuality = @"highres";
NSString *const kJVPlaybackQualityUnknownQuality = @"unknown";

// Constants representing YouTube player errors.
NSString *const kJVPlayerErrorInvalidParamErrorCode = @"2";
NSString *const kJVPlayerErrorHTML5ErrorCode = @"5";
NSString *const kJVPlayerErrorVideoNotFoundErrorCode = @"100";
NSString *const kJVPlayerErrorNotEmbeddableErrorCode = @"101";
NSString *const kJVPlayerErrorCannotFindVideoErrorCode = @"105";

// Constants representing player callbacks.
NSString *const kJVPlayerCallbackOnReady = @"onReady";
NSString *const kJVPlayerCallbackOnStateChange = @"onStateChange";
NSString *const kJVPlayerCallbackOnPlaybackQualityChange = @"onPlaybackQualityChange";
NSString *const kJVPlayerCallbackOnError = @"onError";
NSString *const kJVPlayerCallbackOnYouTubeIframeAPIReady = @"onYouTubeIframeAPIReady";

NSString *const kJVPlayerEmbedUrlRegexPattern = @"^http(s)://(www.)youtube.com/embed/(.*)$";

