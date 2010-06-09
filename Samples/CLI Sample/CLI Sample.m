#import <Foundation/Foundation.h>

#import "CCouchDBServer.h"
#import "CRunLoopHelper.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CRunLoopHelper *theRLH = [[[CRunLoopHelper alloc] init] autorelease];
CCouchDBServer *theServer = [[[CCouchDBServer alloc] initWithURL:[NSURL URLWithString:@"http://localhost:5984/"]] autorelease];

// #############################################################################

[theRLH prepare];

[theServer fetchDatabasesWithSuccessHandler:^(id p) { NSLog(@"%@", p); [theRLH stop]; } failureHandler:NULL];

[theRLH run];

// #############################################################################

[theRLH prepare];

[theServer fetchDatabaseNamed:@"xyzzy" withSuccessHandler:^(id p) { NSLog(@"%@", p); [theRLH stop]; } failureHandler:^(NSError *p) { NSLog(@"%@", p); [theRLH stop]; }];

[theRLH run];

// #############################################################################

[theRLH prepare];

[theServer createDatabaseNamed:@"xyzzy" withSuccessHandler:^(id p) { NSLog(@"%@", p); [theRLH stop]; } failureHandler:^(NSError *p) { NSLog(@"%@", p.userInfo); [theRLH stop]; }];

[theRLH run];


[pool drain];
return 0;
}
