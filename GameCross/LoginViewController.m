//
//  ViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-25.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "LoginViewController.h"
#import "QuartzCore/CAAnimation.h"
#import "ProfileViewController.h"
#import "Macros.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginTable;
@synthesize usernameField;
@synthesize passwordField;
@synthesize user;
@synthesize loginButton;
@synthesize signupButton;
@synthesize activityIndicator;
@synthesize logoSide;
@synthesize logoUnder;

#pragma mark - Load

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
	
	[usernameField setDelegate:self];
	[passwordField setDelegate:self];
	
	[self.loginTable setAlpha:0];
	[self.loginButton setAlpha:0];
	[self.signupButton setAlpha:0];
	[self.logoSide setAlpha:0];
	[self.logoUnder setAlpha:0];
	[self.titleLabel setAlpha:0];
}

- (void)viewDidAppear:(BOOL)animated
{
	for (int i=0; i < [loginTable numberOfRowsInSection:0]; i++) {
		[[loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]
		 setAccessoryType:UITableViewCellAccessoryNone];
	}
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.5];
	[UIView setAnimationDelay:0.5];
	[self.loginTable setAlpha:1.0];
	[self.titleLabel setAlpha:1.0];
	if (IS_HEIGHT_GTE_568) {
		[logoUnder setAlpha:1.0];
	}
	else {
		[logoSide setAlpha:1.0];
	}
	[UIView setAnimationDelay:2];
	[self.loginButton setAlpha:1.0];
	[self.signupButton setAlpha:1.0];
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animations

- (void)shakeAnimation
{
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setDuration:0.07];
	[animation setRepeatCount:3];
	[animation setAutoreverses:YES];
	[animation setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.loginTable center].x - 10.0f, [self.loginTable center].y)]];
	[animation setToValue:[NSValue valueWithCGPoint: CGPointMake([self.loginTable center].x + 10.0f, [self.loginTable center].y)]];
	[[self.loginTable layer] addAnimation:animation forKey:@"position"];
}

#pragma mark - Actions

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == usernameField) {
		[textField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	else if (textField == passwordField) {
		[self loginPushed:textField];
		[textField resignFirstResponder];
	}
	return YES;
}

- (void) dismiss:(id)sender
{
	[self.usernameField resignFirstResponder];
	[self.passwordField resignFirstResponder];
}

- (IBAction)loginPushed:(id)sender
{
	[loginButton setEnabled:NO];
	[loginButton setTitle:@"" forState:UIControlStateNormal];
	[activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	
	[connection startWith: [[NSString alloc] initWithFormat:@"login?id=%@&password=%@",
							usernameField.text,
							passwordField.text]];
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
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:username forKey:@"MyUsername"];
	[defaults setObject:email forKey:@"MyEmail"];
	[defaults synchronize];
	
	NSLog(@"user: %@", user.username);
	
	NSLog(@"result: %@", result);
	
	if ([result isEqualToString:@"success"])
	{
		NSLog(@"SUCCESS");
		for (int i=0; i < [loginTable numberOfRowsInSection:0]; i++)
		{
			[[loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]
			 setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		[self performSelector:@selector(push) withObject:nil afterDelay:0.5];
	}
	else if ([result isEqualToString:@"fail"]) {
		[self shakeAnimation];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed"
														message:@"Unable to connect to host. Please try again later."
													   delegate:self
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
	}
	[loginButton setEnabled:YES];
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[activityIndicator stopAnimating];
}

#pragma mark - Segue

- (void)push
{
	[self performSegueWithIdentifier:@"loginSegue" sender:self];
	[passwordField setText:@""];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"loginSegue"])
	{
		ProfileViewController *profile = [segue destinationViewController];
		
		[profile setUser:self.user];
	}
	
	if ([[segue identifier] isEqualToString:@"signupSegue"])
	{
		[[segue destinationViewController] setDelegate:self];
	}
}

#pragma mark - SignupViewControllerDelegate

- (void)signUpViewControllerDidFinishWIthUsername:(NSString *)username andPassword:(NSString *)password {
	[usernameField setText:username];
	[passwordField setText:password];
	[self performSelector:@selector(loginPushed:) withObject:nil afterDelay:0];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
													message:@"Your account has been created."
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	// optional - add more buttons:
	[alert show];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:@"Success"]) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
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
		cell.textField.placeholder = @"Username";
		usernameField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 1) {
		cell.textField.placeholder = @"Password";
		cell.textField.secureTextEntry = YES;
		passwordField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyGo];
	}
	
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
	
	//	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	//	MyCell *cell= (MyCell*)[tableView cellForRowAtIndexPath:indexPath];
	//	if ([cell accessoryType] == UITableViewCellAccessoryNone)
	//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	//	else
	//		[cell setAccessoryType:UITableViewCellAccessoryNone];
	
}


@end
