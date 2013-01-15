//
//  UnderRightViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "FriendsUnderRightViewController.h"

@interface FriendsUnderRightViewController(){
	NSMutableArray *acceptedFriends;
	NSMutableArray *sentFriends;
	NSMutableArray *receivedFriends;
}
@property (nonatomic, unsafe_unretained) CGFloat peekLeftAmount;
@end

@implementation FriendsUnderRightViewController
@synthesize peekLeftAmount;
@synthesize friendsTable;
@synthesize friendUser;

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
	
	self.peekLeftAmount = 40.0f;
	[self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
	self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
	
	//if(acceptedFriends == nil)
	acceptedFriends = [[NSMutableArray alloc] init];
	//if(sentFriends == nil)
	sentFriends = [[NSMutableArray alloc] init];
	//if(receivedFriends == nil)
	receivedFriends = [[NSMutableArray alloc] init];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	usernameDefault = [defaults objectForKey:@"MyUsername"];
}

-(void) viewWillAppear:(BOOL)animated
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults objectForKey:@"MyUsername"];
	
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	
	[connection startWith: [[NSString alloc] initWithFormat:@"getfriends?id=%@", username]];
	
}

-(void) setupWith:(NSData *)data
{
	[acceptedFriends removeAllObjects];
	[sentFriends removeAllObjects];
	[receivedFriends removeAllObjects];
	
	NSError *error;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	NSLog(@"--%@", doc.rootElement);
	
	NSArray *usersXML = [doc.rootElement elementsForName:@"user"];
	
	for (GDataXMLElement *element in usersXML) {
		
		NSString *username;
		NSString *friendname;
		NSString *status;
		
		// Variables
		username	= [(GDataXMLElement *)[[element elementsForName:@"username"] objectAtIndex: 0] stringValue];
		friendname	= [(GDataXMLElement *)[[element elementsForName:@"friendname"] objectAtIndex: 0] stringValue];
		status		= [(GDataXMLElement *)[[element elementsForName:@"status"] objectAtIndex: 0] stringValue];
		
		NSLog(@"~~%@", friendname);
		
		if ([status isEqualToString:@"ACPT"]) {
			[acceptedFriends addObject:friendname];
		}
		if ([status isEqualToString:@"SENT"]) {
			[sentFriends addObject:friendname];
		}
		if ([status isEqualToString:@"RCVD"]) {
			[receivedFriends addObject:friendname];
		}
	}
	//NSLog(@"-->%@", acceptedFriends);
	//NSLog(@"-->%@", sentFriends);
	//NSLog(@"-->%@", receivedFriends);
	
	[friendsTable reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:^{
		CGRect frame = self.view.frame;
		frame.origin.x = 0.0f;
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
			frame.size.width = [UIScreen mainScreen].bounds.size.height;
		} else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
			frame.size.width = [UIScreen mainScreen].bounds.size.width;
		}
		self.view.frame = frame;
	} onComplete:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[self.slidingViewController anchorTopViewTo:ECLeft animations:^{
		CGRect frame = self.view.frame;
		frame.origin.x = self.peekLeftAmount;
		if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
			frame.size.width = [UIScreen mainScreen].bounds.size.height - self.peekLeftAmount;
		} else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
			frame.size.width = [UIScreen mainScreen].bounds.size.width - self.peekLeftAmount;
		}
		self.view.frame = frame;
	} onComplete:nil];
}

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	if (sectionIndex == 0) {
		return acceptedFriends.count;
	}
	if (sectionIndex == 1) {
		return receivedFriends.count;
	}
	if (sectionIndex == 2) {
		return sentFriends.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"FriendCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	if (indexPath.section == 0) {
		cell.textLabel.text = [acceptedFriends objectAtIndex:indexPath.row];
	}
	if (indexPath.section == 1) {
		cell.textLabel.text = [receivedFriends objectAtIndex:indexPath.row];
	}
	if (indexPath.section == 2) {
		cell.textLabel.text = [sentFriends objectAtIndex:indexPath.row];
	}
	
	//	CGRect tvframe = [tableView frame];
	//	[tableView setFrame:CGRectMake(tvframe.origin.x,
	//								   -[tableView rowHeight]*6,
	//								   tvframe.size.width,
	//								   tvframe.size.height + [tableView rowHeight]*20)];
	
	UIImageView* simgvw = [[UIImageView alloc] initWithFrame: cell.frame];
	UIImage* simg = [UIImage imageNamed: @"cellbg-sel@2x.png"];
	simgvw.image = simg;
	cell.selectedBackgroundView = simgvw;
	
	UIImageView* imgvw = [[UIImageView alloc] initWithFrame: cell.frame];
	UIImage* img = [UIImage imageNamed: @"cellbg2@2x.png"];
	imgvw.image = img;
	cell.backgroundView = imgvw;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"friendname"];
	
	friendUser = [[tableView cellForRowAtIndexPath:indexPath].textLabel text];
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//[self performSegueWithIdentifier:@"friendSegue" sender:self];
	
	NSString *identifier = @"FriendProfileTop";
	
	UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	
	if (indexPath.section == 0) {
		//[self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
		CGRect frame = self.slidingViewController.topViewController.view.frame;
		self.slidingViewController.topViewController = newTopViewController;
		self.slidingViewController.topViewController.view.frame = frame;
		[self.slidingViewController resetTopView];
		//}];
	}
	if (indexPath.section == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Request?"
														message:
							  [[NSString alloc] initWithFormat:@"Would you like to add %@ to your friends list?.", friendUser]
													   delegate:self
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:@"OK", nil];
		// optional - add more buttons:
		[alert show];
	}
	
	if (indexPath.section == 2) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Request Pending"
														message:
							  [[NSString alloc] initWithFormat:@"Your request to %@ is still pending.", friendUser]
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil, nil];
		// optional - add more buttons:
		[alert show];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIImageView* hfimgvw = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, tableView.bounds.size.width, 30)];
	[hfimgvw setBackgroundColor:[UIColor clearColor]];
	[hfimgvw setImage:[UIImage imageNamed:@"headerbg@2x.png"]];
	
	//		return hfimgvw;
	
	//		UIView *sec = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
	//		[sec setBackgroundColor:[UIColor blackColor]];
	//		[sec setAlpha:0.3f];
	
	UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, -1, tableView.bounds.size.width, 30)];
	[lbl setText: [self tableView:tableView titleForHeaderInSection:section]];
	//[lbl setFont:[UIFont fontWithName:@"Helvetica Neue Light" size:12]];
	[lbl setBackgroundColor:[UIColor clearColor]];
	[lbl setTextColor:[UIColor whiteColor]];
	
	[hfimgvw addSubview:lbl];
	return hfimgvw;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	//	if (section == 0) {
	//		return 0;
	//	}
	//	else {
	return 30;
	//	}
	//	return [tableView sectionHeaderHeight];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//
//	if (section == 2) {
//		return [tableView rowHeight]*20;
//	}
//	return 0;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (section == 0) {
		return @"Friends";
	}
	if (section == 1) {
		return @"Received Requests";
	}
	if (section == 2) {
		return @"Sent Requests";
	}
	return nil;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"Confirm Request?"]) {
		if (buttonIndex == 0) {
			NSLog(@"User Cancelled");
		}
		if (buttonIndex == 1) {
			Connection *connection = [[Connection alloc] init];
			[connection setDelegate:self];
			[connection startWith: [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendUser]];
			NSLog(@"%@", [[NSString alloc] initWithFormat:@"addfriend?id=%@&friend=%@", usernameDefault, friendUser]);
			
			[receivedFriends removeObject:friendUser];
			[acceptedFriends addObject:friendUser];
			[self.friendsTable reloadData];
		}
	}
}

@end
