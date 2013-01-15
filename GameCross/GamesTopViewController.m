//
//  SecondTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "GamesTopViewController.h"

@implementation GamesTopViewController

@synthesize gameTable;
@synthesize games;
@synthesize gameTitle;

- (void)viewDidLoad
{
	games = [[NSMutableArray alloc] init];

	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *username = [defaults objectForKey:@"MyUsername"];
	
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	
	[connection startWith: [[NSString alloc] initWithFormat:@"getgames?id=%@", username]];
	
	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.8f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	
	
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
		self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
	}
	
	if (![self.slidingViewController.underRightViewController isKindOfClass:[FriendsUnderRightViewController class]]) {
		self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
	}
	//self.slidingViewController.underRightViewController = nil;
	//self.slidingViewController.anchorLeftPeekAmount     = 0;
	//self.slidingViewController.anchorLeftRevealAmount   = 0;
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
	
	[gameTable reloadData];
}

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
	
	NSArray *usersXML = [doc.rootElement elementsForName:@"game"];
	
	for (GDataXMLElement *element in usersXML) {
		
		NSString *title;
		NSString *system;
		
		// Variables
		title		= [(GDataXMLElement *)[[element elementsForName:@"gametitle"] objectAtIndex: 0] stringValue];
		system		= [(GDataXMLElement *)[[element elementsForName:@"system"] objectAtIndex: 0] stringValue];
		
		[games addObject:title];
		NSLog(@">_<! %@", title);
	}
	[gameTable reloadData];
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return [games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"GameCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.text = [self.games objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}


@end
