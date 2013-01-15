#import "Connection.h"

static NSString *IP = @"http://mackarous.dyndns.org:8181/social/";

@implementation Connection

- (void)startWith:(NSString *)url
{
    URL = url;
    
    NSString *emptyString = @"";
    const char *utfString = [emptyString UTF8String];
    
    self.dataRead = [NSMutableData dataWithBytes:utfString length:strlen(utfString)];
    [self startReceive];
}

- (BOOL)isReceiving
{
    return (self.connection != nil);
}

// Starts a connection to download the current URL.
- (void)startReceive
{
    BOOL            success;
    NSURL*          url;
    NSURLRequest*   request;
    
    assert(self.connection == nil); // don't tap receive twice in a row!
    
    // First get and check the URL.
    url = [[NetworkManager sharedInstance] smartURLForString:[NSString stringWithFormat:@"%@%@",IP,URL]];
    success = (url != nil);
    
    // If the URL is bogus, let the user know. Otherwise kick off the connection.
    if (!success) {
        NSLog(@"Invaliandred URL");
    }
    else {
        
        // Open a connection for the URL.
        request = [NSURLRequest requestWithURL:url];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        
        // Tell the UI we're receiving.
        [self receiveDidStart];
    }
}

- (void)receiveDidStart
{
    NSLog(@"Receiving");
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}


- (void)receiveDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"GET succeeded";
    }
    NSLog(@"%@",statusString);
    [[NetworkManager sharedInstance] didStopNetworkOperation];
    
    NSMutableString  *displayString = [NSMutableString stringWithString: @"XML=====\n" ];
    
    //Process the text your received here
    NSString *test = [[NSString alloc] initWithData:self.dataRead encoding:NSASCIIStringEncoding];
    [displayString appendString:test];

    [self.delegate setupWith:self.dataRead];
}

- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    [self receiveDidStopWithStatus:statusString];
}

// A delegate method called by the NSURLConnection when the request/response
// exchange is complete.  We look at the response to check that the HTTP
// status code is 2xx and that the Content-Type is acceptable.  If these checks
// fail, we give up on the transfer.
- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse*  httpResponse;
    NSString*           contentTypeHeader;
    
    assert(theConnection == self.connection);
    
    httpResponse = (NSHTTPURLResponse *) response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    
    if ((httpResponse.statusCode / 100) != 2) {
        [self stopReceiveWithStatus:[NSString stringWithFormat:@"HTTP error %zd", (ssize_t) httpResponse.statusCode]];
    } else {
        contentTypeHeader = [httpResponse MIMEType];
        if (contentTypeHeader == nil) {
            [self stopReceiveWithStatus:@"No Content-Type!"];
        } else if ( ! [contentTypeHeader isEqual:@"text/html"] || [contentTypeHeader isEqual:@"text/xml"]) {
        } else {
            NSLog(@"Response OK.");
        }
    }
}

// A delegate method called by the NSURLConnection as data arrives.
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)data
{
    assert(theConnection == self.connection);
    
    // Process the data you received here
    [self.dataRead appendData:data];
}

// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    assert(theConnection == self.connection);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection failed."
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    
    [self stopReceiveWithStatus:@"Connection failed"];
}

// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:nil];
}

@end
