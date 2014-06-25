//
//  User.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : MTLModel <MTLJSONSerializing>


@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *screen_name;
@property(strong,nonatomic) NSString *profile_image_url;

+ (NSArray*) userWithArray:(NSArray*) array;
+ (User *)userWithDictionary:(NSDictionary *)userDict;
+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@end
