//
//  SignupViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "SignupViewController.h"
#import "Macros.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize signupTable;
@synthesize usernameField;
@synthesize emailField;
@synthesize passwordField;
@synthesize confirmpasswordField;
@synthesize user;
@synthesize submitButton;
@synthesize textFieldArray;
@synthesize titleLabel;
@synthesize logo;

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
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
	
	[usernameField setDelegate:self];
	[emailField setDelegate:self];
	[passwordField setDelegate:self];
	[confirmpasswordField setDelegate:self];
	
	if (IS_HEIGHT_GTE_568) {
		[logo setAlpha:1.0];
	}
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

- (IBAction)submit:(id)sender {
	[submitButton setEnabled:NO];
	
	Connection *connection = [[Connection alloc] init];
	[connection setDelegate:self];
	
	[connection startWith: [[NSString alloc] initWithFormat:@"signup?id=%@&email=%@&password=%@",
							usernameField.text,
							emailField.text,
							passwordField.text]];
}

#pragma mark - Actions

//- (IBAction)validateFields:(id)sender
//{
//	textFieldArray = [[NSArray alloc] initWithObjects:usernameField, emailField, passwordField, confirmpasswordField, nil];
//	
//    BOOL valid = YES;
//	
//    // On every press we're going to run through all the fields and get their length values. If any of them equal nil we will set our bool to NO.
//    for (int i = 0; i < [textFieldArray count]; i++)
//    {
//        if (![[[textFieldArray objectAtIndex:i] text] length])
//            valid = NO;
//    }
//	
//    [submitButton setEnabled:valid];	
//}

- (IBAction)dismiss:(id)sender {
	[self.usernameField resignFirstResponder];
	[self.emailField resignFirstResponder];
	[self.passwordField resignFirstResponder];
	[self.confirmpasswordField resignFirstResponder];
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
	
	NSLog(@"result: %@", result);
	
	if ([result isEqualToString:@"fail"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsuccessful"
														message:@"The username is taken, please try again!"
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		// optional - add more buttons:
		[alert show];
	}
	else
	{
		[self.delegate signUpViewControllerDidFinishWIthUsername:usernameField.text andPassword:passwordField.text];
	}
	
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField == usernameField) {
		[textField resignFirstResponder];
		[emailField becomeFirstResponder];
	}
	else if (textField == emailField) {
		[textField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	else if (textField == passwordField) {
		[textField resignFirstResponder];
		[confirmpasswordField becomeFirstResponder];
	}
	else if (textField == confirmpasswordField) {
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *path = [self.signupTable indexPathForCell:(UITableViewCell *)[(UIView *)[textField superview] superview]];
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // NSLog(@"%@",new);
    // Check to make sure fields are good.
    if(textField == self.usernameField){
        NSString *expression = @"^[A-Za-z]+[A-Z a-z]*$";
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:new options:0 range:NSMakeRange(0, [new length])];
        
        if(match)
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else if(textField == self.emailField){
        NSString *expression = @"[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:new options:0 range:NSMakeRange(0, [new length])];
        
        if(match)
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else if(textField == self.passwordField){
        NSString *expression = @"^[A-Za-z][A-Za-z0-9]{5,17}$"; // Start with a letter, 6-18 length
        NSError *error = NULL;
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *match = [regex firstMatchInString:new options:0 range:NSMakeRange(0, [new length])];
        
        if(match)
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
        
        
        if ([new isEqualToString:self.confirmpasswordField.text] && [self.signupTable cellForRowAtIndexPath:path].accessoryType == UITableViewCellAccessoryCheckmark)
            [[self.signupTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.signupTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
    else if(textField == self.confirmpasswordField  &&
			[self.signupTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType == UITableViewCellAccessoryCheckmark){
        
        if([new length] > 5 && [new isEqualToString:self.passwordField.text])
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryCheckmark];
        else
            [[self.signupTable cellForRowAtIndexPath:path] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    int count = 0;
    for (int section = 0; section < [self.signupTable numberOfSections]; section++) {
        for (int row = 0; row < [self.signupTable numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.signupTable cellForRowAtIndexPath:cellPath];
			
            if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
                count++;
            }
        }
    }
    if (count == 4)
        [self.submitButton setEnabled:YES];
    else
        [self.submitButton setEnabled:NO];
    
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
		usernameField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 1) {
		cell.textField.placeholder = @"Email Address";
		emailField = cell.textField;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
		[cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
	}
	if (indexPath.row == 2) {
		cell.textField.placeholder = @"Password";
		passwordField = cell.textField;
		cell.textField.secureTextEntry = YES;
		[cell.textField setReturnKeyType:UIReturnKeyNext];
	}
	if (indexPath.row == 3) {
		cell.textField.placeholder = @"Confirm Password";
		confirmpasswordField = cell.textField;
		cell.textField.secureTextEntry = YES;
		[cell.textField setReturnKeyType:UIReturnKeyDone];
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
