//
//  ComposeTweetViewController.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

extern NSString *const UserReplyTweetNotification;

@interface ComposeTweetViewController : UIViewController <UITextViewDelegate>
@property(nonatomic,strong) Tweet *tweet; 
@end
