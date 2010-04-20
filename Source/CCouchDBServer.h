//
//  CCouchDBServer.h
//  CouchTest
//
//  Created by Jonathan Wight on 02/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CouchDBClientTypes.h"

@class CCouchDBDatabase;

@interface CCouchDBServer : NSObject {
	NSURL *URL;
	NSMutableDictionary *databasesByName;
	NSOperationQueue *operationQueue;
}

@property (readonly, retain) NSURL *URL;
@property (readonly, retain) NSSet *databases;
@property (readonly, retain) NSOperationQueue *operationQueue;

- (id)initWithURL:(NSURL *)inURL;

- (CCouchDBDatabase *)databaseNamed:(NSString *)inName;

- (void)createDatabaseNamed:(NSString *)inName withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)fetchDatabasesWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)fetchDatabaseNamed:(NSString *)inName withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)deleteDatabase:(CCouchDBDatabase *)inDatabase withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
