//
//  SampleTableViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "PeopleTableViewController.h"


@implementation PeopleTableViewController

@synthesize allUsers;
@synthesize frUsers;
@synthesize fsUsers;
@synthesize user;
@synthesize friendname;
@synthesize friendsTable;

- (void)awakeFromNib
{
	//self.items = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
}
//-(void)viewWillAppear:(BOOL)animated {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSString *username = [defaults objectForKey:@"MyUsername"];
//
//	Connection *connection = [[Connection alloc] init];
//	[connection setDelegate:self];
//
//	[connection startWith: [[NSString alloc] initWithFormat:@"getfriends?id=%@",
//							username]];
//}

- (void)viewDidLoad {
	allUsers = [[NSMutableArray alloc] init];
	frUsers = [[NSMutableArray alloc] init];
	fsUsers = [[NSMutableArray alloc] init];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	usernameDefault = [defaults objectForKey:@"MyUsername"];
	
	[self getUsers];
	double delayInSeconds = 0.1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		//code to be executed on the main queue after delay
		//[self getFriends];
	});
	
	UIImageView* imgvw = [[UIImageView alloc] initWithFrame: self.tableView.frame];
	UIImage* img = [UIImage imageNamed: @"bg.jpg"];
	imgvw.image = img;
	[self.tableView setBackgroundView:imgvw];
	
	UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
	refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh!"];
	[refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refresh;
	
	[friendsTable reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
	[friendsTable reloadData];
}

-(void)refreshView:(UIRefreshControl *)refresh {
	refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
	
	// custom refresh logic would be placed here...
	[allUsers removeAllObjects];
	[frUsers removeAllObjects];
	[fsUsers removeAllObjects];
	
	[self getUsers];
	double delayInSeconds = 0.5;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		//code to be executed on the main queue after delay
		//		[self getFriends];
		[self.refreshControl endRefreshing];
	});
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM d, h:mm a"];
	NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
	refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

- (void) getUsers
{
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	NSLog(@"%@", [[NSString alloc] initWithFormat:@"getusers?id=%@", usernameDefault]);
	[connection startWith: [[NSString alloc] initWithFormat:@"getusers?id=%@", usernameDefault]];
	
}

-(void) getFriends
{
	Connection *connection2 = [[Connection alloc] init];
	[connection2 setDelegate:self];
	NSLog(@"%@", [[NSString alloc] initWithFormat:@"getfriends?id=%@", usernameDefault]);
	[connection2 startWith: [[NSString alloc] initWithFormat:@"getfriends?id=%@", usernameDefault]];
}

#pragma mark - Actions

- (IBAction)revealMenu:(id)sender
{
	[self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealFriends:(id)sender {
	[self.slidingViewController anchorTopViewTo:ECLeft];
}

#pragma mark - Connection Delegate

-(void) setupWith:(NSData *)data {
	NSError *error;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	NSLog(@"--%@", doc.rootElement);
	NSLog(@"..%@", doc.rootElement.name);
	
	NSArray *usersXML = [doc.rootElement elementsForName:@"user"];
	
	for (GDataXMLElement *element in usersXML) {
		
		NSString *username;
		NSString *email;
		NSString *friend;
		NSString *status;
		
		//NSLog(@"~~%@", [[[element elementsForName:@"username"] objectAtIndex:0] stringValue]);
		// Variables
		username	= [(GDataXMLElement *)[[element elementsForName:@"username"] objectAtIndex: 0] stringValue];
		
		if ([doc.rootElement.name isEqualToString:@"users"]) {
			email		= [(GDataXMLElement *)[[element elementsForName:@"email"] objectAtIndex: 0] stringValue];
			[allUsers addObject:username];
			
			NSLog(@"~~%@: %@", username, email);
		}
		if ([doc.rootElement.name isEqualToString:@"friends"]) {
			friend		= [(GDataXMLElement *)[[element elementsForName:@"friendname"] objectAtIndex: 0] stringValue];
			status		= [(GDataXMLElement *)[[element elementsForName:@"status"] objectAtIndex: 0] stringValue];
			
			NSLog(@"~~%@: %@", friend, status);
			if ([status isEqualToString:@"SENT"]) {
				NSLog(@"sent here");
				[fsUsers addObject:friend];
				[self.tableView reloadData];
			}
			if ([status isEqualToString:@"RCVD"]) {
				NSLog(@"recv here");
				[frUsers addObject:friend];
				[self.tableView reloadData];
			}
		}
	}
	[friendsTable reloadData];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	//	if (sectionIndex == 0) {
	//		return self.allUsers.count;
	//	}
	//	if (sectionIndex == 1) {
	//		return self.frUsers.count;
	//	}
	//	if (sectionIndex == 2) {
	//		return self.fsUsers.count;
	//	}
	return [allUsers count];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//	if (section == 0) {
//		return @"Users";
//	}
//	if (section == 1) {
//		return @"Received Requests";
//	}
//	if (section == 2) {
//		return @"Sent Requests";
//	}
//	return nil;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//	UIView *customTitleView = [ [UIView alloc] initWithFrame:CGRectMake(15, 0, 300, 44)];
//	UILabel *titleLabel = [ [UILabel alloc] initWithFrame:CGRectMake(15, 0, 300, 44)];
//	if (section == 0) {
//		titleLabel.text = @"Users";
//	}
//	if (section == 1) {
//		titleLabel.text = @"Received Requests";
//	}
//	if (section == 2) {
//		titleLabel.text = @"Pending Requests";
//	}
//	titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Medium" size:14];
//	titleLabel.textColor = [UIColor whiteColor];
//	titleLabel.backgroundColor = [UIColor clearColor];
//	[customTitleView addSubview:titleLabel];
//
//	return customTitleView;
//}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	UILabel *lbl = [[UILabel alloc] initWithFrame: CGRectZero];
	if ([allUsers count] == 0)
		[lbl setText: @"Nobody here..."];
	[lbl setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:10]];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setTextColor:[UIColor whiteColor]];
	[lbl setTextAlignment:NSTextAlignmentCenter];
	
	return lbl;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"FriendCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	if (indexPath.section == 0) {
		cell.textLabel.text = [self.allUsers objectAtIndex:indexPath.row];
	}
	if (indexPath.section == 1) {
		cell.textLabel.text = [self.frUsers objectAtIndex:indexPath.row];
	}
	if (indexPath.section == 2) {
		cell.textLabel.text = [self.fsUsers objectAtIndex:indexPath.row];
	}
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	friendname = [[tableView cellForRowAtIndexPath:indexPath].textLabel text];
	
	if (indexPath.section == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Friend?"
														message:
							  [[NSString alloc] initWithFormat:@"Do you want to add %@ to your friends list?", friendname]
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
		// optional - add more buttons:
		[alert show];
	}
	
	if (indexPath.section == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Request?"
														message:
							  [[NSString alloc] initWithFormat:@"Would you like to add %@ to your friends list?.", friendname]
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
		// optional - add more buttons:
		[alert show];
	}
	
	if (indexPath.section == 2) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Pending"
														message:
							  [[NSString alloc] initWithFormat:@"Your request to %@ is still pending.", friendname]
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil, nil];
		// optional - add more buttons:
		[alert show];
	}
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"Add Friend?"]) {
		if (buttonIndex == 0) {
			NSLog(@"User Cancelled");
		}
		if (buttonIndex == 1) {
			Connection *connection = [[Connection alloc] init];
			[connection setDelegate:self];
			[connection startWith: [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendname]];
			NSLog(@"%@", [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendname]);
			
			[allUsers removeObject:friendname];
			[fsUsers addObject:friendname];
			[self.tableView reloadData];
		}
	}
	
	if ([alertView.title isEqualToString:@"Confirm Request?"]) {
		if (buttonIndex == 0) {
			NSLog(@"User Cancelled");
		}
		if (buttonIndex == 1) {
			Connection *connection = [[Connection alloc] init];
			[connection setDelegate:self];
			[connection startWith: [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendname]];
			NSLog(@"%@", [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendname]);
			
			[frUsers removeObject:friendname];
			[self.tableView reloadData];
		}
	}
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//  return YES;
//}

@end
