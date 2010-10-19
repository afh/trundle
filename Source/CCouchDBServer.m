//
//  CCouchDBServer.m
//  CouchTest
//
//  Created by Jonathan Wight on 02/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBServer.h"

#import "Asserts.h"
#import "CJSONDeserializer.h"

#import "CCouchDBSession.h"
#import "CCouchDBDatabase.h"
#import "CouchDBClientConstants.h"
#import "CCouchDBURLOperation.h"

@interface CCouchDBServer ()
@property (readonly, retain) NSMutableDictionary *databasesByName;
@end

#pragma mark -

@implementation CCouchDBServer

@synthesize session;
@synthesize URL;
@synthesize databasesByName;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
if ([key isEqualToString:@"databases"])
	return([NSSet setWithObjects:@"databasesByName", NULL]);
else
	{
	return(NULL);
	}
}

- (id)init
{
if ((self = [self initWithSession:NULL URL:[NSURL URLWithString:@"http://localhost:5984/"]]) != NULL)
	{
	}
return(self);
}

- (id)initWithSession:(CCouchDBSession *)inSession URL:(NSURL *)inURL;
{
if ((self = [super init]) != NULL)
	{
    session = [inSession retain];
	URL = [inURL retain];
	if ([URL.path length] == 0)
		URL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/", [inURL absoluteString]]];
	}
return(self);
}

- (void)dealloc
{
session = NULL;

[URL release];
URL = NULL;
//
[databasesByName release];
databasesByName = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (%@)", [super description], self.URL]);
}

#pragma mark -

- (CCouchDBSession *)session
{
if (session == NULL)
    {
    session = [[CCouchDBSession alloc] init];
    }
return(session);
}

- (NSSet *)databases
{
return([NSSet setWithArray:[self.databasesByName allValues]]);
}

- (NSMutableDictionary *)databasesByName
{
@synchronized(self)
	{
	if (databasesByName == NULL)
		{
		databasesByName = [[NSMutableDictionary alloc] init];
		}
	return(databasesByName);
	}
}

- (CCouchDBDatabase *)databaseNamed:(NSString *)inName
{
CCouchDBDatabase *theDatabase = [self.databasesByName objectForKey:inName];
if (theDatabase == NULL)
	{
	theDatabase = [[[CCouchDBDatabase alloc] initWithServer:self name:inName] autorelease];
	[self.databasesByName setObject:theDatabase forKey:inName];
	}
return(theDatabase);
}

#pragma mark -

- (void)createDatabaseNamed:(NSString *)inName withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
CCouchDBDatabase *theRemoteDatabase = [[[CCouchDBDatabase alloc] initWithServer:self name:inName] autorelease];
NSURL *theURL = [NSURL URLWithString:theRemoteDatabase.encodedName relativeToURL:self.URL];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"PUT";
CCouchDBURLOperation *theOperation = [[[[self.session URLOperationClass] alloc] initWithRequest:theRequest] autorelease];
theOperation.successHandler = ^(id inParameter) {
	[self willChangeValueForKey:@"databasesByName"];
	[self.databasesByName setObject:theRemoteDatabase forKey:inName];
	[self didChangeValueForKey:@"databasesByName"];

	if (inSuccessHandler)
		inSuccessHandler(theRemoteDatabase);
	};
theOperation.failureHandler = inFailureHandler;
[self.session.operationQueue addOperation:theOperation];
}

- (void)fetchDatabasesWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
NSURL *theURL = [NSURL URLWithString:@"_all_dbs" relativeToURL:self.URL];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"GET";
CCouchDBURLOperation *theOperation = [[[[self.session URLOperationClass] alloc] initWithRequest:theRequest] autorelease];
theOperation.successHandler = ^(id inParameter) {
	[self willChangeValueForKey:@"databases"];
	for (NSString *theName in inParameter)
		{
		if ([self.databasesByName objectForKey:theName] == NULL)
			{
			CCouchDBDatabase *theDatabase = [[[CCouchDBDatabase alloc] initWithServer:self name:theName] autorelease];
			[self willChangeValueForKey:@"databasesByName"];
			[self.databasesByName setObject:theDatabase forKey:theName];
			[self didChangeValueForKey:@"databasesByName"];
			}
		}
	[self didChangeValueForKey:@"databases"];

 	if (inSuccessHandler)
		inSuccessHandler([self.databasesByName allValues]);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (void)fetchDatabaseNamed:(NSString *)inName withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
CCouchDBDatabase *theRemoteDatabase = [[[CCouchDBDatabase alloc] initWithServer:self name:inName] autorelease];
NSURL *theURL = [NSURL URLWithString:theRemoteDatabase.encodedName relativeToURL:self.URL];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"GET";
CCouchDBURLOperation *theOperation = [[[[self.session URLOperationClass] alloc] initWithRequest:theRequest] autorelease];
theOperation.successHandler = ^(id inParameter) {
	[self willChangeValueForKey:@"databasesByName"];
	[self.databasesByName setObject:theRemoteDatabase forKey:inName];
	[self didChangeValueForKey:@"databasesByName"];

	if (inSuccessHandler)
		inSuccessHandler(theRemoteDatabase);
	};
theOperation.failureHandler = inFailureHandler;
[self.session.operationQueue addOperation:theOperation];
}

- (void)deleteDatabase:(CCouchDBDatabase *)inDatabase withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
NSURL *theURL = [NSURL URLWithString:inDatabase.encodedName relativeToURL:self.URL];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"DELETE";
CCouchDBURLOperation *theOperation = [[[[self.session URLOperationClass] alloc] initWithRequest:theRequest] autorelease];
theOperation.successHandler = ^(id inParameter) {
	[self willChangeValueForKey:@"databasesByName"];
	[self.databasesByName removeObjectForKey:inDatabase.name];
	[self didChangeValueForKey:@"databasesByName"];

	if (inSuccessHandler)
		inSuccessHandler(inDatabase);
	};
theOperation.failureHandler = inFailureHandler;
[self.session.operationQueue addOperation:theOperation];
}

@end
