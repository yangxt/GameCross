//
//  SignupViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize signupTable;
@synthesize username;
@synthesize email;
@synthesize password;
@synthesize confirmpassword;

#pragma mark - load

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)cancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
	
}

#pragma mark - Actions

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField == username) {
		[textField resignFirstResponder];
		[email becomeFirstResponder];
	}
	else if (textField == email) {
		[textField resignFirstResponder];
		[password becomeFirstResponder];
	}
	else if (textField == password) {
		[textField resignFirstResponder];
		[confirmpassword becomeFirstResponder];
	}
	else if (textField == confirmpassword) {
		[self save:textField];
		[textField resignFirstResponder];
	}
	return YES;
}

- (IBAction)dismiss:(id)sender {
	[self.username resignFirstResponder];
	[self.email resignFirstResponder];
	[self.password resignFirstResponder];
	[self.confirmpassword resignFirstResponder];
}

- (void) setupWith:(NSData *)data
{
	NSError *error;
	GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	NSLog(@"%@", doc.rootElement);
	
	//	NSArray *XMLArray = [doc.rootElement elementsForName:@"stuff"];
	//	//NSLog(@"%i", [catalog count]);
	//	for (GDataXMLElement *element in XMLArray)
	//	{
	//		// Variables
	//		NSString	*result		= [(GDataXMLElement *)[element attributeForName:@"result"] stringValue];
	//		NSString	*username	= [(GDataXMLElement *)[[element elementsForName:@"username"] objectAtIndex: 0] stringValue];
	//		NSString	*password	= [(GDataXMLElement *)[[element elementsForName:@"password"] objectAtIndex: 0] stringValue];
	//		NSString	*token		= [(GDataXMLElement *)[[element elementsForName:@"token"] objectAtIndex: 0] stringValue];
	//		float		counter		= [[(GDataXMLElement *)[[element elementsForName:@"counter"] objectAtIndex: 0] stringValue]floatValue];
	//	}
	//
	//	NSMutableString *output = [NSMutableString stringWithString:@""];
	//
	//	for (Book *book in books) {
	//		[output appendFormat:@"%@\n\n", [book description]];
	//	}
	//
	//	self.textView.text = output;
	//	[priceLabel setText:[NSString stringWithFormat:@"Total: $ %1.2f", totalPrice]];
	//	totalPrice = 0;
	//	output = [NSMutableString stringWithString:@""];
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
    return 4;
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
		username = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 1) {
		cell.textField.placeholder = @"Email Address";
		email = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 2) {
		cell.textField.placeholder = @"Password";
		password = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 3) {
		cell.textField.placeholder = @"Confirm Password";
		confirmpassword = cell.textField;
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
//	
//	MyCell *cell= (MyCell*)[tableView cellForRowAtIndexPath:indexPath];
//	if ([cell accessoryType] == UITableViewCellAccessoryNone)
//		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//	else
//		[cell setAccessoryType:UITableViewCellAccessoryNone];
	
}

@end
