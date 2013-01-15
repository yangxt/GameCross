//
//  NavigationTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 2/13/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "NavigationTopViewController.h"

@implementation NavigationTopViewController

- (void)viewDidLoad
{
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
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


@end
