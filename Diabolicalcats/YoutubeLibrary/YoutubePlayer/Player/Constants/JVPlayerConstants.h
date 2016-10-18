//
//  JVPlayerConstants.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#ifndef JVPlayerConstants_h
#define JVPlayerConstants_h
#import "JVPlayerEnums.h"

// Youtube state reference: https://developers.google.com/youtube/iframe_api_reference
FOUNDATION_EXTERN NSString *const kJVPlayerStateUnstartedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateEndedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStatePlayingCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStatePausedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateBufferingCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateCuedCode;
FOUNDATION_EXTERN NSString *const kJVPlayerStateUnknownCode;

// Constants representing playback quality.
FOUNDATION_EXTERN NSString *const kJVPlaybackQualitySmallQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityMediumQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityLargeQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHD720Quality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHD1080Quality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityHighResQuality;
FOUNDATION_EXTERN NSString *const kJVPlaybackQualityUnknownQuality;

// Constants representing YouTube player errors.
FOUNDATION_EXTERN NSString *const kJVPlayerErrorInvalidParamErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorHTML5ErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorVideoNotFoundErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorNotEmbeddableErrorCode;
FOUNDATION_EXTERN NSString *const kJVPlayerErrorCannotFindVideoErrorCode;

// Constants representing player callbacks.
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnReady;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnStateChange;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnPlaybackQualityChange;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnError;
FOUNDATION_EXTERN NSString *const kJVPlayerCallbackOnYouTubeIframeAPIReady;

FOUNDATION_EXTERN NSString *const kJVPlayerEmbedUrlRegexPattern;

#endif /* JVPlayerConstants_h */
