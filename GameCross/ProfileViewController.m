//
//  ProfileViewController.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-27.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize user;
@synthesize usernameLabel;

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
	[usernameLabel setText:user.username];
	
	//ECSlidingViewController *slidingViewController = (ECSlidingViewController *)self.view.window.rootViewController;
	
	self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileTop"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) setupWith:(NSData *)data
{
	
}

- (IBAction)logout:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
