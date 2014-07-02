//
//  ProfileViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/30/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileHeaderView.h"
#import "TweetCell.h"
#import "User.h"
#import "TwitterClient.h"
#import "StatsViewCell.h"
#import "UIImage+ImageEffects.h"

@interface ProfileViewController ()
@property (strong, nonatomic) ProfileHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSString *bannerUrl;
@property (strong, nonatomic) User *userForStats;
@property (assign, nonatomic) CGRect cachedImageViewFrameSize;


@end

@implementation ProfileViewController

TweetCell *_stubCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.userForStats = [[User alloc] init]; 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.headerView = [[ProfileHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    self.headerView.clipsToBounds = NO;
    self.tableView.tableHeaderView = self.headerView;
    self.cachedImageViewFrameSize = self.headerView.bannerImageView.frame;
    
    User *userForHeader = [[User alloc] init];
    if(self.tweetForProfile==nil){
        userForHeader = [User currentUser];
    } else {
        
        userForHeader.profile_image_url = self.tweetForProfile.profileImageUrl;
        userForHeader.name = self.tweetForProfile.name;
        userForHeader.screen_name = self.tweetForProfile.screenName;
        userForHeader.bannerImageUrl = self.bannerUrl; 
    }
    self.headerView.user = userForHeader;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StatsViewCell" bundle:nil] forCellReuseIdentifier:@"statsCell"];
    
    UINib *nib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"tweetCell"];
    _stubCell = [nib instantiateWithOwner:nil options:nil][0];
    
    [self loadTweets];
    [self loadStatsInfoForUser];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    } else {
        return self.tweets.count;
    }

    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        StatsViewCell *statViewCell = [self.tableView dequeueReusableCellWithIdentifier:@"statsCell"];
        statViewCell.user = self.userForStats; 
        return statViewCell; 
    } else {
        TweetCell *tweetCell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
        tweetCell.tweet = self.tweets[indexPath.row];
        return tweetCell;
    }
    
    
    
    //    UITableViewCell *cell = [[UITableViewCell alloc]init];
    //    cell.textLabel.text = [NSString stringWithFormat:@"Row:%ld" ,(long)indexPath.row ];
    //    NSLog(@"Row:%ld", indexPath.row);
    //    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 54;
    } else {
        [self configureCell:_stubCell atIndexPath:indexPath];
        [_stubCell layoutSubviews];
        
        CGSize size = [_stubCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)configureCell:(TweetCell *)tweetCell atIndexPath:(NSIndexPath *)indexPath
{
    tweetCell.tweet = self.tweets[indexPath.row];
    
    
}

-(void)loadTweets {
    [[TwitterClient instance] userTimeWithScreenName:[self getScreenName] success:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
        self.tweets = [tweets mutableCopy];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"UserTimeLineWithScreenFailed:%@",error.description);
    }];
    
}



//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return self.headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return self.headerView.frame.size.height;
//}

-(NSString *) getScreenName {
    NSString *screenName;
    if (self.tweetForProfile==nil) {
        screenName = [[User currentUser] screen_name];
    } else {
        screenName = self.tweetForProfile.screenName;
    }
    return screenName;
}

-(void)loadStatsInfoForUser{
    [[TwitterClient instance] userLookupWithScreenName:[self getScreenName] success:^(AFHTTPRequestOperation *operation, User *user) {
        self.userForStats = user;
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"User LookupIssue:%@",error.description);
    }];
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"I am being stretched!!");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = -scrollView.contentOffset.y;
    //UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.3];
   // UIImage *tempImage = [self.headerView.bannerImageView.image copy];
   
    if (y > 0) {
        self.headerView.bannerImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.cachedImageViewFrameSize.size.width+y, self.cachedImageViewFrameSize.size.height+y);
        self.headerView.bannerImageView.center = CGPointMake(self.view.center.x, self.headerView.bannerImageView.center.y);
        
        
        // self.headerView.bannerImageView.image = [tempImage applyBlurWithRadius:5 tintColor:tintColor saturationDeltaFactor:0.5 maskImage:nil];
        
    }
    
    //self.headerView.bannerImageView.image = [tempImage applyBlurWithRadius:y tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
    /// do the blur.
    
   
    
}

@end
