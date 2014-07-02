//
//  TweetCell.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"



@interface TweetCell : UITableViewCell

@property(strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;

@end
