//
//  FriendProfileViewController.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-12-06.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "FriendsUnderRightViewController.h"
#import "Connection.h"
#import "User.h"

@interface FriendProfileViewController : UIViewController <ConnectionDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *gametitles;
}


@property (strong, nonatomic) IBOutlet UITableView *gameTable;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) IBOutlet UIImageView *profilepic;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealFriends:(id)sender;

@end
