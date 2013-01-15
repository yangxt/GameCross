
//
//  FriendProfileViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-12-06.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "FriendProfileViewController.h"

@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController

@synthesize user;
@synthesize usernameLabel;
@synthesize emailLabel;
@synthesize profilepic;
@synthesize gameTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	gametitles = [[NSMutableArray alloc] init];

    [super viewDidLoad];
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];

	// Do any additional setup after loading the view.
	usernameLabel.text = @"";
	emailLabel.text = @"";
	
	NSURL *url = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/e/ec/Happy_smiley_face.png"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *image = [UIImage imageWithData:data];
	[profilepic setImage:image];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *friendname = [defaults objectForKey:@"friendname"];

	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	[connection startWith: [[NSString alloc] initWithFormat:@"getuserprofile?id=%@", friendname]];
}

-(void)viewWillAppear:(BOOL)animated
{
	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.75f;
	self.view.layer.shadowRadius = 10.0f;
	self.view.layer.shadowColor = [UIColor blackColor].CGColor;
	
	if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
		self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
	}
	
	if (![self.slidingViewController.underRightViewController isKindOfClass:[FriendsUnderRightViewController class]]) {
		self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
	}
	
	[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void) setupWith:(NSData *)data
{
	NSError *error;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	NSLog(@"--%@", doc.rootElement);
	
	GDataXMLElement *userXML = doc.rootElement;
	NSString *result;
	NSString *username;
	NSString *email;
	NSString *password;
	NSString *token;
	NSString *gametitle;
	float     counter;
	
	NSLog(@"~~%@", [[[userXML elementsForName:@"result"] objectAtIndex:0] stringValue]);
	// Variables
	result	= [(GDataXMLElement *)[[userXML elementsForName:@"result"] objectAtIndex: 0] stringValue];
	
	NSArray *gamesXML = [doc.rootElement elementsForName:@"games"];
	for (GDataXMLElement *element in gamesXML) {
		for (int i = 0; i < [element elementsForName:@"gametitle"].count; i++) {
			gametitle	= [(GDataXMLElement *)[[element elementsForName:@"gametitle"] objectAtIndex: i] stringValue];
			NSLog(@"game- %@", gametitle);
			[gametitles addObject:gametitle];
		}
	}
	
	if ([result isEqualToString:@"success"]) {
		username	= [(GDataXMLElement *)[[userXML elementsForName:@"username"] objectAtIndex: 0] stringValue];
		email		= [(GDataXMLElement *)[[userXML elementsForName:@"email"] objectAtIndex: 0] stringValue];
		password	= [(GDataXMLElement *)[[userXML elementsForName:@"password"] objectAtIndex: 0] stringValue];
		token		= [(GDataXMLElement *)[[userXML elementsForName:@"token"] objectAtIndex: 0] stringValue];
		counter		= [[(GDataXMLElement *)[[userXML elementsForName:@"counter"] objectAtIndex: 0] stringValue]floatValue];
	}
	
	user = [[User alloc] initWithResult:result
							   username:username
								  email:email
							   password:password
								  token:token
								counter:[NSNumber numberWithFloat:counter]];
	
	[usernameLabel setText:[user username]];
	[emailLabel setText:[user email]];
	
	[gameTable reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
	[self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealFriends:(id)sender {
	[self.slidingViewController anchorTopViewTo:ECLeft];
}

#pragma mark - TableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	return [gametitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"MyGameCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.text = [gametitles objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
