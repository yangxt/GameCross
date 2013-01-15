//
//  SignupViewController.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Connection.h"
#import "MyCell.h"
#import "User.h"
#import "Macros.h"

@class SignupViewController;

@protocol SignupViewControllerDelegate
- (void)signUpViewControllerDidFinishWIthUsername:(NSString *)username andPassword:(NSString *)password;
@end

@interface SignupViewController : UIViewController
<ConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <SignupViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITableView *signupTable;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *logo;

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *emailField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *confirmpasswordField;

@property (strong, nonatomic) NSArray *textFieldArray;
@property (strong, nonatomic) User *user;

//- (IBAction)validateFields:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)submit:(id)sender;

@end
