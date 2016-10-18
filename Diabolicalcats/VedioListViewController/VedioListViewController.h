//
//  VedioListViewController.h
//  Diabolicalcats
//
//  Created by Xululabs on 01/09/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVYoutubePlayer.h"

@interface VedioListViewController : UIViewController <JVYoutubePlayerDelegate>

@property (nonatomic, strong) JVYoutubePlayerView *player;

@property (nonatomic, strong) NSMutableArray * vidosListMArray;

@property (nonatomic, strong) NSString * channelTitleName;

@property (weak, nonatomic) IBOutlet UILabel *titaleNameLabel;

@end


