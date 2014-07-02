//
//  NavigationDelegate.h
//  hamburgerMenuDemo
//
//  Created by Bhargava, Rajat on 6/28/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NavigationDelegate <NSObject>

-(void)goToRightView:(NSInteger)menuSelection;
-(void)goToLeftView; 

@end
