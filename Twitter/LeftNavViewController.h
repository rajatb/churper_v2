//
//  LeftNavViewController.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/29/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationDelegate.h"



@interface LeftNavViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <NavigationDelegate> delegate;

typedef NS_ENUM(NSInteger, MENU_SELECTION) {
    PROFILE,
    TIME_LINE,
    MENTIONS,
    LOGOUT
};

@end
