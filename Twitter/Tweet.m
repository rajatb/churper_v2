//
//  Tweet.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"dateCreated":          @"created_at",
             @"screenName" :          @"user.screen_name",
             @"profileImageUrl":    @"user.profile_image_url",
             @"name":               @"user.name",
             @"retweetCount" :      @"retweet_count",
             @"favoritesCount" :     @"favorite_count",
             @"retweetedByName" :         @"retweeted_status.user.screen_name",
//             @"websiteURL":         @"website",
//             @"locationCoordinate": @"location",
//             @"relationshipStatus": @"relationship_status",
             };
    
}

//+ (NSValueTransformer *)dateCreatedTransformer {
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
//        NSLog(@"Date:%@",[self.dateFormatter dateFromString:str]);
//        return [self.dateFormatter dateFromString:str];
//    } reverseBlock:^(NSDate *date) {
//        return [self.dateFormatter stringFromDate:date];
//    }];
//}
//
//+ (NSDateFormatter *)dateFormatter {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
//    return dateFormatter;
//}

+(NSArray*) tweetsWithArray:(NSArray*) array{
    NSMutableArray* tweets = [NSMutableArray array];
    
    for (NSDictionary *tweetDict in array) {
        Tweet *tweet = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:tweetDict error:NULL];
        [tweets addObject:tweet];
    }
    
    return tweets;
}

+(Tweet*) tweetsWithDictionary:(NSDictionary*) tweetDict{
    Tweet *tweet = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:tweetDict error:NULL];
    return tweet;
}

- (NSString *)profileImageUrl {
    if (_profileImageUrl) {
        return [_profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    }
    return _profileImageUrl;
}

@end
