//
//  ThirdTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "SettingsTopViewController.h"

@implementation SettingsTopViewController

@synthesize usernameField;
@synthesize emailField;
@synthesize myUsername;
@synthesize myEmail;
@synthesize logoBottom;
@synthesize logoSide;
@synthesize settingsTable;
@synthesize user;
@synthesize submitButton;

-(void)viewDidLoad {
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
	
	[usernameField setDelegate:self];
	[emailField setDelegate:self];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	myUsername = [defaults objectForKey:@"MyUsername"];
	myEmail = [defaults objectForKey:@"MyEmail"];
	
	if (IS_HEIGHT_GTE_568) {
		[logoSide setAlpha:0];
		[logoBottom setAlpha:1.0];
	}
	else {
		[logoBottom setAlpha:0];
		[logoSide setAlpha:0];
	}
	
	[submitButton setEnabled:NO];
	defaultColor = [[submitButton titleLabel] textColor];
	[submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
	// You just need to set the opacity, radius, and color.
	self.view.layer.shadowOpacity = 0.8f;
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

-(void) setupWith:(NSData *)data
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
	float     counter;
	
	NSLog(@"~~%@", [[[userXML elementsForName:@"result"] objectAtIndex:0] stringValue]);
	// Variables
	result	= [(GDataXMLElement *)[[userXML elementsForName:@"result"] objectAtIndex: 0] stringValue];
	
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
}

- (IBAction)revealMenu:(id)sender
{
	[self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealFriends:(id)sender {
	[self.slidingViewController anchorTopViewTo:ECLeft];
}

-(IBAction)dismiss:(id)sender {
	[self.usernameField resignFirstResponder];
	[self.emailField resignFirstResponder];
}

- (IBAction)submitPushed:(id)sender
{
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	
	[connection startWith: [[NSString alloc] initWithFormat:@"updateuser?id=%@&newid=%@&email=%@",
							myUsername,
							usernameField.text,
							emailField.text]];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!"
													message:@"Your information has been changed! Please remember your new username when you log in again!"
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	// optional - add more buttons:
	[alert show];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:usernameField.text forKey:@"MyUsername"];
	[defaults setObject:emailField.text forKey:@"MyEmail"];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == usernameField) {
		[textField resignFirstResponder];
		[emailField becomeFirstResponder];
	}
	else if (textField == emailField) {
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *path = [self.settingsTable indexPathForCell:(UITableViewCell *)[(UIView *)[textField superview] superview]];
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NSLog(@"%@",new);
    // Check to make sure fields are good.
    if(textField == self.usernameField){
        NSString *expression = @"^[A-Za-z]+[A-Z a-z]*$";
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:new options:0 range:NSMakeRange(0, [new length])];
        
        if(match)
            [[self.settingsTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.settingsTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else if(textField == self.emailField){
        NSString *expression = @"[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:new options:0 range:NSMakeRange(0, [new length])];
        
        if(match)
            [[self.settingsTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.settingsTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
    }
	
    int count = 0;
    for (int section = 0; section < [self.settingsTable numberOfSections]; section++) {
        for (int row = 0; row < [self.settingsTable numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.settingsTable cellForRowAtIndexPath:cellPath];
			
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
                count++;
            }
        }
    }
    if (count == 2) {
        [self.submitButton setEnabled:YES];
		[self.submitButton setTitleColor:defaultColor forState:UIControlStateNormal];
	}
    else {
        [self.submitButton setEnabled:NO];
		[self.submitButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	}
    
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
	
	MyCell *cell= (MyCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
	// Configure the cell...
	if (indexPath.row == 0) {
		cell.label.text = @"Username:";
		cell.textField.placeholder = myUsername;
		//cell.textField.text = myUsername;
		usernameField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 1) {
		cell.label.text = @"Email:";
		//cell.textField.text = myEmail;
		cell.textField.placeholder = myEmail;
		emailField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyGo];
	}
	
    return cell;
}



@end
