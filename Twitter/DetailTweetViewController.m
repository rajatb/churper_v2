//
//  DetailTweetViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/23/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "DetailTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"
#import "AppDelegate.h"
#import "TwitterClient.h"
#import <QuartzCore/QuartzCore.h>


@interface DetailTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (weak, nonatomic) IBOutlet UILabel *lblTweet;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblRetweetCount;
@property (weak, nonatomic) IBOutlet UILabel *lblFavoritesCount;
- (IBAction)replyButton:(id)sender;
- (IBAction)retweet:(id)sender;
- (IBAction)favorite:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetStaticImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelContraint;

@end

@implementation DetailTweetViewController
  NSDateFormatter *_formatter;
  NSDateFormatter *_stringFromDate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        
        _stringFromDate = [[NSDateFormatter alloc] init];
        [_stringFromDate setDateFormat:@"MM/dd/yyyy hh:mm a"];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *reply = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];
    self.navigationItem.rightBarButtonItem = reply;
    
    Tweet *tweet = self.tweet;
    [self showRetweetInfo:NO];
    
    self.lblName.text = tweet.name;
    [self.imgProfile setImageWithURL:[NSURL URLWithString:tweet.profileImageUrl]];
    self.imgProfile.layer.cornerRadius = 5;
    self.imgProfile.clipsToBounds = YES;
    self.lblScreenName.text = tweet.screenName;
    self.lblTweet.text = tweet.text;
    self.lblRetweetCount.text = [tweet.retweetCount stringValue];
    self.lblFavoritesCount.text = [tweet.favoritesCount stringValue];
    
    NSDate *dateFromString = [_formatter dateFromString:tweet.dateCreated];
    self.lblDate.text =[_stringFromDate stringFromDate:dateFromString];
    
    NSString *retweetName = self.tweet.retweetedByName;
    if (retweetName) {
        [self showRetweetInfo:YES];
        self.retweetLabel.text = [NSString stringWithFormat:@"@%@ retweeted", retweetName];
    }
    
    self.favoriteButton.selected = tweet.favorited;
    self.retweetButton.selected = tweet.retweeted;
    
}

-(void)onReplyButton {
    [[NSNotificationCenter defaultCenter] postNotificationName:UserWantsToReplyNotification object:self userInfo:@{@"tweet": self.tweet}];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (IBAction)replyButton:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:UserWantsToReplyNotification object:self userInfo:@{@"tweet": self.tweet}];
}
- (IBAction)retweet:(id)sender {
    [[TwitterClient instance] retweetWithTweetId:self.tweet.id failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Retweet Failed With Description:%@", error.description);
    }];
    self.tweet.retweeted = YES;
    self.retweetButton.selected = self.tweet.retweeted;
    self.tweet.retweetCount = [NSNumber numberWithInt:[self.tweet.retweetCount intValue] + 1];
    self.lblRetweetCount.text = [self.tweet.retweetCount stringValue];
    
}

- (IBAction)favorite:(id)sender {
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
        self.tweet.favoritesCount = [NSNumber numberWithInt:[self.tweet.favoritesCount intValue] + 1];
    }
    self.tweet.favorited = !self.tweet.favorited;
    self.favoriteButton.selected = self.tweet.favorited;
    self.lblFavoritesCount.text = [self.tweet.favoritesCount stringValue];
    
}

- (void)showRetweetInfo:(BOOL)show {
    self.retweetLabel.hidden = !show;
    self.retweetStaticImageView.hidden = !show;
    if (show) {
        self.imageViewConstraint.constant = 30;
        self.nameLabelContraint.constant = 30;
    } else {
        self.imageViewConstraint.constant = 10;
        self.nameLabelContraint.constant = 10;
    }
    
}
@end
