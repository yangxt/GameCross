//
//  ViewController.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-25.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "MyCell.h"
#import "User.h"
#import "Macros.h"
#import "SignupViewController.h"

@interface LoginViewController : UIViewController
<ConnectionDelegate,
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
SignupViewControllerDelegate,
UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *loginTable;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) User *user;

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signupButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *logoSide;
@property (strong, nonatomic) IBOutlet UIImageView *logoUnder;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)dismiss:(id)sender;
- (IBAction)loginPushed:(id)sender;

@end
