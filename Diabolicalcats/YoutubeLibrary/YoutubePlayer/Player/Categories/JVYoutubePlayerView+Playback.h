//
//  JVYoutubePlayerView+Playback.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayerView.h"


@interface JVYoutubePlayerView (Playback)

#pragma mark - Playback status

// These methods correspond to the JavaScript methods defined here: https://developers.google.com/youtube/js_api_reference#Playback_status

/**
 Returns a number between 0 and 1 that specifies the percentage of the video that the player shows as buffered. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getVideoLoadedFraction
 
 @return 
    A float value between 0 and 1 representing the percentage of the video already loaded.
 */
- (float)videoLoadedFraction;


/**
 Returns the state of the player. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlayerState
 
 @return 
    |JVPlayerState| representing the state of the player.
 */
- (JVPlayerState)playerState;


/**
 Returns the elapsed time in seconds since the video started playing. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getCurrentTime
 
 @return 
    Time in seconds since the video started playing.
 */
- (float)currentTime;


#pragma mark - Playback quality

// Playback quality. These methods correspond to the JavaScript methods defined here: https://developers.google.com/youtube/js_api_reference#Playback_quality

/**
 Returns the playback quality. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlaybackQuality
 
 @return 
    JVPlaybackQuality representing the current playback quality.
 */
- (JVPlaybackQuality)playbackQuality;


/**
 Suggests playback quality for the video. It is recommended to leave this setting to |default|. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#setPlaybackQuality
 
 @param quality 
    JVPlaybackQuality value to suggest for the player.
 */
- (void)setPlaybackQuality:(JVPlaybackQuality)suggestedQuality;


/**
 Gets a list of the valid playback quality values, useful in conjunction with JVYoutubePlayerView::setPlaybackQuality. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getAvailableQualityLevels.
 
 @return 
    An NSArray containing available playback quality levels.
 */
- (NSArray *)availableQualityLevels;


#pragma mark - Public methods

/**
 Convert a quality value from NSString to the typed enum value.
 
 @param qualityString 
    A string representing playback quality. Ex: "small", "medium", "hd1080".
 
 @return An enum value representing the playback quality.
 */
+ (JVPlaybackQuality)playbackQualityForString:(NSString *)qualityString;


/**
 Convert a |JVPlaybackQuality| value from the typed value to NSString.
 
 @param quality 
    A |JVPlaybackQuality| parameter.

 @return
    An |NSString| value to be used in the JavaScript bridge.
 */
+ (NSString *)stringForPlaybackQuality:(JVPlaybackQuality)quality;


/**
 Convert a state value from NSString to the typed enum value.
 
 @param stateString 
    A string representing player state. Ex: "-1", "0", "1".
 
 @return 
    An enum value representing the player state.
 */
+ (JVPlayerState)playerStateForString:(NSString *)stateString;


/**
 Convert a state value from the typed value to NSString.
 
 @param quality 
    A |JVPlayerState| parameter.
 
 @return 
    A string value to be used in the JavaScript bridge.
 */
+ (NSString *)stringForPlayerState:(JVPlayerState)state;


@end
