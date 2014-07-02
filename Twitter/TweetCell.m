//
//  TweetCell.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+DateTools.h"
#import "TwitterClient.h"
#import "ComposeTweetViewController.h"
#import "AppDelegate.h"
#import "MHPrettyDate.h"

@interface TweetCell()
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreenNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;
@property (weak, nonatomic) IBOutlet UIButton *favButton;
- (IBAction)retweetButton:(id)sender;
- (IBAction)replyButton:(id)sender;
- (IBAction)favButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *retweetStaticImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenNameConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeConstraint;


@end

@implementation TweetCell

NSDateFormatter *_formatter;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    [self showRetweetInfo:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.tweetLabel.text = self.tweet.text;
    
    
    self.tweetNameLabel.text = self.tweet.name;
    self.tweetScreenNameLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.screenName];
    [self.tweetImage setImageWithURL:[NSURL URLWithString:self.tweet.profileImageUrl]];
    
    self.tweetImage.layer.cornerRadius = 5;
    self.tweetImage.clipsToBounds=YES;
    self.tweetImage.layer.borderColor = [[UIColor blackColor] CGColor];
    self.favoriteImageView.image = [UIImage imageNamed:@"star"];
    self.favoriteImageView.clipsToBounds = YES;
   // UIImage *favImg = [UIImage imageNamed:@"favorite"];
   // UIImage *favOnImg = [UIImage imageNamed:@"favorite_on"];
    
   // [self.favButton setImage:favImg forState:UIControlStateNormal];
   // [self.favButton setImage:favOnImg forState:UIControlStateHighlighted];
     //For date
    self.favButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;
    
    NSString *retweetName = self.tweet.retweetedByName;
    if (retweetName) {
        [self showRetweetInfo:YES];
         self.retweetLabel.text = [NSString stringWithFormat:@"@%@ retweeted", retweetName];
    }
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    
    self.tweetTime.text = [MHPrettyDate prettyDateFromDate:[_formatter dateFromString:self.tweet.dateCreated] withFormat:MHPrettyDateShortRelativeTime];
    
}

- (IBAction)retweetButton:(id)sender {
    [[TwitterClient instance] retweetWithTweetId:self.tweet.id failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet Failed With Description:%@", error.description);
    }];
    self.tweet.retweeted = YES;
    self.retweetButton.selected = self.tweet.retweeted;
    self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] + 1];
}

- (IBAction)replyButton:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:UserWantsToReplyNotification object:self userInfo:@{@"tweet": self.tweet}];
    
}

- (IBAction)favButton:(id)sender {
    NSNumber *tweetId = self.tweet.id;
    TwitterClient *twitterClient = [TwitterClient instance];
    if(self.tweet.favorited){
        [twitterClient defavoriteWithTweetId:tweetId failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"De fav tweet failed!: %@",error.description);
        }];
         self.tweet.favoritesCount = [NSNumber numberWithInt:[self.tweet.favoritesCount intValue] - 1];
    } else {
        [twitterClient favoriteWithTweetId:tweetId failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Fav Tweet failed! : %@", error.description);
        }];
         self.tweet.favoritesCount = [NSNumber numberWithInt:[self.tweet.favoritesCount intValue] +1];
    }
    self.tweet.favorited = !self.tweet.favorited;
    self.favButton.selected = self.tweet.favorited;
    
}

- (void)showRetweetInfo:(BOOL)show {
    self.retweetLabel.hidden = !show;
    self.retweetStaticImageView.hidden = !show;
    if (show) {
        self.imageViewConstraint.constant = 30;
        self.nameLabelContraint.constant = 30;
        self.screenNameConstraint.constant = 30;
        self.timeConstraint.constant = 30;
    } else {
        self.imageViewConstraint.constant = 10;
        self.nameLabelContraint.constant = 10;
        self.screenNameConstraint.constant = 10;
        self.timeConstraint.constant = 10;
    }
  
}

@end
