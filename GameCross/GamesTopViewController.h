//
//  SecondTopViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "FriendsUnderRightViewController.h"

@interface GamesTopViewController : UIViewController <ConnectionDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *gameTitle;
@property (nonatomic, strong) NSMutableArray *games;

@property (strong, nonatomic) IBOutlet UITableView *gameTable;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealFriends:(id)sender;
@end
