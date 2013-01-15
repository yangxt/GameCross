//
//  UnderRightViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "Connection.h"
#import "FriendProfileViewController.h"

@interface FriendsUnderRightViewController : UIViewController
<UISearchBarDelegate, ConnectionDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
	NSString* usernameDefault;
}

@property (strong, nonatomic) NSString *friendUser;
@property (strong, nonatomic) IBOutlet UITableView *friendsTable;

@end
