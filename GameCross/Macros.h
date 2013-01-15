//
//  Macros.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-27.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Macros <NSObject>

#define IS_IPHONE ( [[[UIDevice currentDevice] model] isEqualToString:@"iPhone"] )
#define IS_IPOD   ( [[[UIDevice currentDevice ] model] isEqualToString:@"iPod touch"] )
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_IPHONE_5 ( IS_IPHONE && IS_HEIGHT_GTE_568 )
#define CORNER_RADIUS 5.0f

@end
