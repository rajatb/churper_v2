//
//  ProfileViewController.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/30/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface ProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,assign) BOOL isCurrentUser;
@property (strong, nonatomic) Tweet *tweetForProfile;

@end
