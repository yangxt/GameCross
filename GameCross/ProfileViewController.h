//
//  ProfileViewController.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-27.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "User.h"
#import "ECSlidingViewController.h"

@interface ProfileViewController : ECSlidingViewController <ConnectionDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

- (IBAction)logout:(id)sender;

@end
