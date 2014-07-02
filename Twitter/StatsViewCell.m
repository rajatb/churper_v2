//
//  StatsViewCell.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/30/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "StatsViewCell.h"

@interface StatsViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblTweetCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowingCount;

@property (weak, nonatomic) IBOutlet UILabel *lblFollowerCount;

@end

@implementation StatsViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(User *)user {
    _user = user;
    self.lblFollowerCount.text = [_user.followers_count stringValue];
    self.lblTweetCount.text = [_user.statuses_count stringValue];
    self.lblFollowingCount.text = [_user.friends_count stringValue];
}

@end
