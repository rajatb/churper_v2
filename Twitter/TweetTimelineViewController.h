//
//  TweetTimelineViewController.h
//  Twitter
//
//  Created by Bhargava, Rajat on 6/21/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationDelegate.h"
#import "LeftNavViewController.h"

@interface TweetTimelineViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <NavigationDelegate> delegate;
-(void)showDataFor:(NSInteger)menuSelection;
-(id) initWithMenuSelection:(MENU_SELECTION)menuSelection;

@end
