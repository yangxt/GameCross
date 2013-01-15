//
//  SignupViewController.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "MyCell.h"

@interface SignupViewController : UIViewController <ConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *signupTable;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *email;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UITextField *confirmpassword;

- (IBAction)dismiss:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
