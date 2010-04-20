//
//  CTest.h
//  CouchTest
//
//  Created by Jonathan Wight on 04/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CCouchDBServer;
@class CCouchDBDatabase;

@interface CTest : NSObject {
	CCouchDBServer *server;
	CCouchDBDatabase *testDatabase;
	NSError *error;
	BOOL done;
}

@property (readwrite, retain) CCouchDBServer *server;
@property (readwrite, retain) CCouchDBDatabase *testDatabase;
@property (readwrite, retain) NSError *error;
@property (readwrite, assign) BOOL done;

- (void)main;

@end
