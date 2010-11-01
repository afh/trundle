#import <Foundation/Foundation.h>

#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBSession.h"
#import "CRunLoopHelper.h"

int main (int argc, const char * argv[])
{
NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

CRunLoopHelper *theRLH = [[[CRunLoopHelper alloc] init] autorelease];
CCouchDBServer *theServer = [[[CCouchDBServer alloc] init] autorelease];
CCouchDBDatabase *theDatabase = [theServer databaseNamed:@"test"];

// #############################################################################


NSOperation *theOperation = [theDatabase operationForChangesSuccessHandler:^(id inParameter) { NSLog(@"%@", inParameter); } failureHandler:^(NSError *inError) { NSLog(@"%@", inError); }];
NSLog(@"%@", theOperation);

[theRLH prepare];

[theServer.session.operationQueue addOperation:theOperation];

[theRLH run];



[pool drain];
return 0;
}
