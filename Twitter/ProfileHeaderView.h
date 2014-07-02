//
//  ProfileHeaderView.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/30/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileHeaderView : UIView
@property(strong,nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;

@end
