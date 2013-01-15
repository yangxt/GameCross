//
//  MyCell.h
//  Lecture16
//
//  Created by Andrew Mackarous on 12-03-06.
//  Copyright (c) 2012 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell {
	
	UITextField *textField;
}

@property (nonatomic, strong) IBOutlet UITextField *textField;

@end
