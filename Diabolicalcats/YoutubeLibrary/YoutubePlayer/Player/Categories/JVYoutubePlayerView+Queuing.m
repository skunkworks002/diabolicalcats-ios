//
//  JVYoutubePlayerView+Queuing.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayerView+Queuing.h"
#import "JVYoutubePlayerView+Playback.h"
#import "UIWebView+Addons.h"
#import "NSString+Addons.h"


@implementation JVYoutubePlayerView (Queuing)

#pragma mark - Cueing methods

- (void)cueVideoById:(NSString *)videoId startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoById('%@', %@, '%@');", videoId, startSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)cueVideoById:(NSString *)videoId startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoById('%@', %@, %@, '%@');", videoId, startSecondsValue, endSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)loadVideoById:(NSString *)videoId startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoById('%@', %@, '%@');", videoId, startSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)loadVideoById:(NSString *)videoId startSeconds:(CGFloat)startSeconds endSeconds:(CGFloat)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoById('%@', %@, %@, '%@');", videoId, startSecondsValue, endSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)cueVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoByUrl('%@', %@, '%@');", videoURL, startSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)cueVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cueVideoByUrl('%@', %@, %@, '%@');", videoURL, startSecondsValue, endSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)loadVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoByUrl('%@', %@, '%@');", videoURL, startSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)loadVideoByURL:(NSString *)videoURL startSeconds:(float)startSeconds endSeconds:(float)endSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    self.playerWithTimer = YES;
    self.stopTimer = endSeconds+1;
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSNumber *endSecondsValue = [NSNumber numberWithFloat:endSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadVideoByUrl('%@', %@, %@, '%@');", videoURL, startSecondsValue, endSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


#pragma mark - Cueing methods for lists

- (void)cuePlaylistByPlaylistId:(NSString *)playlistId index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *playlistIdString = [NSString stringWithFormat:@"'%@'", playlistId];
    [self cuePlaylist:playlistIdString index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}


- (void)cuePlaylistByVideos:(NSArray *)videoIds index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    [self cuePlaylist:[NSString stringFromVideoIdArray:videoIds] index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}


- (void)loadPlaylistByPlaylistId:(NSString *)playlistId index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSString *playlistIdString = [NSString stringWithFormat:@"'%@'", playlistId];
    [self loadPlaylist:playlistIdString index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}


- (void)loadPlaylistByVideos:(NSArray *)videoIds index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    [self loadPlaylist:[NSString stringFromVideoIdArray:videoIds] index:index startSeconds:startSeconds suggestedQuality:suggestedQuality];
}


/**
 * Private method for cueing both cases of playlist ID and array of video IDs. Cueing
 * a playlist does not start playback.
 *
 * @param cueingString A JavaScript string representing an array, playlist ID or list of
 *                     video IDs to play with the playlist player.
 * @param index 0-index position of video to start playback on.
 * @param startSeconds Seconds after start of video to begin playback.
 * @param suggestedQuality Suggested JVPlaybackQuality to play the videos.
 * @return The result of cueing the playlist.
 */
- (void)cuePlaylist:(NSString *)cueingString index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *indexValue = [NSNumber numberWithInt:index];
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.cuePlaylist(%@, %@, %@, '%@');", cueingString, indexValue, startSecondsValue, qualityValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


/**
 * Private method for loading both cases of playlist ID and array of video IDs. Loading
 * a playlist automatically starts playback.
 *
 * @param cueingString A JavaScript string representing an array, playlist ID or list of
 *                     video IDs to play with the playlist player.
 * @param index 0-index position of video to start playback on.
 * @param startSeconds Seconds after start of video to begin playback.
 * @param suggestedQuality Suggested JVPlaybackQuality to play the videos.
 * @return The result of cueing the playlist.
 */
- (void)loadPlaylist:(NSString *)cueingString index:(int)index startSeconds:(float)startSeconds suggestedQuality:(JVPlaybackQuality)suggestedQuality
{
    NSNumber *indexValue = [NSNumber numberWithInt:index];
    NSNumber *startSecondsValue = [NSNumber numberWithFloat:startSeconds];
    NSString *qualityValue = [JVYoutubePlayerView stringForPlaybackQuality:suggestedQuality];
    NSString *command = [NSString stringWithFormat:@"player.loadPlaylist(%@, %@, %@, '%@');", cueingString, indexValue, startSecondsValue, qualityValue];
    [self.webView stringFromEvaluatingJavaScript:command];
}

@end
