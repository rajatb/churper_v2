//
//  ComposeTweetViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "ComposeTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "TwitterClient.h"



@interface ComposeTweetViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tweetNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreenNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileViewImage;
@property (strong, nonatomic) User *currentUser;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (strong,nonatomic)UILabel *countLabel;
@property (strong,nonatomic)Tweet *tweetReplied;


@end

NSInteger const MAX_TWEET_COUNT = 140;

@implementation ComposeTweetViewController

NSString * const UserReplyTweetNotification = @"UserReplyTweetNotification";


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tweetTextView becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   User * currentUser = [User currentUser];
    [self configureNavigationBar];
    
    self.tweetNameLabel.text = currentUser.name;
    self.tweetScreenNameLabel.text = currentUser.screen_name;
    [self.profileViewImage setImageWithURL:[NSURL URLWithString:currentUser.profile_image_url]];
    self.profileViewImage.layer.cornerRadius = 5;
    self.profileViewImage.clipsToBounds = YES;
    self.tweetTextView.delegate = self;
    
    
    
    if (self.tweet) {
      self.tweetTextView.text = [NSString stringWithFormat:@"@%@ ", self.tweet.screenName];
    }
    //Call this after setting the screen name in the textView.
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)MAX_TWEET_COUNT-self.tweetTextView.text.length];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)configureNavigationBar
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    NSString *tweetButtonTitle = @"Tweet";
    if (self.tweet) {
        tweetButtonTitle = @"Reply";
    }
    
    UIBarButtonItem *tweetButton = [[UIBarButtonItem alloc] initWithTitle:tweetButtonTitle style:UIBarButtonItemStylePlain target:self action:@selector(tweetAction)];
    self.navigationItem.rightBarButtonItem = tweetButton;
    
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 12, 40, 20)];
    self.countLabel.textColor = [UIColor whiteColor];
    [self.navigationController.navigationBar addSubview:self.countLabel];
    
    
    
    
}

-(void)cancelAction{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)tweetAction {
    NSNumber *tweetStatusIdForReply = nil;
    if(self.tweet){
        tweetStatusIdForReply = self.tweet.id;
    }
    NSString *tweetStatus = self.tweetTextView.text;
    
    [[TwitterClient instance] statusUpdateWithStatus:tweetStatus inReplyToStatusId:tweetStatusIdForReply success:^(AFHTTPRequestOperation *operation, Tweet *tweet) {
        self.tweetReplied =tweet;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserReplyTweetNotification object:self userInfo:@{@"tweet": self.tweetReplied}];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error creating new tweet");
    }];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    //Send a post to NSNotifier that has a lister on view detail page. to take the tweet and add it to the Table.
    
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)MAX_TWEET_COUNT-textView.text.length];

}



@end
