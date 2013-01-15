//
//  NetworkManager.h
// Based on code from http://developer.apple.com/library/ios/#samplecode/SimpleURLConnections/Introduction/Intro.html

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (NSURL *)smartURLForString:(NSString *)str;


@property (nonatomic, assign, readonly ) NSUInteger     networkOperationCount;  // observable

- (void)didStartNetworkOperation;
- (void)didStopNetworkOperation;

@end

