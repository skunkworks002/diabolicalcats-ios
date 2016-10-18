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

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic, strong) NSMutableArray * vidosListMArray;
@property (nonatomic, strong) NSString * channelTitleName;

@property (weak, nonatomic) IBOutlet UILabel *titaleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *unlikeBtn;


@end


