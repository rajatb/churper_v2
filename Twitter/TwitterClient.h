//
//  TwitterClient.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "Tweet.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) instance;
- (void) login;

-(AFHTTPRequestOperation *) homeTimeLine;
-(AFHTTPRequestOperation *) homeTimeLineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *) mentionsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *) currentUserWithFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void) statusUpdateWithStatus:(NSString *)status inReplyToStatusId:(NSNumber *)statusId success:(void(^)(AFHTTPRequestOperation *operation, Tweet *tweets))success failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

-(void) retweetWithTweetId:(NSNumber*)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *)getRetweetUserWithTweetId:(NSNumber*)tweetId countOfUser:(NSNumber*)count success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(void) favoriteWithTweetId:(NSNumber*)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
-(void) defavoriteWithTweetId:(NSNumber *)tweetId failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *) homeTimeLineWithCount:(NSNumber*)num sinceId:(NSNumber*)sinceId maxId:(NSNumber*)maxId Success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


-(AFHTTPRequestOperation *) userTimeWithScreenName:(NSString*)screenName success:(void (^)(AFHTTPRequestOperation *operation, NSArray *tweets))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *) getBanner:(NSString*)screenName success:(void (^)(AFHTTPRequestOperation *operation, NSString *url))success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

-(AFHTTPRequestOperation *) userLookupWithScreenName:(NSString*)screenName success:(void (^)(AFHTTPRequestOperation *operation, User *user))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure; 

@end
