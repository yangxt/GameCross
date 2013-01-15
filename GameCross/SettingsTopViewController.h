//
//  ThirdTopViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "FriendsUnderRightViewController.h"
#import "MyCell.h"
#import "Connection.h"
#import "User.h"

@interface SettingsTopViewController : UIViewController
<ConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
	UIColor *defaultColor;
}

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) User *user;

@property (strong, nonatomic) NSString *myUsername;
@property (strong, nonatomic) NSString *myEmail;

@property (strong, nonatomic) IBOutlet UIImageView *logoSide;
@property (strong, nonatomic) IBOutlet UIImageView *logoBottom;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UITableView *settingsTable;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealFriends:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)submitPushed:(id)sender;

@end
