//
//  VedioListViewController.m
//  Diabolicalcats
//
//  Created by Xululabs on 01/09/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "VedioListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SphereMenu.h"
#import "Chameleon.h"
#import "TOActionSheet.h"
#import "ViewController.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

static NSString const *api_key =@"AIzaSyAnNzksYIn-iEWWIvy8slUZM44jH6WjtP8"; // public youtube api key

@interface VedioListViewController () <SphereMenuDelegate> {
    int vedioIndexStart;
    int vedioIndexCount;
    int timerInt;
    int channelInt;
    
    BOOL chanlTimeCheckBool;
    NSTimer *timer;
    NSMutableArray *filteredVideostList;
}

@property (nonatomic) int counter;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL isInBackgroundMode;
@property (nonatomic, strong) SphereMenu *sphereMenu;

@end

@implementation VedioListViewController
@synthesize vidosListMArray,shareButton,channelTitleName,titaleNameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    channelInt = 0;
    timerInt = 0;
    chanlTimeCheckBool = true;
   // NSLog(@"%@",channelTitleName);
    titaleNameLabel.text = channelTitleName;
        // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];//colorWithRed:59/255.0f green:142/255.0f blue:194/255.0f alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.topItem.title = @"";
    
    
   // [self.player loadPlayerWithPlaylistId:@"PLEE58C6029A8A6ADE"];
    //[self.player loadPlayerWithPlaylistId:@"PLiXYklYYAZz6dbezu6CpxX8Rl2no2lVeC"];

    [self programeTimeSearchingMethode];

   // vedioIndexStart = 0;
 
    NSArray *colors = @[FlatBlue, FlatGray, FlatMintDark, FlatPlum];
 
    self.view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                                                      withFrame:self.view.frame
                                                      andColors:colors];
    
   // [self.player loadPlayerWithVideosURL:filteredVideostList];

   
     // adding to subview
 [self.view addSubview:self.player];
}

-(void)programeTimeSearchingMethode {
    filteredVideostList = [[NSMutableArray alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
    [gmtDf setTimeZone:[NSTimeZone timeZoneWithName:@"US/Eastern"]];
    [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* gmtDate = [gmtDf stringFromDate:date];
    NSLog(@"%@",gmtDate);
    NSDateFormatter* estDf = [[NSDateFormatter alloc] init];
    [estDf setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *estDate = [estDf dateFromString:[gmtDf stringFromDate:date]]; // you can also use str
    NSLog(@"%@",estDate);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mma"];
    NSString *currentTime = [formatter stringFromDate:estDate];
    
    
    NSMutableArray* listTitle = [[NSMutableArray alloc]init];
    NSMutableArray* playListIds = [[NSMutableArray alloc]init];
    NSMutableArray *defultArray = [[NSMutableArray alloc]init];
    
    
    
    for (int i = 0; i< vidosListMArray.count; i++) {
        NSArray *titl = [vidosListMArray objectAtIndex:i];
        NSArray *titleee = [titl valueForKey:@"snippet"];
        
        NSString *channelId = [titl valueForKey:@"id"];
        NSString *titles = [titleee valueForKey:@"title"];
        [playListIds addObject:channelId];
        [listTitle addObject:titles];
        
        
        // use defult array
        NSString* yourString = @"Default_00:00PM-00:00PM";
        
        if([[listTitle objectAtIndex:i] isEqualToString: yourString])
        {
            defultArray = [vidosListMArray objectAtIndex:i];
        }
    }
    
    
    if (listTitle.count > channelInt) {
   
        NSString *checkingForTimeMatch = [listTitle objectAtIndex:channelInt];
    NSArray *separatedString = [checkingForTimeMatch componentsSeparatedByString:@"_"];
    NSString*firstString0 = [separatedString objectAtIndex:1];
    NSArray *separatedString2 = [firstString0 componentsSeparatedByString:@"-"];
    NSString *programEndTimeArray = [separatedString2 objectAtIndex:1];
    NSString *programStartTimeArray = [separatedString2 objectAtIndex:0];
    //    NSString *currentTime = @"6:39pm";
    
    // NSString *startTimeStr;
    // NSString *endTimeStr;
    NSString *programeTimeEnd;
    NSComparisonResult startResult;
    NSComparisonResult endResult;
    NSArray *urlForVedio;
    
        
    startResult = [currentTime compare:programStartTimeArray];
    endResult = [currentTime compare:programEndTimeArray];
        
        
        
        
    
    if ((startResult == NSOrderedSame || startResult == NSOrderedDescending )&& endResult == NSOrderedAscending) {
        timerInt = 0;
        urlForVedio = [playListIds objectAtIndex:channelInt];
        [filteredVideostList addObject:urlForVedio];
        programeTimeEnd = programEndTimeArray;
    }
    else {
        channelInt = channelInt+1;
    }
    
    if (filteredVideostList.count != 0){
            if ([currentTime isEqualToString:programeTimeEnd]) {
                chanlTimeCheckBool = true;
            }
            [self loadPlayerVedios];
        }
            else {
                [self nextPlayList];
            }
    }
    else {
        channelInt = 0;

                    if (timerInt == 0) {
                        timerInt = 1;
                        // NSArray *videosUrl = @[@"https://www.youtube.com/watch?v=8eTG0cHaDqk"];
                        // [self.player loadPlayerWithVideosURL:videosUrl];
                        //   NSString *playListId = [playListIds objectAtIndex:3];


                        
                       // NSArray *titl = [defultArray objectAtIndex:0];
                       // NSArray *titleee = [defultArray valueForKey:@"snippet"];
                        
                        NSString *playListId = [defultArray valueForKey:@"id"];
                        
                      //  NSString *playListId = [playListIds valueForKey: @"@lastObject"];

                        
                        
                        
                        [self.player loadPlayerWithPlaylistId:playListId];

                    }
    }
}

-(void)nextPlayList {
    [self programeTimeSearchingMethode];
}

-(void)loadPlayerVedios {

    if (chanlTimeCheckBool == true) {
    
        NSString *playlistId = [filteredVideostList objectAtIndex:0];
        
        [self.player loadPlayerWithPlaylistId:playlistId];

//    [self.player loadPlayerWithVideosURL:filteredVideostList];
    chanlTimeCheckBool = false;
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableArray*)sender {
    if ([[segue identifier] isEqualToString:@"ViewController"]) {
        ViewController    *destinationView = (ViewController*)segue.destinationViewController;
    }
}

 - (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 
 // Turn on remote control event delivery
 [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
 
 // Set itself as the first responder
 [self becomeFirstResponder];
 
 [self requestSerachVideo];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 
 // Turn off remote control event delivery
 [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
 
 // Resign as first responder
 [self resignFirstResponder];
 }
 
 - (void)didReceiveMemoryWarning
 {
 [super didReceiveMemoryWarning];
 }
 
 - (void)dealloc
 {
 [[NSNotificationCenter defaultCenter] removeObserver:self
 name:UIApplicationDidEnterBackgroundNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter] removeObserver:self
 name:UIApplicationWillResignActiveNotification
 object:nil];
 }
 
 
 - (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
 {
 if (receivedEvent.type == UIEventTypeRemoteControl)
 {
 switch (receivedEvent.subtype) {
 
 case UIEventSubtypeRemoteControlTogglePlayPause:
 if(self.player.playerState == kJVPlayerStatePaused || self.player.playerState == kJVPlayerStateEnded || self.player.playerState == kJVPlayerStateUnstarted || self.player.playerState == kJVPlayerStateUnknown || self.player.playerState == kJVPlayerStateQueued || self.player.playerState == kJVPlayerStateBuffering)
 {
 [self.player playVideo];
 }
 else {
 [self.player pauseVideo];
 }
 break;
 
 case UIEventSubtypeRemoteControlPreviousTrack:
 [self.player previousVideo];
 break;
 
 case UIEventSubtypeRemoteControlNextTrack:
 [self.player nextVideo];
 
 break;
 
 default:
 break;
 }
 }
 }

 -(void)perivousevideoPlay {
 
 }
 
 #pragma mark -
 #pragma mark Getters and Setters
 
 - (JVYoutubePlayerView *)player
 {
 if(!_player)
 {

     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
         
         CGSize result = [[UIScreen mainScreen] bounds].size;
         
         if (result.height == 480) {
             // 3.5 inch display - iPhone 4S and below
         }
         
         else if (result.height == 568) {
             // 4 inch display - iPhone 5
             _player = [[JVYoutubePlayerView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 340)];
         }
         
         else if (result.height == 667) {
             // 4.7 inch display - iPhone 6
             _player = [[JVYoutubePlayerView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 420)];

         }
         
         else if (result.height == 736) {
             // 5.5 inch display - iPhone 6 Plus
             _player = [[JVYoutubePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 480)];

         }
         
         else {
             _player = [[JVYoutubePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 450)];

         }
     }
     

     
     
     
//     _player = [[JVYoutubePlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 400)];
 _player.delegate = self;
 
 _player.autoplay = YES;
 
 _player.modestbranding = YES;
 _player.allowLandscapeMode = YES;
 _player.forceBackToPortraitMode = NO;
 _player.allowAutoResizingPlayerFrame = YES;
 _player.fullscreen = YES;
 _player.playsinline = YES;
 _player.allowBackgroundPlayback = YES;
     
 }
 
 return _player;
 }
 
 - (SphereMenu *)sphereMenu
 {
 if(!_sphereMenu)
 {
 _sphereMenu.delegate = self;
 }
 
 return _sphereMenu;
 }
 
 
 #pragma mark -
 #pragma mark Player delegates
 
 - (void)playerView:(JVYoutubePlayerView *)playerView didChangeToQuality:(JVPlaybackQuality)quality
 {
 [_player setPlaybackQuality:kJVPlaybackQualityHD720];
   
         
          timer = [NSTimer scheduledTimerWithTimeInterval:03.0f target:self selector:@selector(programeTimeSearchingMethode) userInfo:nil repeats:YES];
}

 #pragma mark -
 #pragma mark Helper Functions
 
 - (void)sphereDidSelected:(int)index
 {
 if(index == 1)
 {
 if(self.player.playerState == kJVPlayerStatePaused || self.player.playerState == kJVPlayerStateEnded || self.player.playerState == kJVPlayerStateUnstarted || self.player.playerState == kJVPlayerStateUnknown || self.player.playerState == kJVPlayerStateQueued || self.player.playerState == kJVPlayerStateBuffering)
 {
 [self.player playVideo];
 }
 else
 {
 [self.player pauseVideo];
 self.counter = 0;
 }
 }
 else if(index == 0)
 {
 vedioIndexCount = vedioIndexStart --;
 
 [self nextVideoPlay:vedioIndexCount];
 
 
 //[self.player previousVideo];
 }
 else
 {
 vedioIndexCount = vedioIndexStart ++;
 
 [self nextVideoPlay:vedioIndexCount];
 
 //        [self.player nextVideo];
 }
 
 }
 
 
 -(void)nextVideoPlay:(int)vedioPlayIndex {
 
 if (vedioPlayIndex == 0) {
     NSString *url = [filteredVideostList objectAtIndex:0];
     [self.player loadPlayerWithVideoURL:url];
     //[self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=a18py61_F_w"];
 
 } else if (vedioPlayIndex == 1){
     
     NSString *url = [filteredVideostList objectAtIndex:1];
     [self.player loadPlayerWithVideoURL:url];
     
// [self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=9nZMHBDw8os"];
 }
 else if (vedioPlayIndex == 2){
     
     NSString *url = [filteredVideostList objectAtIndex:2];
     [self.player loadPlayerWithVideoURL:url];
     
 //[self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=JD1k4_d0S1Y"];
 }
 else{
 
     NSString *url = [filteredVideostList objectAtIndex:vedioPlayIndex];
     [self.player loadPlayerWithVideoURL:url];

//     [self.player loadPlayerWithVideoURL:@"https://www.youtube.com/watch?v=RN36RzSjWNw"];
 }
 
 }
 
 
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
 return UIStatusBarStyleLightContent;
 }
 
 - (void)playerViewDidBecomeReady:(JVYoutubePlayerView *)playerView
 {
 // loading a set of videos to the player after the player has finished loading
 // NSArray *videoList = @[@"m2d0ID-V9So", @"c7lNU4IPYlk"];
 // [self.player loadPlaylistByVideos:videoList index:0 startSeconds:0.0 suggestedQuality:kJVPlaybackQualityHD720];
 }
 
 #pragma mark -
 #pragma mark Notifications
 
 - (void)appIsInBakcground:(NSNotification *)notification
 {
 //    [self.player playVideo];
 }
 
 - (void)appWillBeInBakcground:(NSNotification *)notification
 {
 // self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(keepPlaying) userInfo:nil repeats:YES];
 // self.isInBackgroundMode = YES;
 // [self.player playVideo];
 }
 
 - (void)keepPlaying
 {
 if(self.isInBackgroundMode)
 {
 [self.player playVideo];
 self.isInBackgroundMode = NO;
 }
 else
 {
     
 [self.timer invalidate];
 self.timer = nil;
     
 }
 }
 
 
 #pragma mark - testing request to youtube
 
 - (void)requestSerachVideo
 {
 // Set up your URL
 NSString *youtubeApi = @"https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=house&key=AIzaSyDJA2UzTIn6py0Zf4U_88h73e4h-L9gLzs";
 NSURL *url = [[NSURL alloc] initWithString:youtubeApi];
 
 // Create your request
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
 // Send the request asynchronously
 [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
 
 // Callback, parse the data and check for errors
 if (data && !connectionError)
 {
 NSError *jsonError;
 NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
 
 if (!jsonError)
 {
     //this is vedio json response from url
     
     NSLog(@"Response from YouTube: %@", jsonResult);
 }
 }
 }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [[self navigationController] setNavigationBarHidden:UIInterfaceOrientationIsLandscape(toInterfaceOrientation) animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:UIInterfaceOrientationIsLandscape(toInterfaceOrientation) animated:YES];
}

/*
 
 -(void)programeSearchingMethode {
 filteredVideostList = [[NSMutableArray alloc] init];
 
 NSDate *date = [NSDate date];
 NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
 [gmtDf setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
 [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString* gmtDate = [gmtDf stringFromDate:date];
 NSLog(@"%@",gmtDate);
 NSDateFormatter* estDf = [[NSDateFormatter alloc] init];
 [estDf setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
 [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *estDate = [estDf dateFromString:[gmtDf stringFromDate:date]]; // you can also use str
 NSLog(@"%@",estDate);
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"h:mma"];
 NSString *currentTime = [formatter stringFromDate:estDate];// @"7:00pm";
 
 
 
 NSMutableArray *programArray = [vidosListMArray valueForKey:@"programes"];
 NSMutableArray *programUrlsArray = [programArray valueForKey:@"url"];
 
 NSMutableArray *programEndTimeArray = [programArray valueForKey:@"endTime"];
 NSMutableArray *programStartTimeArray = [programArray valueForKey:@"startTime"];
 //    NSString *currentTime = @"6:39pm";
 
 NSString *startTimeStr;
 NSString *endTimeStr;
 NSString *programeTimeEnd;
 NSComparisonResult startResult;
 NSComparisonResult endResult;
 NSArray *urlForVedio;
 
 NSString* defultUrl = [vidosListMArray valueForKey:@"defaultUrl"];
 
 
 i = 0;
 
 for (int j =i ; programArray.count > j ; j++) {
 startTimeStr = [programStartTimeArray objectAtIndex:j];
 endTimeStr = [programEndTimeArray objectAtIndex:j];
 
 startResult = [currentTime compare:startTimeStr];
 endResult = [currentTime compare:endTimeStr];
 
 
 if ((startResult == NSOrderedSame || startResult == NSOrderedDescending )&& (endResult == NSOrderedSame || endResult == NSOrderedAscending)) {
 
 urlForVedio = [programUrlsArray objectAtIndex:j];
 [filteredVideostList addObject:urlForVedio];
 programeTimeEnd = endTimeStr;
 }
 else {
 i = i+1;
 }
 }
 NSLog(@"%@",filteredVideostList);
 
 if (filteredVideostList.count == 0 && defultUrl!= (id)[NSNull null]) {
 
 if (timerInt == 0) {
 timerInt = 2;
 [filteredVideostList addObject:defultUrl];
 [self.player loadPlayerWithVideosURL:filteredVideostList];
 }
 }
 
 else if (filteredVideostList.count != 0){
 if ([currentTime isEqualToString:programeTimeEnd]) {
 chanlTimeCheckBool = true;
 }
 [self loadPlayerVedios];
 }
 }

 */

/*
 -(void)runMethod {
 //  NSString *date = [NSDate date];
 
 NSDate *date = [NSDate date];
 
 // NSString *str = @"2016-09-26 14:01:26";
 
 NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
 [gmtDf setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
 [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSString* gmtDate = [gmtDf stringFromDate:date];
 NSLog(@"%@",gmtDate);
 
 NSDateFormatter* estDf = [[NSDateFormatter alloc] init];
 [estDf setTimeZone:[NSTimeZone timeZoneWithName:@"EST"]];
 [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
 NSDate *estDate = [estDf dateFromString:[gmtDf stringFromDate:date]]; // you can also use str
 NSLog(@"%@",estDate);
 
 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 [formatter setDateFormat:@"h:mma"];
 NSString *timeString = [formatter stringFromDate:estDate];// @"7:00pm";
 
 // NSLog(@"time current %@",timeString);
 
 NSArray *endTimeC = [vidosListMArray objectAtIndex:0];// @"10:00:00";
 NSString *endTime = [endTimeC valueForKey:@"endTime"];
 
 if ([timeString isEqualToString:endTime]) {
 NSLog(@"stop vedio time up");
 
 [self.player stopVideo];
 [self.player removeFromSuperview];
 
 UIAlertView *loginAlert = [[UIAlertView alloc]initWithTitle:nil message:@"Program Time Up." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
 [loginAlert show];
 [self performSegueWithIdentifier:@"ViewController" sender:nil];
 
 }
 }
 */



@end
