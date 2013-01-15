//
//  ViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-25.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "ViewController.h"
#import "QuartzCore/CAAnimation.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize loginTable;
@synthesize usernameField;
@synthesize passwordField;

#pragma mark - Load

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	[usernameField setDelegate:self];
	[passwordField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)shakeAnimation {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
	[animation setDuration:0.07];
	[animation setRepeatCount:3];
	[animation setAutoreverses:YES];
	[animation setFromValue:[NSValue valueWithCGPoint: CGPointMake([self.loginTable center].x - 10.0f, [self.loginTable center].y)]];
	[animation setToValue:[NSValue valueWithCGPoint: CGPointMake([self.loginTable center].x + 10.0f, [self.loginTable center].y)]];
	[[self.loginTable layer] addAnimation:animation forKey:@"position"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
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
	NSString *password;
	NSString *token;
	float     counter;
	
	NSLog(@"~~%@", [[[userXML elementsForName:@"result"] objectAtIndex:0] stringValue]);
	// Variables
	result	= [(GDataXMLElement *)[[userXML elementsForName:@"result"] objectAtIndex: 0] stringValue];
	
	if ([result isEqualToString:@"success"]) {
		username	= [(GDataXMLElement *)[[userXML elementsForName:@"username"] objectAtIndex: 0] stringValue];
		password	= [(GDataXMLElement *)[[userXML elementsForName:@"password"] objectAtIndex: 0] stringValue];
		token		= [(GDataXMLElement *)[[userXML elementsForName:@"token"] objectAtIndex: 0] stringValue];
		counter		= [[(GDataXMLElement *)[[userXML elementsForName:@"counter"] objectAtIndex: 0] stringValue]floatValue];
	}
	
	User *user = [[User alloc] initWithResult:result
									 username:username
									 password:password
										token:token
									  counter:[NSNumber numberWithFloat:counter]];
	
	NSLog(@"result: %@", result);
	
	if ([result isEqualToString:@"fail"]) {
		[self shakeAnimation];
	}
	else {
		NSLog(@"SUCCESS");
		for (int i=0; i < [loginTable numberOfRowsInSection:0]; i++) {
			[[loginTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]
			 setAccessoryType:UITableViewCellAccessoryCheckmark];
		}
		
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([[segue identifier] isEqualToString:@"loginSegue"]){
		ScaleViewController *scale = [segue destinationViewController];
		
		if ([addressField.text length] > 0) {
			[scale setAddress:addressField.text];
		}
		else {
			//[scale setAddress:@"mackarous.dyndns.org"];
			[scale setAddress:@"192.168.0.24"];
		}
		
		if ([portField.text length] > 0) {
			[scale setPort:portField.text];
		}
		else {
			//[scale setPort:@"9000"];
			[scale setPort:@"49490"];
		}
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
