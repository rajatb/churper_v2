//
//  AppDelegate.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/19/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "LoginViewController.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "User.h"
#import "TweetTimelineViewController.h"
#import "UIColor+Expanded.h"
#import "ComposeTweetViewController.h"
#import "Tweet.h"
#import "MainViewController.h"

@interface AppDelegate()

@property(strong, nonatomic) UIViewController *currentVC;
@property(strong, nonatomic) TweetTimelineViewController *tweetTimeLineVC;
@property(strong, nonatomic) LoginViewController *loginVC;
@property(strong, nonatomic) MainViewController *mainVC;

@end


@implementation NSURL (dictionaryFromQueryString)
NSString *const UserWantsToReplyNotification = @"UserWantsToReplyNotification";

- (NSDictionary *)dictionaryFromQueryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootVCToCurrentVC) name:UserDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRootVCToCurrentVC) name:UserDidLogoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openReplyTweetModal:) name:UserWantsToReplyNotification object:nil];
    
    
    [self setAppearance];
   // LeftNavViewController *leftNav = [[LeftNavViewController alloc]init];
    //self.window.rootViewController = leftNav;
    self.window.rootViewController = self.currentVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(UIViewController*) currentVC {
    UIViewController *vc;
    if([User currentUser]){
       // nvc = [[UINavigationController alloc] initWithRootViewController:self.tweetTimeLineVC];
        vc = self.mainVC;
    } else {
        vc = self.loginVC; 
    }
    return vc;
}

-(TweetTimelineViewController*) tweetTimeLineVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tweetTimeLineVC = [[TweetTimelineViewController alloc] init];
    });
    return _tweetTimeLineVC;
}

-(LoginViewController *) loginVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loginVC = [[LoginViewController alloc] init];
    });
    return _loginVC;
}

-(MainViewController *) mainVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mainVC = [[MainViewController alloc] init];
    });
    return _mainVC;
}

-(void) updateRootVCToCurrentVC {
    self.window.rootViewController = self.currentVC;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"twitter"])
    {
        if ([url.host isEqualToString:@"oauth"])
        {
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *twitterClient = [TwitterClient instance];
                
                [twitterClient fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    NSLog(@"Access Token: %@", accessToken);
                    [twitterClient.requestSerializer saveAccessToken:accessToken];
                    
                    //set user
                    [twitterClient currentUserWithFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Could not log in:%@", error.description);
                        [self onError];
                    }];
                    
//                    UINavigationController *nvc =  (UINavigationController*)self.window.rootViewController;
//                    [nvc popToRootViewControllerAnimated:NO];
                    
                    
                    
//                    [twitterClient homeTimeLineWithSuccess:^(AFHTTPRequestOperation *operation, NSArray *tweets) {
//                        User *currentUser = [User currentUser];
//                        NSLog(@"New Current User:%@",currentUser.name);
//                        
//                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                        NSData* userData = [userDefaults dataForKey:@"current_user"];
//                        NSDictionary* currentUserDict = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//                        User * currentUser1 = [User userWithDictionary:currentUserDict];
//                        
//                        NSArray *tweetsArray = [NSArray arrayWithArray:tweets];
//                        NSLog(@"Tweets:%@",tweetsArray);
//                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        NSLog(@"Error getting Tweets homeTimeLine");
//                    }];
                    
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"It failed to get access token");
                }];
            }
        }
        return YES;
    }
    return NO;
}

-(void) setAppearance {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorFromHexString:@"#00aced"]];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:0 green:172 blue:237 alpha:1]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}]; // title text color
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];  //the item bar button color
}

- (void)onError {
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't log in with Twitter, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)openReplyTweetModal:(NSNotification*)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
     //   [[self.navigationController topViewController] presentModalViewController:loginViewController animated:NO];
    });
    
    Tweet *tweet = (Tweet*)notification.userInfo[@"tweet"];
     ComposeTweetViewController *composeTVC = [[ComposeTweetViewController alloc] init];
    composeTVC.tweet = tweet;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:composeTVC];
    NSLog(@"I am in the modal!");
    
    [((UINavigationController*)self.window.rootViewController).visibleViewController presentModalViewController:nc animated:YES];
    
}

@end
