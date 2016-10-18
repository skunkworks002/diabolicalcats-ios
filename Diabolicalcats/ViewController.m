//
//  ViewController.m
//  Diabolicalcats
//
//  Created by Xululabs on 01/09/2016.
//  Copyright © 2016 Xulu. All rights reserved.
//

#import "ViewController.h"
#import "VedioListViewController.h"
#import "CollectionViewSnapCell.h"
#import "MBProgressHUD.h"

@interface ViewController () {
  //  NSArray *channelListArray;
   // NSArray *channelVediosListArray;
    NSString *channelTitle;

    NSMutableArray *videos;
    NSArray *channelList;
    NSArray *imagesArray;
    NSMutableArray *filteredVideostList;
    int channelInt;
}
@end

@implementation ViewController
@synthesize imagesCollectionView,searchBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    channelInt = 0;
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];//colorWithRed:59/255.0f green:142/255.0f blue:194/255.0f alpha:1.0];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    channelList = [NSArray arrayWithObjects:@"Catology",@"Kittens", nil];
    imagesArray = [NSArray arrayWithObjects:@"Catology.jpg",@"kittens.jpeg", nil];
   // [self initiateRequestToYoutubeApiAndGetChannelInfo:0];
}

-(void)initiateRequestToYoutubeApiAndGetChannelInfo:(NSInteger)channelIndex
{
    NSString *channel;// = @"UCFl1PkN6_aIKD4JVUDkZV1Q";
    
    switch (channelIndex) {
        case 0:
           channel = @"UCOTC5SnNAt4KLHoX6FxoxoQ"; // xululab channel for catalog

         //  channel = @"UC2vKValY-47ZlAL7Jvbbpzw"; // testing
            break;
        case 1:
           // infoChannel = @"UCDHTgkwCRS-S8fvxYx5eDcQ";
            channel = @"UCdAHCE7Y3dXPmqXE8tc2_Nw";
            break;
        default:
            break;
    }
    
    NSString *urlYouCanUseForChannel = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=%@&key=AIzaSyBGcJvMGd91jHoCeKnOs_3JU9RMZOHUqIw",channel];
    
    NSURL *url = [[NSURL alloc] initWithString: urlYouCanUseForChannel];
    // Create your request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // Send the request asynchronously remember to reload tableview on global thread
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // Callback, parse the data and check for errors
        if (data && !connectionError) {
            NSError *jsonError;
            NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (!jsonError) {
                // better put a breakpoint here to see what is the result and how it is brought to you. Channel id name etc info should be there
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"%@",jsonResult);
                    
                    id keyValuePairDict = jsonResult;
                    
                    videos = keyValuePairDict[@"items"];
                    
                    //  [self programeTimeSearchingMethode:videos];
                    [self performSegueWithIdentifier:@"VedioListViewController" sender:videos];
                    
                });

                
                
               // [imagesCollectionView reloadData];
            }
            else
            {
                NSLog(@"an error occurred");
            }
        }
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"Channels";
    //[self channelListCallingMethode];
    [imagesCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewSnapCell" bundle:[NSBundle mainBundle]]
           forCellWithReuseIdentifier:@"CollectionViewSnapCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   // return videos.count;
    return channelList.count;
   
}


- (CollectionViewSnapCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewSnapCell *colViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewSnapCell" forIndexPath:indexPath];    
   
      colViewCell.collectionTitleLabel.text = [channelList objectAtIndex:indexPath.row];
    colViewCell.collectionImageView.image = [UIImage imageNamed:[imagesArray objectAtIndex:indexPath.row]];
    

       return colViewCell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   NSInteger abc = indexPath.row;
   // [self performSegueWithIdentifier:@"VedioListViewController" sender:nil];
    channelTitle = [channelList objectAtIndex:indexPath.row];
    
     [self initiateRequestToYoutubeApiAndGetChannelInfo:abc];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height == 480) {
            // 3.5 inch display - iPhone 4S and below
        }
        else if (result.height == 568) {
            // 4 inch display - iPhone 5
            return CGSizeMake(90, 130);
        }
        else if (result.height == 667) {
            // 4.7 inch display - iPhone 6
            return CGSizeMake(100, 140);
        }
        else if (result.height == 736) {
            // 5.5 inch display - iPhone 6 Plus
        }
    }
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // iPad 9.7 or 7.9 inch display.
    }
    return CGSizeMake(100, 140);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSMutableArray*)sender {
    if ([[segue identifier] isEqualToString:@"VedioListViewController"]) {
        VedioListViewController    *destinationView = (VedioListViewController*)segue.destinationViewController;
        destinationView.vidosListMArray = sender;
        destinationView.channelTitleName = channelTitle;
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
    [[self imagesCollectionView] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
