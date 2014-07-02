//
//  User.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/20/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "User.h"

@implementation User

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"bannerImageUrl": @"profile_banner_url",
            // @"dateCreated":          @"created_at",
            // @"screenName" :          @"screen_name",
             //@"profileImageUrl":    @"profile_image_url",
             //             @"websiteURL":         @"website",
             //             @"locationCoordinate": @"location",
             //             @"relationshipStatus": @"relationship_status",
             };
    
}


static User *currentUser = nil;
+ (User *)currentUser {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if(currentUser == nil){
      NSData* userData = [userDefaults dataForKey:@"current_user"];
      User* currentUserDict = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if (currentUserDict) {
            currentUser = currentUserDict;
            
        }
    }
    return currentUser;
    
    
}

+ (void)setCurrentUser:(User *)user {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    if(user){
        NSData* userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        [userDefaults setObject:userData forKey:@"current_user"];
        
    } else {
        [userDefaults removeObjectForKey:@"current_user"];
    }
     [[NSUserDefaults standardUserDefaults] synchronize];
    
    if(!currentUser && user){
        //They just logged in
         currentUser = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLoginNotification object:nil];
    } else if (currentUser && !user) {
        //The just logged out
         currentUser = user;
         [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
    } else {
        //This is done so even a user is already logged in but wants to refresh this object. 
        currentUser = user;
    }
   
    
}

+ (NSArray*) userWithArray:(NSArray*) array{
    NSMutableArray *users = [NSMutableArray array];
    for (NSDictionary *userDict in array) {
        [users addObject:[User userWithDictionary:userDict]];
    }
    return users; 
}

+ (User *)userWithDictionary:(NSDictionary *)userDict {
    
    User *user = [MTLJSONAdapter modelOfClass:self.class fromJSONDictionary:userDict error:NULL];
    return user;
}

@end
