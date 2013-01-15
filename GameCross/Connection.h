#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "GDataXMLNode.h"
#import "Macros.h"

@class Connection;

@protocol ConnectionDelegate
- (void)setupWith:(NSData *)data;
@end

@interface Connection : NSObject{
    NSString *URL;
}

@property (weak, nonatomic) id <ConnectionDelegate> delegate;

@property (strong,nonatomic,readwrite) NSURLConnection *connection;
@property (nonatomic) NSMutableData *dataRead;

- (void)startWith:(NSString *)url;

@end
