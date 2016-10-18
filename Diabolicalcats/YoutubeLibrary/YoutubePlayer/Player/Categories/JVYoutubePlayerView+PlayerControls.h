//
//  JVYoutubePlayerView+PlayerControls.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JVYoutubePlayerView.h"


/**
 These methods correspond to their JavaScript equivalents as documented here: https://developers.google.com/youtube/js_api_reference#Playback_controls
 */
@interface JVYoutubePlayerView (PlayerControls)

#pragma mark - Player controls

/**
 Starts or resumes playback on the loaded video. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#playVideo
 */
- (void)playVideo;


/**
 Pauses playback on a playing video. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#pauseVideo
 */
- (void)pauseVideo;


/**
 Stops playback on a playing video. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#stopVideo
 */
- (void)stopVideo;


/**
 Seek to a given time on a playing video. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#seekTo
 
 @param seekToSeconds
    The time in seconds to seek to in the loaded video.
 @param allowSeekAhead
    Whether to make a new request to the server if the time is outside what is currently buffered. Recommended to set to YES.
 */
- (void)seekToSeconds:(float)seekToSeconds allowSeekAhead:(BOOL)allowSeekAhead;


/**
 Clears the loaded video from the player. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#clearVideo
 */
- (void)clearVideo;


/**
 Schedules pause video.
 */
- (void)schedulePauseVideo;


#pragma mark - Playing a video in a playlist

// These methods correspond to the JavaScript API as defined under the
// "Playing a video in a playlist" section here:
//    https://developers.google.com/youtube/js_api_reference#Playback_status

/**
 Loads and plays the next video in the playlist. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#nextVideo
 */
- (void)nextVideo;


/**
 Loads and plays the previous video in the playlist. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#previousVideo
 */
- (void)previousVideo;


/**
 Loads and plays the video at the given 0-indexed position in the playlist. Corresponds to this method from the JavaScript API: https://developers.google.com/youtube/iframe_api_reference#playVideoAt
 
 @param index 
    The 0-indexed position of the video in the playlist to load and play.
 */
- (void)playVideoAt:(int)index;

@end
