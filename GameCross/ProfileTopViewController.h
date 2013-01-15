//
//  FirstTopViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "FriendsUnderRightViewController.h"
#import "Connection.h"
#import "User.h"

@interface ProfileTopViewController : UIViewController <ConnectionDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *gametitles;
}

@property (strong, nonatomic) IBOutlet UITableView *gameTable;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) User *user;

- (IBAction)revealFriends:(id)sender;
- (IBAction)revealMenu:(id)sender;

@end
