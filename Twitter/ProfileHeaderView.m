//
//  ProfileHeaderView.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/30/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "TwitterClient.h";

@interface ProfileHeaderView()  {

}

@end

@implementation ProfileHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UINib *nib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:nil];
        NSArray *objects = [nib instantiateWithOwner:self options:nil];
        [self addSubview:objects[0]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setUser:(User *)user {
    _user = user;
    self.lblScreenName.text = user.screen_name;
    self.lblName.text = user.name;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:user.profile_image_url]];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES; 
    [self loadBanner];
    
    self.bannerImageView.clipsToBounds = YES;
    
  
    
}

-(void) loadBanner  {
    
    [[TwitterClient instance]getBanner: self.user.screen_name success:^(AFHTTPRequestOperation *operation, NSString *url) {
        self.user.bannerImageUrl = url;
        [self.bannerImageView setImageWithURL:[NSURL URLWithString:self.user.bannerImageUrl]];
        self.bannerImageView.clipsToBounds = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"No banner!:%@",error.description);
    }];
    
}

@end
