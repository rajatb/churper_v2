//
//  Tweet.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Tweet : MTLModel <MTLJSONSerializing>

@property(strong,nonatomic) NSNumber *id;
@property(strong,nonatomic) NSString *name; 
@property(strong,nonatomic) NSString *screenName;
@property(strong,nonatomic) NSString *profileImageUrl;
@property(strong,nonatomic) NSString *text;
@property(strong,nonatomic) NSString *dateCreated;
@property(assign,nonatomic) BOOL retweeted;
@property(strong,nonatomic) NSNumber *retweetCount;
@property(assign,nonatomic) BOOL favorited;
@property(strong,nonatomic) NSNumber *favoritesCount;
@property(strong,nonatomic) NSString *retweetedByName;


+(NSArray*) tweetsWithArray:(NSArray*) array;
+(Tweet*) tweetsWithDictionary:(NSDictionary*) tweetDict;

@end
