//
//  CollectionViewSnapCell.m
//  TestGame
//
//  Created by mac on 6/28/15.
//  Copyright (c) 2015 XuluLabs. All rights reserved.
//

#import "CollectionViewSnapCell.h"

@implementation CollectionViewSnapCell

- (void)awakeFromNib {
    // Initialization code
   // self.collectionImageView.layer.cornerRadius = 30; //
    
    //self.collectionImageView.layer.cornerRadius =self.collectionImageView.frame.size.width / 1.8;
    //  itemImageView.layer.cornerRadius = 25;
    
    UIColor *color = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
  
    // colViewCell.collectionImageView.clipsToBounds = YES;
    self.collectionImageView.layer.masksToBounds = YES;

    
    
   self.collectionImageView.layer.cornerRadius = 25;

   // self.collectionImageView.layer.cornerRadius = 150.0f;
    self.collectionImageView.layer.borderWidth = 1.0f;
    self.collectionImageView.layer.borderColor = color.CGColor;
    self.collectionImageView.clipsToBounds = YES;
//    
//   self.collectionImageView.layer.cornerRadius = self.collectionImageView.frame.size.width / 2;
//
//    self.collectionImageView.clipsToBounds = YES;
//    self.collectionImageView.layer.borderWidth = 3.0f;
//    self.collectionImageView.layer.borderColor = [UIColor redColor].CGColor;
}

@end
