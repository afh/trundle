//
//  CTest.m
//  CouchTest
//
//  Created by Jonathan Wight on 04/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CTest.h"

#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "CCouchDBDocument.h"

@implementation CTest

@synthesize server;
@synthesize testDatabase;
@synthesize error;
@synthesize done;

- (CouchDBFailureHandler)errorHandler
{
void (^theErrorHandler)(NSError *inError) = ^(NSError *inError) { self.error = inError; self.done = YES; };

return([theErrorHandler copy]);
}

- (void)main
{
self.server = [[[CCouchDBServer alloc] initWithURL:[NSURL URLWithString:@"http://localhost:5984"]] autorelease];

[self createDatabase];
//[self.server fetchDatabasesWithSuccessHandler:^(void) { NSLog(@"SUCCESS: %@", self.server.databases); } failureHandler:self.errorHandler];
//
//[self.server deleteDatabase:[self.server databaseNamed:@"test2"] withSuccessHandler:^(void) { NSLog(@"SUCCESS"); self.done = YES; } failureHandler:self.errorHandler];

while (self.done == NO)
	{
	[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
}

- (void)createDatabase
{
CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBDatabase *inDatabase) {
	NSLog(@"SUCCESS: %@", inDatabase);
	self.testDatabase = inDatabase;
	self.done = YES;
	};
[self.server createDatabaseNamed:@"test2" withSuccessHandler:theSuccessHandler failureHandler:self.errorHandler];
}




@end
