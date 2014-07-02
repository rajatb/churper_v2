//
//  LeftNavViewController.m
//  Twitter
//
//  Created by Bhargava, Rajat on 6/29/14.
//  Copyright (c) 2014 rnb. All rights reserved.
//

#import "LeftNavViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import  <QuartzCore/QuartzCore.h>

@interface LeftNavViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblScreenName;
@property (strong, nonatomic) User *currentuser;
@property (weak, nonatomic) IBOutlet UITableView *leftNavigationMenuTbl;
@property (strong, nonatomic)NSArray *menuOptions;

@end

@implementation LeftNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.currentuser = [User currentUser];
        self.menuOptions = @[@"Profile",@"Timeline",@"Mentions",@"Logout"];
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.leftNavigationMenuTbl.dataSource = self;
    self.leftNavigationMenuTbl.delegate = self;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.currentuser.profile_image_url]];
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES; 
    self.lblName.text = self.currentuser.name;
    self.lblScreenName.text = [NSString stringWithFormat:@"@%@", self.currentuser.screen_name ];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuOptions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CELL_IDENTIFIER];
    }
    
    cell.textLabel.text = self.menuOptions[indexPath.row];
    return cell; 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case LOGOUT:
            [User setCurrentUser:nil];
            break;

            
        default: {
            [self.delegate goToRightView:indexPath.row];
        }
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    return view;
}

@end
