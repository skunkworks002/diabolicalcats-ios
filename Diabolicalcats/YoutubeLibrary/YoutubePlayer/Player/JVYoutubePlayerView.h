//
//  JVYoutubePlayerView.h
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JVPlayerConstants.h"


@class JVYoutubePlayerView;


#pragma mark - Player Protocol

/**
 A delegate for ViewControllers to respond to YouTube player events outside of the view, such as changes to video playback state or playback errors. The callback functions correlate to the events fired by the JavaScript API. For the full documentation, see the JavaScript documentation here: https://developers.google.com/youtube/js_api_reference#Events
 */
@protocol JVYoutubePlayerDelegate<NSObject>

@optional

/**
 Invoked when the player view is ready to receive API calls.

 @param playerView 
    The JVYoutubePlayerView instance that has become ready.
 */
- (void)playerViewDidBecomeReady:(JVYoutubePlayerView *)playerView;


/**
 Callback invoked when player state has changed, e.g. stopped or started playback.
 
 @param playerView 
    The JVYoutubePlayerView instance where playback state has changed.
 @param state 
    JVPlayerState designating the new playback state.
 */
- (void)playerView:(JVYoutubePlayerView *)playerView didChangeToState:(JVPlayerState)state;


/**
 Callback invoked when playback quality has changed.

 @param playerView 
    The JVYoutubePlayerView instance where playback quality has changed.
 @param quality 
    JVPlaybackQuality designating the new playback quality.
 */
- (void)playerView:(JVYoutubePlayerView *)playerView didChangeToQuality:(JVPlaybackQuality)quality;

/**
 Callback invoked when an error has occured.

 @param playerView
    The JVYoutubePlayerView instance where the error has occurred.
 @param error
    JVPlayerError containing the error state.
 */
- (void)playerView:(JVYoutubePlayerView *)playerView receivedError:(JVPlayerError)error;
@end



#pragma mark - Player Interface

/**
 JVYoutubePlayerView is a custom UIView that client developers will use to include YouTube videos in their iOS applications. It can be instantiated programmatically, or via Interface Builder. Use the methods JVYoutubePlayerView::loadWithVideoId:, JVYoutubePlayerView::loadWithPlaylistId: or their variants to set the video or playlist to populate the view with.
 */

@interface JVYoutubePlayerView : UIView <NSObject, UIWebViewDelegate>


/**
 Allos landscape mode of the Youtube Player. This will resize the player/webview frame to take over the entire screen frame in landscape.
 */
@property (nonatomic, assign) BOOL allowLandscapeMode;


/**
 Forces the player/webview to go back to portrait mode.
 */
@property (nonatomic, assign) BOOL forceBackToPortraitMode;


/**
 Allos auto resizing player frame.
 */
@property (nonatomic, assign) BOOL allowAutoResizingPlayerFrame;


/**
 The default is 2. The available values are 0,1,2 (1 and 2 literraly the same) so if(YES then = 1).
 */
@property (nonatomic, assign) BOOL autohide;


/**
 The default value is 0.
 */
@property (nonatomic, assign) BOOL autoplay;


/**
 Default is based on user preferences.
 */
@property (nonatomic, assign) BOOL cc_load_policy;


/**
 Default is red color. The available colors are red or white (if YES then = white).
 */
@property (nonatomic, assign) BOOL color;


/**
 Default is 1. The available values are 0,1,2 (1 and 2 is literally the same) so (if YES then = 0).
 */
@property (nonatomic, assign) BOOL controls;


/**
 Default is 0. The available values are 0 and 1.
 */
@property (nonatomic, assign) BOOL disablekb;


/**
 Default is 0.
 */
@property (nonatomic, assign) BOOL enablejsapi;


/**
 Spicifies the time as a positive intiger.
 */
@property (nonatomic, assign) NSInteger end;


/**
 Default is 1.
 */
@property (nonatomic, assign) BOOL fullscreen;


/**
 Default is 1. available values 1 or 3.
 */
@property (nonatomic, assign) BOOL iv_load_policy;


/**
 If listType == search then is (value specifies the search query).
 */
@property (strong, nonatomic) NSString *list;


/**
 Only allows the values -> playlist, search and user_uploads.
 
 if listType == user_uploads then is (value identifies the YouTube channel whose uploaded videos will be loaded)
 if listType == user_uploads then is (value specifies a YouTube playlist ID. In the parameter value, you need to prepend the playlist ID with the letters PL as shown in the example below)
 http://www.youtube.com/embed?listType=playlist&list=PLC77007E23FF423C6 == PLC77007E23FF423C6
 
 */
@property (strong, nonatomic) NSString *listType;


/**
 Default is 0.
 */
@property (nonatomic, assign) BOOL loops;


/**
 Default is 0.
 */
@property (nonatomic, assign) BOOL modestbranding;


/**
 Value can be any alphanumeric string.
 */
@property (strong, nonatomic) NSString *playerapiid;


/**
 Value is a comma-separated list of video IDs to play.
 */
@property (strong, nonatomic) NSString *playList;


/**
 Default is 0.
 */
@property (nonatomic, assign) BOOL playsinline;


/**
 Default is 1.
 */
@property (nonatomic, assign) BOOL rel;


/**
 Default is 1.
 */
@property (nonatomic, assign) BOOL showinfo;


/**
 Values: A positive integer. This parameter causes the player to begin playing the video at the given number of seconds from the start of the video.
 */
@property (nonatomic, assign) NSInteger start;


/**
 Default is dark, available dark and light (if YES == light).
 */
@property (nonatomic, assign) BOOL theme;


/**
 Enable HD playback if possible.
 */
@property (nonatomic, assign) BOOL hd;


/**
 Enable HD 720 playback if possible.
 */
@property (nonatomic, assign) BOOL hd720;


/**
 Enable HD 1080 playback if possible.
 */
@property (nonatomic, assign) BOOL hd1080;


/**
 Allows playback in the background.
 */
@property  (nonatomic, assign) BOOL allowBackgroundPlayback;


/** 
 A delegate to be notified on playback events. 
 */
@property(nonatomic, weak) id<JVYoutubePlayerDelegate> delegate;


/**
 The webview use to load youtube player.
 */
@property(nonatomic, strong, readonly) UIWebView *webView;


/**
 Internal player with timer.
 */
@property (nonatomic, assign) BOOL playerWithTimer;


/**
 Internal stop timer.
 */
@property (nonatomic, assign) CGFloat stopTimer;


#pragma mark - Player Initializers

/**
 This method loads the player with the given video url. This is a convenience method for calling JVYoutubePlayerView::loadPlayerWithVideoId:withPlayerVars: without player variables.

 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.

 @param videoURL 
    The YouTube video url of the video to load in the player view.
 
 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideoURL:(NSString *)videoURL;


/**
 This method loads the player with the given videos urls. This is a convenience method for calling JVYoutubePlayerView::loadPlayerWithVideoId:withPlayerVars: without player variables.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 
 @param videosURL 
    The YouTube videos urls of the videos to load in the player view.
 
 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideosURL:(NSArray *)videosURL;


/**
 This method loads the player with the given video ID. This is a convenience method for calling JVYoutubePlayerView::loadPlayerWithVideoId:withPlayerVars: without player variables.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 
 @param videoId 
    The YouTube video ID of the video to load in the player view.
 
 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideoId:(NSString *)videoId;


/**
 This method loads the player with the given videos IDs. This is a convenience method for calling JVYoutubePlayerView::loadPlayerWithVideoId:withPlayerVars: without player variables.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 
 @param videosId 
    The YouTube videos IDs of the videos to load in the player view.

 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithVideosId:(NSArray *)videosId;


/**
 This method loads the player with the given playlist ID. This is a convenience method for calling JVYoutubePlayerView::loadWithPlaylistId:withPlayerVars: without player variables.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cuePlaylistByPlaylistId:index:startSeconds:suggestedQuality: family of methods.
 
 @param playlistId 
    The YouTube playlist ID of the playlist to load in the player view.
 
 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadPlayerWithPlaylistId:(NSString *)playlistId;


/**
 This method loads the player with the given video ID and player variables. Player variables specify optional parameters for video playback. For instance, to play a YouTube video inline, the following playerVars dictionary would be used:
 
 @code
 @{ @"playsinline" : @1 };
 @endcode
 
 Note that when the documentation specifies a valid value as a number (typically 0, 1 or 2), both strings and integers are valid values. The full list of parameters is defined at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cueVideoById:startSeconds:suggestedQuality: family of methods.
 
 @param videoId 
    The YouTube video ID of the video to load in the player view.
 @param playerVars
    An NSDictionary of player parameters.
 
 @return 
    YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithVideoId:(NSString *)videoId playerVars:(NSDictionary *)playerVars;


/**
 This method loads the player with the given playlist ID and player variables. Player variables specify optional parameters for video playback. For instance, to play a YouTube video inline, the following playerVars dictionary would be used:
 
 @code
 @{ @"playsinline" : @1 };
 @endcode
 
 Note that when the documentation specifies a valid value as a number (typically 0, 1 or 2), both strings and integers are valid values. The full list of parameters is defined at: https://developers.google.com/youtube/player_parameters?playerVersion=HTML5.
 
 This method reloads the entire contents of the UIWebView and regenerates its HTML contents. To change the currently loaded video without reloading the entire UIWebView, use the JVYoutubePlayerView::cuePlaylistByPlaylistId:index:startSeconds:suggestedQuality: family of methods.
 
 @param playlistId 
    The YouTube playlist ID of the playlist to load in the player view.
 @param playerVars 
    An NSDictionary of player parameters.
 
 @return YES if player has been configured correctly, NO otherwise.
 */
- (BOOL)loadWithPlaylistId:(NSString *)playlistId playerVars:(NSDictionary *)playerVars;



#pragma mark - Setting the playback rate

/**
 Gets the playback rate. The default value is 1.0, which represents a video playing at normal speed. Other values may include 0.25 or 0.5 for slower speeds, and 1.5 or 2.0 for faster speeds. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlaybackRate
 
 @return 
    An integer value between 0 and 100 representing the current volume.
 */
- (float)playbackRate;


/**
 Sets the playback rate. The default value is 1.0, which represents a video playing at normal speed. Other values may include 0.25 or 0.5 for slower speeds, and 1.5 or 2.0 for faster speeds. To fetch a list of valid values for this method, call JVYoutubePlayerView::getAvailablePlaybackRates. This method does not guarantee that the playback rate will change. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#setPlaybackRate
 
 @param suggestedRate 
    A playback rate to suggest for the player.
 */
- (void)setPlaybackRate:(float)suggestedRate;


/**
 Gets a list of the valid playback rates, useful in conjunction with JVYoutubePlayerView::setPlaybackRate. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlaybackRate
 
 @return A
    n NSArray containing available playback rates. nil if there is an error.
 */
- (NSArray *)availablePlaybackRates;


#pragma mark - Setting playback behavior for playlists

/**
 Sets whether the player should loop back to the first video in the playlist after it has finished playing the last video. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#loopPlaylist
 
 @param loop 
    A boolean representing whether the player should loop.
 */
- (void)setLoop:(BOOL)loop;


/**
 Sets whether the player should shuffle through the playlist. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#shufflePlaylist
 
 @param shuffle 
    A boolean representing whether the player should shuffle through the playlist.
 */
- (void)setShuffle:(BOOL)shuffle;


#pragma mark - Retrieving video information

// Retrieving video information. These methods correspond to the JavaScript
// methods defined here:
//   https://developers.google.com/youtube/js_api_reference#Retrieving_video_information

/**
 Returns the duration in seconds since the video of the video. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getDuration
 
 @return 
    Length of the video in seconds.
 */
- (int)duration;


/**
 Returns the YouTube.com URL for the video. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getVideoUrl
 
 @return 
    The YouTube.com URL for the video.
 */
- (NSURL *)videoUrl;


/**
 * Returns the embed code for the current video. This method corresponds
 * to the JavaScript API defined here:
 *   https://developers.google.com/youtube/iframe_api_reference#getVideoEmbedCode
 *
 * @return The embed code for the current video.
 */
- (NSString *)videoEmbedCode;


#pragma mark - Retrieving playlist information

// Retrieving playlist information. These methods correspond to the
// JavaScript defined here:
//    https://developers.google.com/youtube/js_api_reference#Retrieving_playlist_information

/**
 Returns an ordered array of video IDs in the playlist. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlaylist
 
 @return 
    An NSArray containing all the video IDs in the current playlist. |nil| on error.
 */
- (NSArray *)playlist;


/**
 Returns the 0-based index of the currently playing item in the playlist. This method corresponds to the JavaScript API defined here: https://developers.google.com/youtube/iframe_api_reference#getPlaylistIndex
 
 @return 
    The 0-based index of the currently playing item in the playlist.
 */
- (int)playlistIndex;

@end