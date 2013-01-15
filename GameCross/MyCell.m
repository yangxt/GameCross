//
//  MyCell.m
//  Lecture16
//
//  Created by Andrew Mackarous on 12-03-06.
//  Copyright (c) 2012 Apple Inc. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell

@synthesize textField;
@synthesize label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
