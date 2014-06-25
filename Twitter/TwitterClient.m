//
//  TwitterClient.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"
#import "User.h"



@implementation TwitterClient


#pragma mark - Singleton instance method
+ (TwitterClient *) instance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:@"xugGzzdOc61EGTKWpNwj0mMc5" consumerSecret:@"0w9Ic2j2EYWPnFMHXhBrAONvc9ZhLy6qiEuU1vkvK9U3c0NLwK"];
    });
    
    return instance;
    
}

- (void) login {
    [self.requestSerializer removeAccessToken]; 
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"twitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Request Token");
        
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    } failure:^(NSError *error) {
        NSLog(@"Request token fail:%@", error.description);
    }];
}

#pragma mark - Tweet API
-(AFHTTPRequestOperation *) homeTimeLine {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response Object:%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];
    
}


-(AFHTTPRequestOperation *) homeTimeLineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
 {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweetsFromJSON = responseObject;
        NSArray *tweets = [Tweet tweetsWithArray:tweetsFromJSON];
        success(operation, tweets);
    } failure:failure];
    
}


-(AFHTTPRequestOperation *) homeTimeLineWithCount:(NSNumber*)num sinceId:(NSNumber*)sinceId maxId:(NSNumber*)maxId Success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *param = @{@"count": num,
                           // @"since_id" :sinceId};
                            @"max_id": maxId};
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *tweetsFromJSON = responseObject;
        NSArray *tweets = [Tweet tweetsWithArray:tweetsFromJSON];
        success(operation, tweets);
    } failure:failure];
    
}

#pragma mark - User API

-(AFHTTPRequestOperation *) currentUserWithFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
   return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
       NSLog(@"responseObject:%@",responseObject);
        User *currentUser = [User userWithDictionary:responseObject];
        [User setCurrentUser:currentUser];
       NSLog(@"User logged in!!");
    } failure:failure];
}



-(void) statusUpdateWithStatus:(NSString *)status inReplyToStatusId:(NSNumber *)statusId success:(void(^)(AFHTTPRequestOperation *operation, Tweet* tweet))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure  {
   
    if(!statusId){
        statusId = [NSNumber numberWithInt:1];
    }
    
    NSDictionary *param = @{@"status": status,
                            @"in_reply_to_status_id": statusId};
    
    [self POST:@"1.1/statuses/update.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"=========================");
        NSLog(@"ResponseObject:%@",responseObject);
        NSDictionary *tweetsFromJSONDict = responseObject;
        Tweet *tweet = [Tweet tweetsWithDictionary:tweetsFromJSONDict];
        success(operation, tweet);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        failure(operation,error);
    }];
}

-(void) retweetWithTweetId:(NSNumber*)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",tweetId];
    
    [self POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Retweet Success!");
    } failure:failure];
}

-(AFHTTPRequestOperation *) getRetweetUserWithTweetId:(NSNumber*)tweetId countOfUser:(NSNumber*)count success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"1.1/statuses/retweets/%@.json",tweetId];
    NSDictionary *param = @{@"count": count};
    
   return  [self POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *usersFromJSON = responseObject[@"user"];
        NSArray *users = [User userWithArray:usersFromJSON];
        NSLog(@"get Tweet User Success!");
       success(operation,users);
    } failure:failure];
}

-(void) favoriteWithTweetId:(NSNumber*)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSDictionary *param = @{@"id": tweetId};
    [self POST:@"1.1/favorites/create.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet Favorited!");
    } failure:failure];
}

-(void) defavoriteWithTweetId:(NSNumber *)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSDictionary *param = @{@"id": tweetId};
    [self POST:@"1.1/favorites/destroy.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Tweet UnFavorited!");
    } failure:failure];
}



@end
