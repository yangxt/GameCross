//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "MenuViewController.h"
#import "Macros.h"

@interface MenuViewController()
@property (nonatomic, strong) NSArray *socialItems;
@property (nonatomic, strong) NSArray *settingsItems;
@end

@implementation MenuViewController
@synthesize socialItems;
@synthesize settingsItems;
@synthesize menuTable;

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.view.layer setCornerRadius:CORNER_RADIUS];
	[self.view.layer setMasksToBounds:YES];
	[self.view.layer setOpaque:NO];
	
	self.socialItems = [NSArray arrayWithObjects:@"Profile", @"Games", @"People", nil];
	self.settingsItems = [NSArray arrayWithObjects:@"Settings", @"Logout", nil];
	
	[self.slidingViewController setAnchorRightRevealAmount:280.0f];
	self.slidingViewController.underLeftWidthLayout = ECFullWidth;
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
	if (sectionIndex == 0) {
		return self.socialItems.count;
	}
	else if (sectionIndex == 1) {
		return self.settingsItems.count;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	//    if (section == 0) {
	//		return @"Social";
	//	}
	if (section == 1) {
		return @"Account";
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"MenuItemCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:24];
	cell.textLabel.textColor = [UIColor whiteColor];
	if (indexPath.section == 0) {
		cell.textLabel.text = [self.socialItems objectAtIndex:indexPath.row];
	}
	if (indexPath.section == 1) {
		cell.textLabel.text = [self.settingsItems objectAtIndex:indexPath.row];
	}
	
//	//if (indexPath.row == 0) {
//		CGRect tvframe = [tableView frame];
//		[tableView setFrame:CGRectMake(tvframe.origin.x,
//									   -[tableView rowHeight]*6,
//									   tvframe.size.width,
//									   tvframe.size.height)];
//	//}
	
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
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSString *identifier;
	if (indexPath.section == 0) {
		identifier = [NSString stringWithFormat:@"%@Top", [self.socialItems objectAtIndex:indexPath.row]];
	}
	if (indexPath.section == 1) {
		identifier = [NSString stringWithFormat:@"%@Top", [self.settingsItems objectAtIndex:indexPath.row]];
	}
	
	UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
	
	if ([[[[tableView cellForRowAtIndexPath:indexPath] textLabel] text] isEqualToString:@"Logout"]) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	//[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
		CGRect frame = self.slidingViewController.topViewController.view.frame;
		self.slidingViewController.topViewController = newTopViewController;
		self.slidingViewController.topViewController.view.frame = frame;
		[self.slidingViewController resetTopView];
	//}];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	if (section == 0) {
		UIImageView* hfimgvw = [[UIImageView alloc] initWithFrame: CGRectZero];
		[hfimgvw setBackgroundColor:[UIColor clearColor]];
		[hfimgvw setImage:[UIImage imageNamed:@"tableview.png"]];
		
		return nil;
	}
	else {
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
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 0;
	}
	if (section == 1) {
		return 30;
	}
	return [tableView sectionHeaderHeight];
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//	
//	if (section == 1) {
//		UIImageView* hfimgvw = [[UIImageView alloc] initWithFrame: CGRectZero];
//		[hfimgvw setBackgroundColor:[UIColor clearColor]];
//		[hfimgvw setImage:[UIImage imageNamed:@"tableview.png"]];
//		
//		return hfimgvw;
//	}
//	return [tableView footerViewForSection:section];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//	
//	if (section == 1) {
//		return [tableView rowHeight]*14;
//	}
//	return [tableView sectionFooterHeight];
//}

@end
