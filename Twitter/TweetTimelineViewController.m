//
//  TweetTimelineViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "TweetTimelineViewController.h"
#import "User.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeTweetViewController.h"
#import "SVProgressHUD.h"
#import "DetailTweetViewController.h"


@interface TweetTimelineViewController ()

@property(strong, nonatomic) LoginViewController *loginVC;
@property(strong, nonatomic) NSMutableArray *tweets;
@property(strong, nonatomic) TwitterClient *twitterClient;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)UIRefreshControl *refreshControl;
@property(nonatomic,strong)NSTimer *timer;

- (void) loadTweets;
@end

@implementation TweetTimelineViewController

TweetCell * _stubCell;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self configureNavigationBar];
        self.loginVC = [[LoginViewController alloc] init];
        self.twitterClient = [TwitterClient instance];
        self.tweets = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTimeLineWithNewTweet:) name:UserReplyTweetNotification object:nil];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configRefreshControl];
    
    UINib *nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"tweetCell"];
    _stubCell = [nib instantiateWithOwner:nil options:nil][0];
    
    //self.tableView.rowHeight = 130;
    NSLog(@"View Did load");
    
    [self showProgressWithStatus];
    [self loadTweets];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
  //  [self showProgressWithStatus];
  //  [self loadTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)configureNavigationBar
{
    UIBarButtonItem *signOut = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(goToSignOut:)];
    self.navigationItem.leftBarButtonItem = signOut;
    
    UIBarButtonItem *new = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(goToNew:)];
    self.navigationItem.rightBarButtonItem = new;
    
    self.navigationItem.title = @"Home";
}

-(IBAction)goToSignOut:(id)sender {
    [User setCurrentUser:nil];

    
}

-(IBAction)goToNew:(id)sender {
    ComposeTweetViewController *composeTVC = [[ComposeTweetViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:composeTVC];
    
    [self presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    TweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    tweetCell.tweet = self.tweets[indexPath.row];
    return tweetCell;
    
//    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    cell.textLabel.text = [NSString stringWithFormat:@"Row:%ld" ,(long)indexPath.row ];
//    NSLog(@"Row:%ld", indexPath.row);
//    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:_stubCell atIndexPath:indexPath];
    [_stubCell layoutSubviews];
    
    CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)configureCell:(TweetCell *)tweetCell atIndexPath:(NSIndexPath *)indexPath
{
    tweetCell.tweet = self.tweets[indexPath.row];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTweetViewController *dtvc = [[DetailTweetViewController alloc]init];
   
    dtvc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:dtvc animated:YES];
    
}

#pragma mark - Private Methods

- (void) loadTweets {
    [self.twitterClient homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
           [self.tweets addObjectsFromArray:tweets];
            [self endRefresh];
            [self.tableView reloadData];
            [self dismissProgress];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Could not load tweets.%@", error.description);
        }];
  
}

- (void) reloadNextTweets {
    NSLog(@"Next Tweets!!!");
    Tweet *tweet = [self.tweets lastObject];
    NSNumber *lastObjectId = (tweet.id ==nil)? [NSNumber numberWithInt:0] :tweet.id;
    [self.twitterClient homeTimeLineWithCount:[NSNumber numberWithInt:20] sinceId:[NSNumber numberWithInt:0] maxId:lastObjectId Success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        
        [self.tweets addObjectsFromArray:tweets];
        [self endRefresh];
        [self.tableView reloadData];
        [self dismissProgress];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Could not load tweets.%@", error.description);
    }];
    
}


#pragma mark - Pull To refresh
- (void)configRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(loadTweets) forControlEvents:UIControlEventValueChanged];
}

-(void) endRefresh {
    [self.refreshControl endRefreshing];
}


#pragma mark - Show loading
- (void)showProgressWithStatus {
    [SVProgressHUD showWithStatus:@"Loading..." ];
}

- (void)dismissProgress {
    [SVProgressHUD dismiss];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat actualPosition = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    // Start fetching data before it gets to the end of the screen
    if ((contentHeight - actualPosition < 500) && ![self.timer isValid] && (contentHeight > 0)) {
        [self showProgressWithStatus];
         self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadNextTweets) userInfo:nil repeats:NO];
    }
}

-(void)updateTimeLineWithNewTweet:(NSNotification*)notification {
    Tweet *tweet = (Tweet*)notification.userInfo[@"tweet"];
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
    
}

@end
