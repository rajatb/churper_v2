//
//  LoginViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "User.h"


@interface LoginViewController ()

- (IBAction)onLogin:(id)sender;
@property(strong, nonatomic) TwitterClient *twitterClient;
@property(strong, nonatomic) NSMutableArray *tweets;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.twitterClient = [TwitterClient instance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     NSLog(@"I am in ViewDid load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    
    [self.twitterClient login];
    
}

-(void) loadHomeTimeLineTweets {
    
    [self.twitterClient homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        self.tweets = [tweets mutableCopy];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error getting Tweets homeTimeLine");
    }];
    //tableViewLoadData
}
@end
