//
//  User.h
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
	NSString *_result;
	NSString *_username;
	NSString *_password;
	NSString *_token;
	NSNumber *_counter;
}

@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSNumber *counter;

- (id) initWithResult:(NSString *)result
			 username:(NSString *)username
			 password:(NSString *)password
				token:(NSString *)token
			  counter:(NSNumber *)counter;

- (NSString *) description;

@end