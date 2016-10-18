//
//  JVYoutubePlayerView.m
//  YoutubePlayerDemo
//
//  Created by Jorge Valbuena on 2016-01-24.
//  Copyright © 2016 com.jorgedeveloper. All rights reserved.
//

#import "JVYoutubePlayerView.h"
#import "AppDelegate.h"
#import "JVYoutubePlayerConstants.h"
#import "UIWebView+Addons.h"
#import "NSString+Addons.h"
#import "JVYoutubePlayerView+PlayerControls.h"
#import "JVYoutubePlayerView+Playback.h"
#import "JVYoutubePlayerView+Queuing.h"
#import "JVYoutubePlayer.h"


#pragma mark - Player Interface

@interface JVYoutubePlayerView() <JVYoutubePlayerDelegate>

// for screen sizes
@property (nonatomic) CGSize screenRect;

@property (nonatomic) CGFloat screenWidth;

@property (nonatomic) CGFloat screenHeight;

@property (nonatomic) CGRect prevFrame;

@property (nonatomic) BOOL playerContainsCustomParams;

@property (nonatomic, strong) NSArray *loadPlayerDic;

@property (nonatomic, assign) BOOL isPlayerLoaded;

@property (nonatomic, strong) NSMutableDictionary *dicParameters;

@property (nonatomic, assign) BOOL isPlayerInBackground;

@property(nonatomic, strong, readwrite) UIWebView *webView;
@property (nonatomic, strong) JVYoutubePlayerView *player;

@end

#pragma mark - Player Implementation
@implementation JVYoutubePlayerView


#pragma mark - Player Initializers

- (BOOL)loadPlayerWithVideoURL:(NSString *)videoURL
{
    return [self loadWithVideoId:[self findVideoIdFromURL:videoURL] playerVars:nil];
}

- (BOOL)loadPlayerWithVideosURL:(NSArray *)videosURL
{
    if(videosURL.count > 0)
    {
        NSMutableArray *videosId = [[NSMutableArray alloc] initWithCapacity:videosURL.count];
        
        for(int x = 0; x < videosURL.count; x++)
        {
            videosId[x] = [[self findVideoIdFromURL:videosURL[x]] mutableCopy];
        }
        
        self.loadPlayerDic = @[@"loadPlayerWithVideosId", videosId];
        return [self loadPlayerWithVideoId:videosId[0]];
    }
    
    return nil;
}

- (BOOL)loadPlayerWithVideoId:(NSString *)videoId
{
    return [self loadWithVideoId:videoId playerVars:nil];
}

- (BOOL)loadPlayerWithVideosId:(NSArray *)videosId
{
    if(videosId.count > 0)
    {
        self.loadPlayerDic = @[@"loadPlayerWithVideosId", videosId];
        return [self loadPlayerWithVideoId:videosId[0]];
    }
    
    return nil;
}

- (BOOL)loadPlayerWithPlaylistId:(NSString *)playlistId
{
    return [self loadWithPlaylistId:playlistId playerVars:nil];
}

- (BOOL)loadWithVideoId:(NSString *)videoId playerVars:(NSDictionary *)playerVars
{
    if(self.playerContainsCustomParams)
    {
        return [self loadWithPlayerParams:playerVars];
    }
    
    if (!playerVars)
    {
        playerVars = @{};
    }
    
    if(self.dicParameters || self.dicParameters.count > 0)
    {
        NSDictionary *playerParams = @{ @"videoId" : videoId, @"playerVars" : self.dicParameters };
        return [self loadWithPlayerParams:playerParams];
    }
    
    NSDictionary *playerParams = @{ @"videoId" : videoId, @"playerVars" : playerVars };

    return [self loadWithPlayerParams:playerParams];
}

- (BOOL)loadWithPlaylistId:(NSString *)playlistId playerVars:(NSDictionary *)playerVars
{
    // Mutable copy because we may have been passed an immutable config dictionary.
    NSMutableDictionary *tempPlayerVars = [[NSMutableDictionary alloc] init];
    [tempPlayerVars setValue:@"playlist" forKey:@"listType"];
    [tempPlayerVars setValue:playlistId forKey:@"list"];
    [tempPlayerVars addEntriesFromDictionary:playerVars];  // No-op if playerVars is null
    [tempPlayerVars addEntriesFromDictionary:self.dicParameters];
    
    if(self.dicParameters || self.dicParameters.count > 0)
    {
        NSDictionary *playerParams = @{ @"playerVars" : tempPlayerVars };
        return [self loadWithPlayerParams:playerParams];
    }

    NSDictionary *playerParams = @{ @"playerVars" : tempPlayerVars };
    
    return [self loadWithPlayerParams:playerParams];
}


#pragma mark - Setting the playback rate

- (float)playbackRate
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getPlaybackRate();"];
    return [returnValue floatValue];
}


- (void)setPlaybackRate:(float)suggestedRate
{
    NSString *command = [NSString stringWithFormat:@"player.setPlaybackRate(%f);", suggestedRate];
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (NSArray *)availablePlaybackRates
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getAvailablePlaybackRates();"];

    NSData *playbackRateData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    NSArray *playbackRates = [NSJSONSerialization JSONObjectWithData:playbackRateData
                                                             options:kNilOptions
                                                               error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
    {
        return nil;
    }
    return playbackRates;
}


#pragma mark - Setting playback behavior for playlists

- (void)setLoop:(BOOL)loop
{
    NSString *loopPlayListValue = [NSString stringForJSBoolean:loop];
    NSString *command = [NSString stringWithFormat:@"player.setLoop(%@);", loopPlayListValue];
    
    [self.webView stringFromEvaluatingJavaScript:command];
}


- (void)setShuffle:(BOOL)shuffle
{
    NSString *shufflePlayListValue = [NSString stringForJSBoolean:shuffle];
    NSString *command = [NSString stringWithFormat:@"player.setShuffle(%@);", shufflePlayListValue];
    [self.webView stringFromEvaluatingJavaScript:command];
}




#pragma mark - Video information methods

- (int)duration
{
    return [[self.webView stringFromEvaluatingJavaScript:@"player.getDuration();"] intValue];
}


- (NSURL *)videoUrl
{
    return [NSURL URLWithString:[self.webView stringFromEvaluatingJavaScript:@"player.getVideoUrl();"]];
}


- (NSString *)videoEmbedCode
{
    return [self.webView stringFromEvaluatingJavaScript:@"player.getVideoEmbedCode();"];
}


#pragma mark - Playlist methods

- (NSArray *)playlist
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getPlaylist();"];

    NSData *playlistData = [returnValue dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonDeserializationError;
    NSArray *videoIds = [NSJSONSerialization JSONObjectWithData:playlistData
                                                        options:kNilOptions
                                                          error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
    {
      return nil;
    }

    return videoIds;
}


- (int)playlistIndex
{
    NSString *returnValue = [self.webView stringFromEvaluatingJavaScript:@"player.getPlaylistIndex();"];
    return [returnValue intValue];
}


#pragma mark - Helper methods

- (NSString *)findVideoIdFromURL:(NSString *)videoURL
{
    NSString *videoId;
    NSString *searchedString = videoURL;
    NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
    NSString *pattern = @"(youtu(?:\\.be|be\\.com)\\/(?:.*v(?:\\/|=)|(?:.*\\/)?)([\\w'-]+))";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
    
    // debugging plain youtube link
//    NSLog(@"group1: %@", [searchedString substringWithRange:[match rangeAtIndex:1]]);
    // debugging youtube video id
//    NSLog(@"group2: %@", [searchedString substringWithRange:[match rangeAtIndex:2]]);
    
    videoId = [searchedString substringWithRange:[match rangeAtIndex:2]];
    
    return videoId;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // logging state of video
  //  NSLog(@"***** Checking Loading -> %@", request.URL.absoluteString);

    if (self.isPlayerInBackground && self.allowBackgroundPlayback && ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=1"] || [request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=2"] || [request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=3"]))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playVideo];
        });
        
        return YES;
    }
    
    // adding timer to pause video at giving time
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=1"])
    {
        if(self.playerWithTimer)
        {
            [self schedulePauseVideo];
        }
    }
    
    // forcing video to autoplay
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onReady?data=null"])
    {
        if(self.autoplay)
        {
            [self playVideo];
        }
    }
    
    // if found an error skip to next video
    if ([request.URL.absoluteString isEqualToString:@"ytplayer://onError?data=150"] || [request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=0"])
    {
        
   //    [self nextVideo]; // play next video if current can't be played
    
        //this 'll retun the playlist first video if the playlist videos ends
        [self playVideoAt:0];
    }
    
    if (self.allowLandscapeMode)
    {
        // allows youtube player in landscape mode
        if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=3"])
        {
            [self playerStarted];
            return NO;
        }
        else if ([request.URL.absoluteString isEqualToString:@"ytplayer://onStateChange?data=2"])
        {
            [self playerEnded];
            return NO;
        }
    }
    
    if ([request.URL.scheme isEqual:@"ytplayer"])
    {
        [self notifyDelegateOfYouTubeCallbackUrl:request.URL];
        return NO;
    }
//    else if ([request.URL.scheme isEqual: @"http"] || [request.URL.scheme isEqual:@"https"])
//    {
//        return [self handleHttpNavigationToUrl:request.URL];
//    }
    
    return YES;
}



#pragma mark - Private methods

/**
 * Private method to handle "navigation" to a callback URL of the format
 * http://ytplayer/action?data=someData
 * This is how the UIWebView communicates with the containing Objective-C code.
 * Side effects of this method are that it calls methods on this class's delegate.
 *
 * @param url A URL of the format http://ytplayer/action.
 */
- (void)notifyDelegateOfYouTubeCallbackUrl: (NSURL *) url
{
    NSString *action = url.host;

    // We know the query can only be of the format http://ytplayer?data=SOMEVALUE,
    // so we parse out the value.
    NSString *query = url.query;
    NSString *data;
    if (query)
    {
        data = [query componentsSeparatedByString:@"="][1];
    }

    if ([action isEqual:kJVPlayerCallbackOnReady])
    {
        self.isPlayerLoaded = YES;
        
        if ([self.delegate respondsToSelector:@selector(playerViewDidBecomeReady:)])
        {
            [self.delegate playerViewDidBecomeReady:self];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnStateChange])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:didChangeToState:)])
        {
            JVPlayerState state = kJVPlayerStateUnknown;

            if ([data isEqual:kJVPlayerStateEndedCode])
            {
                state = kJVPlayerStateEnded;
            }
            else if ([data isEqual:kJVPlayerStatePlayingCode])
            {
                state = kJVPlayerStatePlaying;
            }
            else if ([data isEqual:kJVPlayerStatePausedCode])
            {
                state = kJVPlayerStatePaused;
            }
            else if ([data isEqual:kJVPlayerStateBufferingCode])
            {
                state = kJVPlayerStateBuffering;
            }
            else if ([data isEqual:kJVPlayerStateCuedCode])
            {
                state = kJVPlayerStateQueued;
            }
            else if ([data isEqual:kJVPlayerStateUnstartedCode])
            {
                state = kJVPlayerStateUnstarted;
            }

            [self.delegate playerView:self didChangeToState:state];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnPlaybackQualityChange])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:didChangeToQuality:)])
        {
            JVPlaybackQuality quality = [JVYoutubePlayerView playbackQualityForString:data];
            [self.delegate playerView:self didChangeToQuality:quality];
        }
    }
    else if ([action isEqual:kJVPlayerCallbackOnError])
    {
        if ([self.delegate respondsToSelector:@selector(playerView:receivedError:)])
        {
            JVPlayerError error = kJVPlayerErrorUnknown;

            if ([data isEqual:kJVPlayerErrorInvalidParamErrorCode])
            {
                error = kJVPlayerErrorInvalidParam;
            }
            else if ([data isEqual:kJVPlayerErrorHTML5ErrorCode])
            {
                error = kJVPlayerErrorHTML5Error;
            }
            else if ([data isEqual:kJVPlayerErrorNotEmbeddableErrorCode])
            {
                error = kJVPlayerErrorNotEmbeddable;
            }
            else if ([data isEqual:kJVPlayerErrorVideoNotFoundErrorCode] || [data isEqual:kJVPlayerErrorCannotFindVideoErrorCode])
            {
                error = kJVPlayerErrorVideoNotFound;
            }

            [self.delegate playerView:self receivedError:error];
        }
    }
}

- (BOOL)handleHttpNavigationToUrl:(NSURL *) url
{
    // Usually this means the user has clicked on the YouTube logo or an error message in the
    // player. Most URLs should open in the browser. The only http(s) URL that should open in this
    // UIWebView is the URL for the embed, which is of the format:
    //     http(s)://www.youtube.com/embed/[VIDEO ID]?[PARAMETERS]
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:kJVPlayerEmbedUrlRegexPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:url.absoluteString
                                                    options:0
                                                      range:NSMakeRange(0, [url.absoluteString length])];
    if (match)
    {
        return YES;
    }
    else
    {
        [[UIApplication sharedApplication] openURL:url];
        return NO;
    }
}


/**
 * Private helper method to load an iframe player with the given player parameters.
 *
 * @param additionalPlayerParams An NSDictionary of parameters in addition to required parameters
 *                               to instantiate the HTML5 player with. This differs depending on
 *                               whether a single video or playlist is being loaded.
 * @return YES if successful, NO if not.
 */
- (BOOL)loadWithPlayerParams:(NSDictionary *)additionalPlayerParams
{
    // creating webview for youtube player
    if(!_webView || !_webView.window)
    {
        [self addSubview:self.webView];
        [self addObservers];
    }
    
    // preserving users frame
    _prevFrame = self.frame;
    
    NSDictionary *playerCallbacks = @{
        @"onReady" : @"onReady",
        @"onStateChange" : @"onStateChange",
        @"onPlaybackQualityChange" : @"onPlaybackQualityChange",
        @"onError" : @"onPlayerError"
    };
    
    NSMutableDictionary *playerParams = [[NSMutableDictionary alloc] init];
    [playerParams addEntriesFromDictionary:additionalPlayerParams];
    [playerParams setValue:@"100%" forKey:@"height"];
    [playerParams setValue:@"100%" forKey:@"width"];
    [playerParams setValue:playerCallbacks forKey:@"events"];

    // This must not be empty so we can render a '{}' in the output JSON
    if (![playerParams objectForKey:@"playerVars"])
    {
        [playerParams setValue:[[NSDictionary alloc] init] forKey:@"playerVars"];
    }

    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:JVYoutubePlayeriFrameFileName
                                                     ofType:JVYoutubePlayeriFrameFileType
                                                inDirectory:JVYoutubePlayeriFrameDirectory];

    NSString *embedHTMLTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];

    if (error)
    {
        NSLog(@"Received error rendering template: %@", error);
        return NO;
    }

    // Render the playerVars as a JSON dictionary.
    NSError *jsonRenderingError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:playerParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonRenderingError];
    
    if (jsonRenderingError)
    {
        NSLog(@"Attempted configuration of player with invalid playerVars: %@ \tError: %@", playerParams, jsonRenderingError);
        NSString *errMessage = [NSString stringWithFormat:@"\nAttempted configuration of player with invalid playerVars: %@ \nError: %@", playerParams, jsonRenderingError];
        @throw [NSException exceptionWithName:NSGenericException reason:errMessage userInfo:nil];
        return NO;
    }

    NSString *playerVarsJsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    NSString *embedHTML = [NSString stringWithFormat:embedHTMLTemplate, playerVarsJsonString];
    
    // for debugging html file
//    NSLog(@"%@", embedHTML);
    
    [self.webView loadHTMLString:embedHTML baseURL:[NSURL URLWithString:@"about:blank"]];

    return YES;
}


#pragma mark - Helper Functions

/**
 * Removes customs notifications
 * @name dealloc
 *
 * @param ...
 * @return void...
 */
- (void)dealloc
{
    // removing notification center
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}


- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    [self setPlaybackQuality:kJVPlaybackQualityHD720];

    if(self.allowLandscapeMode)
    {
        // adding listener to webView
        [_webView stringByEvaluatingJavaScriptFromString:@" for (var i = 0, videos = document.getElementsByTagName('video'); i < videos.length; i++) {"
                                                         @"      videos[i].addEventListener('webkitbeginfullscreen', function(){ "
                                                         @"           window.location = 'ytplayer://begin-fullscreen';"
                                                         @"      }, false);"
                                                         @""
                                                         @"      videos[i].addEventListener('webkitendfullscreen', function(){ "
                                                         @"           window.location = 'ytplayer://end-fullscreen';"
                                                         @"      }, false);"
                                                         @" }"
                                                         ];
    }
}


/**
 * Executes when player starts full screen of video player (good for changing app orientation)
 * @name playerStarted
 *
 * @param ...
 * @return void...
 */
- (void)playerStarted//:(NSNotification*)notification
{
    ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = YES;
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    
}


/**
 * Executes when player exits full screen of video player (good for changing app orientation)
 * @name playerEnded
 *
 * @param ...
 * @return void...
 */
- (void)playerEnded//:(NSNotification*)notification
{
    if(self.forceBackToPortraitMode == YES)
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = NO;
        
        [self supportedInterfaceOrientations];
        
        [self shouldAutorotate:UIInterfaceOrientationPortrait];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/**
 * Updates player frame depending on orientation
 * @name orientationChanged
 *
 * @param screenHeight, screenWidth and JVPlayer
 * @return void but updates JVPlayer frame
 */
- (void)orientationChanged:(NSNotification*)notification
{
    UIDevice *device = [UIDevice currentDevice];
    
    if(device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight)
    {
        _screenRect = [[UIScreen mainScreen] bounds].size;
        _screenHeight = _screenRect.height;
        _screenWidth = _screenRect.width;
        
        self.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    }
    else if(device.orientation == UIDeviceOrientationPortrait)
    {
        self.frame = _prevFrame;
    }
    else if (device.orientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
        
        ((AppDelegate*)[[UIApplication sharedApplication] delegate]).videoIsInFullscreen = NO;
        
        [self supportedInterfaceOrientations];
        
        [self shouldAutorotate:UIInterfaceOrientationPortrait];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }
}


#pragma mark - Notifications

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerViewDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
}


- (void)playerViewDidEnterBackground:(NSNotification *)notification
{
    self.isPlayerInBackground = YES;
}


- (void)playerViewWillResignActive:(NSNotification *)notification
{
    self.isPlayerInBackground = YES;
}


- (void)playerViewWillEnterForeground:(NSNotification *)notification
{
    self.isPlayerInBackground = NO;
}


- (void)playerViewDidBecomeActive:(NSNotification *)notification
{
    self.isPlayerInBackground = NO;
}


#pragma mark - Exposed for Testing

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.delegate = self;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.bounces = NO;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
    }
    
    return _webView;
}

// if you can comment this  so vedio vill show on full screen
- (NSMutableDictionary *)dicParameters
{
    if (!_dicParameters)
    {
        _dicParameters = [[NSMutableDictionary alloc] init];
    }
    
    return _dicParameters;
}
 


// Custom setters and getters for youtube player parameters
// to be loaded when player loads video.
// These parameters can be set by the user, if they are not
// they won't be loaded to the player because, youtube api
// will use defaults parameters when player created.

- (void)setIsPlayerLoaded:(BOOL)isPlayerLoaded
{
    if (self.loadPlayerDic.count)
    {
        if ([self.loadPlayerDic[0] isEqualToString:@"loadPlayerWithVideosId"])
        {
            [self loadPlaylist:[NSString stringFromVideoIdArray:self.loadPlayerDic[1]] index:0 startSeconds:0.0 suggestedQuality:kJVPlaybackQualityHD720];
            
            
            //bache dalta ki lagol de code timing wala
        }
    }
    
    _isPlayerLoaded = isPlayerLoaded;
}


- (void)setAllowAutoResizingPlayerFrame:(BOOL)allowAutoResizingPlayerFrame
{
    if (allowAutoResizingPlayerFrame)
    {
        // current device
        UIDevice *device = [UIDevice currentDevice];
        
        //Tell it to start monitoring the accelerometer for orientation
        [device beginGeneratingDeviceOrientationNotifications];
        //Get the notification centre for the app
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];
    }
    
    _allowAutoResizingPlayerFrame = allowAutoResizingPlayerFrame;
}


//@synthesize autohide = _autohide;
//@synthesize autoplay = _autoplay;
//@synthesize cc_load_policy = _cc_load_policy;
//@synthesize color = _color;
//@synthesize controls = _controls;
//@synthesize disablekb = _disablekb;
//@synthesize enablejsapi = _enablejsapi;
//@synthesize end = _end;
//@synthesize fullscreen = _fullscreen;
//@synthesize iv_load_policy = _iv_load_policy;
//@synthesize list = _list;
//@synthesize listType = _listType;
//@synthesize loops = _loops;
//@synthesize modestbranding = _modestbranding;
//@synthesize playerapiid = _playerapiid;
//@synthesize playList = _playList;
//@synthesize playsinline = _playsinline;
//@synthesize rel = _rel;
//@synthesize showinfo = _showinfo;
//@synthesize start = _start;
//@synthesize theme = _theme;
//@synthesize hd = _hd;
//@synthesize hd720 = _hd720;
//@synthesize hd1080 = _hd1080;


#pragma mark - Customs Setters and Getters

- (void)setAutohide:(BOOL)autohide
{
    if (autohide)
    {
        [self.dicParameters setObject:@(1) forKey:@"autohide"];
    }
    
    _autohide = autohide;
}


- (void)setAutoplay:(BOOL)autoplay
{
    if(autoplay)
    {
        [self.dicParameters setObject:@(1) forKey:@"autoplay"];
    }
    
    _autoplay = autoplay;
}


- (void)setCc_load_policy:(BOOL)cc_load_policy
{
    if (cc_load_policy)
    {
        [self.dicParameters setObject:@(1) forKey:@"cc_load_policy"];
    }
    
    _cc_load_policy = cc_load_policy;
}


- (void)setColor:(BOOL)color
{
    if (color)
    {
        [self.dicParameters setObject:@"white" forKey:@"color"];
    }
    
    _color = color;
}


- (void)setControls:(BOOL)controls
{
    if (controls)
    {
        [self.dicParameters setObject:@(0) forKey:@"controls"];
    }
    
    _controls = controls;
}


- (void)setDisablekb:(BOOL)disablekb
{
    if (disablekb)
    {
        [self.dicParameters setObject:@(1) forKey:@"disablekb"];
    }
    
    _disablekb = disablekb;
}


- (void)setEnablejsapi:(BOOL)enablejsapi
{
    if (enablejsapi)
    {
        [self.dicParameters setObject:@(1) forKey:@"enablejsapi"];
    }
    
    _enablejsapi = enablejsapi;
}


- (void)setEnd:(NSInteger)end
{
    if (end)
    {
        [self.dicParameters setObject:@(end) forKey:@"end"];
    }
    
    _end = end;
}


- (void)setFullscreen:(BOOL)fullscreen
{
    if (fullscreen)
    {
        [self.dicParameters setObject:@(0) forKey:@"fs"];
    }
    
    _fullscreen = fullscreen;
}


- (void)setIv_load_policy:(BOOL)iv_load_policy
{
    if (iv_load_policy)
    {
        [self.dicParameters setObject:@(3) forKey:@"iv_load_policy"];
    }
    
    _iv_load_policy = iv_load_policy;
}


- (void)setList:(NSString *)list
{
    if (list.length > 0)
    {
        [self.dicParameters setObject:list forKey:@"list"];
    }
    
    _list = list;
}


- (void)setListType:(NSString *)listType
{
    if (listType.length > 0)
    {
        [self.dicParameters setObject:listType forKey:@"listType"];
    }
    
    _listType = listType;
}


- (void)setLoops:(BOOL)loops
{
    if (loops)
    {
        [self.dicParameters setObject:@(1) forKey:@"loop"];
    }
    
    _loops = loops;
}


- (void)setModestbranding:(BOOL)modestbranding
{
    if (modestbranding)
    {
        [self.dicParameters setObject:[NSNumber numberWithInt:1] forKey:@"modestbranding"];
    }
    
    _modestbranding = modestbranding;
}


- (void)setPlayerapiid:(NSString *)playerapiid
{
    if (playerapiid.length)
    {
        [self.dicParameters setObject:playerapiid forKey:@"playerapiid"];
    }
    
    _playerapiid = playerapiid;
}


- (void)setPlayList:(NSString *)playList
{
    if (playList.length)
    {
        [self.dicParameters setObject:playList forKey:@"playlist"];
    }
    
    _playList = playList;
}


- (void)setPlaysinline:(BOOL)playsinline
{
    if (playsinline)
    {
        [self.dicParameters setObject:@(1) forKey:@"playsinline"];
    }
    
    _playsinline = playsinline;
}


- (void)setRel:(BOOL)rel
{
    if (rel)
    {
        [self.dicParameters setObject:@(1) forKey:@"rel"];
    }
    
    _rel = rel;
}


- (void)setShowinfo:(BOOL)showinfo
{
    if (showinfo)
    {
        [self.dicParameters setObject:@(1) forKey:@"showinfo"];
    }
    else
    {
        [self.dicParameters setObject:@(0) forKey:@"showinfo"];
    }
    
    _showinfo = showinfo;
}


- (void)setStart:(NSInteger)start
{
    if (start)
    {
        [self.dicParameters setObject:@(start) forKey:@"start"];
    }
    
    _start = start;
}


- (void)setTheme:(BOOL)theme
{
    if (theme)
    {
        [self.dicParameters setObject:@"light" forKey:@"theme"];
    }
    
    _theme = theme;
}


- (void)setHd:(BOOL)hd
{
    if(hd)
    {
        [self.dicParameters setObject:@(1) forKey:@"hd"];
    }
    
    _hd = hd;
}


- (void)setHd720:(BOOL)hd720
{
    if (hd720)
    {
        [self.dicParameters setObject:@"hd720" forKey:@"vq"];
    }
    
    _hd720 = hd720;
}


- (void)setHd1080:(BOOL)hd1080
{
    if (hd1080)
    {
        [self.dicParameters setObject:@"hd1080" forKey:@"vq"];
    }
    
    _hd1080 = hd1080;
}

@end