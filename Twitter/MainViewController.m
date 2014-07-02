//
//  MainViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/29/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "MainViewController.h"
#import "TweetTimelineViewController.h"
#import "LeftNavViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) TweetTimelineViewController *tweetTimeLineVC;
@property (strong, nonatomic) UINavigationController *nvc;
@property (strong, nonatomic) LeftNavViewController *leftNavVC;
@property (strong, nonatomic) ProfileViewController *profileVC;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;
@property (nonatomic, assign) NSInteger menuSelection;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.menuSelection = TIME_LINE;
         self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToRightView)];
        [self.tapGesture setNumberOfTapsRequired:1];
        [self.tapGesture setNumberOfTouchesRequired:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.tweetTimeLineVC = [[TweetTimelineViewController alloc] init];
    //self.tweetTimeLineVC.view.tag = CENTER_TAG;
    self.tweetTimeLineVC.delegate = self;
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.tweetTimeLineVC];
    
    [self.contentView addSubview:self.nvc.view];
    [self addChildViewController:self.nvc];
    
    [self.nvc didMoveToParentViewController:self];
    
    //Add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.nvc.view addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    
}

-(void)onPan:(UIPanGestureRecognizer*)panGestureRecognizer {

    UIView *view = panGestureRecognizer.view;
    CGPoint translatedPoint = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:view];
    
    
    if(panGestureRecognizer.state ==UIGestureRecognizerStateBegan){
        //if left or rigth put that view in
        UIView *childView = nil;
       if (velocity.x > 0 ) {
            //going right. showLeft Panel
            childView = [self getLeftPanel];
        } else {
            //come back later
        }
        [self.contentView sendSubviewToBack:childView];
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        //panGestureRecognizer.view.center = point;
        view.center = CGPointMake(view.center.x+translatedPoint.x, view.center.y);
        [panGestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.contentView]; //This was important.
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        
        if(velocity.x > 0){
            [self goToLeftView];
        }
        
    }
    
}

-(TweetTimelineViewController*)tweetTimeLineVCWithMenuSelection:(MENU_SELECTION)menuSelection {
    TweetTimelineViewController *tweetTimeLineVC = [[TweetTimelineViewController alloc]initWithMenuSelection:menuSelection];
    tweetTimeLineVC.delegate = self;
    return tweetTimeLineVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToRightView {
    [self.nvc.view removeGestureRecognizer:self.tapGesture];
    CGRect frame = self.contentView.frame;
    frame.origin.x = 250;
    self.nvc.view.frame = frame; 
    [self.contentView addSubview:self.nvc.view];
    [self addChildViewController:self.nvc];
    
    [self.nvc didMoveToParentViewController:self];
    
    
    [UIView animateWithDuration:1 animations:^{
        self.nvc.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
}

-(void)goToRightView:(NSInteger)menuSelection {
    
    //Decide what action needs to be taken. Like if its profile, TimeLine or Mentions
    if (menuSelection == PROFILE) {
        [self.nvc setViewControllers:@[self.profileVC]];
    } else {
        [self.nvc setViewControllers:@[[self tweetTimeLineVCWithMenuSelection:menuSelection]]];
    }
    self.menuSelection = menuSelection;
    
    
    [self goToRightView];
    
}

-(ProfileViewController *) profileVC {
    if (_profileVC==nil) {
        _profileVC = [[ProfileViewController alloc] init];
    }
    return _profileVC;
    
}

-(UINavigationController*) nvc {
    if(_nvc == nil) {
        _nvc = [[UINavigationController alloc] init];
    }
    return _nvc;
}
-(void)goToLeftView {
    //Add a touch recognizer to move to right.
    
    UIView *view = [self getLeftPanel];
    [self.contentView sendSubviewToBack:view];
    //get the left panel.
   //Naviate to the panel with animation
    [UIView animateWithDuration:1 animations:^{
        self.nvc.view.frame = CGRectMake(250, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }];
    
    [self.nvc.view addGestureRecognizer:self.tapGesture];
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value)
    {
        [self.nvc.view.layer setCornerRadius:2];
        [self.nvc.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.nvc.view.layer setShadowOpacity:0.8];
        [self.nvc.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else
    {
        [self.nvc.view.layer setCornerRadius:0.0f];
        [self.nvc.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

-(UIView*) getLeftPanel {
    if(_leftNavVC == nil)  {
        self.leftNavVC = [[LeftNavViewController alloc] init];
        self.leftNavVC.delegate = self;
        [self.contentView addSubview:self.leftNavVC.view];
        [self addChildViewController:self.leftNavVC];
        [self.leftNavVC didMoveToParentViewController:self];
    }
    [self showCenterViewWithShadow:YES withOffset:-2];
    return self.leftNavVC.view;
}
@end
