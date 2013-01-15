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

@interface ViewController : UIViewController <ConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *loginTable;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;

- (IBAction)dismiss:(id)sender;
- (IBAction)loginPushed:(id)sender;

@end
