//
//  SampleTableViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "Connection.h"
#import "User.h"

@interface PeopleTableViewController : UITableViewController
<ConnectionDelegate, UITableViewDataSource, UITabBarControllerDelegate> {
	NSString *usernameDefault;
}

@property (strong, nonatomic) NSString *friendname;
@property (strong, nonatomic) User *user;
@property (nonatomic, strong) NSMutableArray *allUsers;
@property (nonatomic, strong) NSMutableArray *frUsers;
@property (nonatomic, strong) NSMutableArray *fsUsers;

@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealFriends:(id)sender;

@end
