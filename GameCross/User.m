//
//  User.m
//  GameCross
//
//  Created by Andrew Mackarous on 2012-11-26.
//  Copyright (c) 2012 Computer Science. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize result		= _result;
@synthesize username	= _username;
@synthesize email		= _email;
@synthesize password	= _password;
@synthesize token		= _token;
@synthesize counter		= _counter;

- (id) initWithResult:(NSString *)result
			 username:(NSString *)username
				email:(NSString *)email
			 password:(NSString *)password
				token:(NSString *)token
			  counter:(NSNumber *)counter {
	
    if ((self = [super init])) {
		self.username	= username;
		self.email		= email;
		self.password	= password;
		self.token		= token;
        self.counter	= counter;
    }
    return self;
	
}

- (NSString *) description {
	NSMutableString *string = [NSMutableString stringWithFormat:@"Result: %@\nUsername: %@\nEmail: %@\nPassword: %@\nToken: %@\nCounter: %@",
							   _result, _username, _email, _password, _token, _counter];
	
	return string;
}

@end
