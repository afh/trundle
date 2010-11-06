//
//  CCouchDBDatabase.m
//  CouchTest
//
//  Created by Jonathan Wight on 02/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBDatabase.h"

#import "CCouchDBSession.h"
#import "CCouchDBServer.h"
#import "CFilteringJSONSerializer.h"
#import "CouchDBClientConstants.h"
#import "CCouchDBDocument.h"
#import "CCouchDBURLOperation.h"
#import "NSURL_Extensions.h"
#import "CCouchDBChangeSet.h"

@implementation CCouchDBDatabase

@synthesize server;
@synthesize name;
@synthesize cachedDocuments;

- (id)initWithServer:(CCouchDBServer *)inServer name:(NSString *)inName
{
if ((self = [self init]) != NULL)
	{
	server = inServer;
	name = [inName copy];
	}
return(self);
}

- (void)dealloc
{
server = NULL;
[name release];
name = NULL;
[cachedDocuments release];
cachedDocuments = NULL;
//
[super dealloc];
}

#pragma mark -

- (CCouchDBSession *)session
{
NSAssert(self.server.session != NULL, @"No session!");
return(self.server.session);
}

- (NSString *)description
{
return([NSString stringWithFormat:@"%@ (%@)", [super description], self.name]);
}

#pragma mark -

- (NSString *)encodedName
{
@synchronized(self)
	{
	if (encodedName == NULL)
		{
		encodedName = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self.name, NULL, CFSTR("/"), kCFStringEncodingUTF8);
		}
	return([[encodedName retain] autorelease]);
	}
}

- (NSURL *)URL
{
@synchronized(self)
	{
	if (URL == NULL)
		{
		URL = [[self.server.URL URLByAppendingPathComponent:self.encodedName] retain];
		}
	return([[URL retain] autorelease]);
	}
}

- (NSCache *)cachedDocuments
{
@synchronized(self)
	{
	if (cachedDocuments == NULL)
		{
		cachedDocuments = [[NSCache alloc] init];
		}
	return([[cachedDocuments retain] autorelease]);
	}
}

#pragma mark -

//- (CCouchDBView *)designDocumentNamed:(NSString *)inName
//{
//}

- (CURLOperation *)operationToCreateDocument:(NSDictionary *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:self.URL];
theRequest.HTTPMethod = @"POST";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];

NSData *theData = [self.session.serializer serializeDictionary:inDocument error:NULL];
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Content-Type"];
[theRequest setHTTPBody:theData];

CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	if (theOperation.error)
		{
		if (inFailureHandler)
			inFailureHandler(theOperation.error);
		return;
		}

	if ([[inParameter objectForKey:@"ok"] boolValue] == NO)
		{
		NSError *theError = [NSError errorWithDomain:kCouchErrorDomain code:-3 userInfo:NULL];
		if (inFailureHandler)
			inFailureHandler(theError);
		return;
		}

	NSString *theIdentifier = [inParameter objectForKey:@"id"];
	NSString *theRevision = [inParameter objectForKey:@"rev"];

	CCouchDBDocument *theDocument = [[[CCouchDBDocument alloc] initWithDatabase:self identifier:theIdentifier revision:theRevision] autorelease];
	[theDocument populateWithJSONDictionary:inDocument];
	[self.cachedDocuments setObject:theDocument forKey:theIdentifier];

	if (inSuccessHandler)
		inSuccessHandler(theDocument);
	};
theOperation.failureHandler = inFailureHandler;

return(theOperation);
}

- (CURLOperation *)operationToCreateDocument:(NSDictionary *)inDocument identifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
NSURL *theURL = [self.URL absoluteURL];
//theURL = [[self.URL absoluteURL] URLByAppendingPathComponent:inIdentifier];
theURL = [theURL URLByAppendingPathComponent:inIdentifier];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"PUT";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
NSData *theData = [self.session.serializer serializeDictionary:inDocument error:NULL];
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Content-Type"];
[theRequest setHTTPBody:theData];

CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	if ([[inParameter objectForKey:@"ok"] boolValue] == NO)
		{
		NSError *theError = [NSError errorWithDomain:kCouchErrorDomain code:-3 userInfo:NULL];
		if (inFailureHandler)
			inFailureHandler(theError);
		return;
		}

	NSString *theRevision = [inParameter objectForKey:@"rev"];

	CCouchDBDocument *theDocument = [[[CCouchDBDocument alloc] initWithDatabase:self identifier:inIdentifier revision:theRevision] autorelease];
	[theDocument populateWithJSONDictionary:inDocument];
	[self.cachedDocuments setObject:theDocument forKey:inIdentifier];

	if (inSuccessHandler)
		inSuccessHandler(theDocument);
	};
theOperation.failureHandler = inFailureHandler;
return(theOperation);
}

#pragma mark -

- (void)createDocument:(NSDictionary *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
CURLOperation *theOperation = [self operationToCreateDocument:inDocument successHandler:inSuccessHandler failureHandler:inFailureHandler];

[self.session.operationQueue addOperation:theOperation];
}

- (void)createDocument:(NSDictionary *)inDocument identifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
CURLOperation *theOperation = [self operationToCreateDocument:inDocument identifier:inIdentifier successHandler:inSuccessHandler failureHandler:inFailureHandler];
[self.session.operationQueue addOperation:theOperation];
}

- (void)fetchAllDocumentsWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
NSURL *theURL = [self.URL URLByAppendingPathComponent:@"_all_docs"];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"GET";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	NSMutableArray *theDocuments = [NSMutableArray array];
	for (NSDictionary *theRow in [inParameter objectForKey:@"rows"])
		{
		NSString *theIdentifier = [theRow objectForKey:@"id"];

		CCouchDBDocument *theDocument = [self.cachedDocuments objectForKey:theIdentifier];
		if (theDocument == NULL)
			{
			theDocument = [[[CCouchDBDocument alloc] initWithDatabase:self identifier:theIdentifier] autorelease];
			[self.cachedDocuments setObject:theDocument forKey:theIdentifier];
			}

		theDocument.revision = [theRow valueForKeyPath:@"value.rev"];

		[theDocuments addObject:theDocument];
		}

	if (inSuccessHandler)
		inSuccessHandler(theDocuments);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (void)fetchDocumentForIdentifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
NSURL *theURL = [self.URL URLByAppendingPathComponent:inIdentifier];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"GET";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	CCouchDBDocument *theDocument = [self.cachedDocuments objectForKey:inIdentifier];
	if (theDocument == NULL)
		{
		theDocument = [[[CCouchDBDocument alloc] initWithDatabase:self] autorelease];
		[self.cachedDocuments setObject:theDocument forKey:inIdentifier];
		}

	[theDocument populateWithJSONDictionary:inParameter];

	if (inSuccessHandler)
		inSuccessHandler(theDocument);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (void)fetchDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
{
// TODO -- this only fetches the latest document (i.e. _rev is ignored). What if we don't want the latest document?
NSURL *theURL = inDocument.URL;
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"GET";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	[inDocument populateWithJSONDictionary:inParameter];

	if (inSuccessHandler)
		inSuccessHandler(inDocument);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (void)updateDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
NSURL *theURL = inDocument.URL;
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"PUT";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
NSData *theData = [self.session.serializer serializeDictionary:inDocument.content error:NULL];
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Content-Type"];
[theRequest setHTTPBody:theData];

CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	[inDocument populateWithJSONDictionary:inParameter];

	if (inSuccessHandler)
		inSuccessHandler(inDocument);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (void)deleteDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
{
NSURL *theURL = [inDocument.URL URLByAppendingPathComponent:[NSString stringWithFormat:@"?rev=%@", inDocument.revision]];
NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
theRequest.HTTPMethod = @"DELETE";
[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
theOperation.successHandler = ^(id inParameter) {
	[self.cachedDocuments removeObjectForKey:inDocument];

	if (inSuccessHandler)
		inSuccessHandler(inDocument);
	};
theOperation.failureHandler = inFailureHandler;

[self.session.operationQueue addOperation:theOperation];
}

- (CURLOperation *)operationForChanges:(NSDictionary *)inOptions successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    NSURL *theURL = [self.URL URLByAppendingPathComponent:@"_changes"];
	if (inOptions)
		{
		theURL = [NSURL URLWithRoot:theURL queryDictionary:inOptions];
		}
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
    theRequest.HTTPMethod = @"GET";
	[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
	[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];

    CCouchDBURLOperation *theOperation = [[[CCouchDBURLOperation alloc] initWithSession:self.session request:theRequest] autorelease];
    theOperation.successHandler = ^(id inParameter) {
		CCouchDBChangeSet *theChangeSet = [[[CCouchDBChangeSet alloc] initWithJSON:inParameter] autorelease];

        if (inSuccessHandler)
            inSuccessHandler(theChangeSet);
        };
    theOperation.failureHandler = inFailureHandler;

    return(theOperation);
    }

- (CURLOperation *)operationToBulkCreateDocuments:(id)inDocuments successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    NSURL *theURL = [self.URL URLByAppendingPathComponent:@"_bulk_docs"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
    theRequest.HTTPMethod = @"POST";

    NSDictionary *theBody = [NSDictionary dictionaryWithObjectsAndKeys:
        inDocuments, @"docs",
        NULL];

    NSData *theData = [self.session.serializer serializeDictionary:theBody error:NULL];
    [theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:theData];

    CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
    theOperation.successHandler = ^(id inParameter) {
        if (theOperation.error)
            {
            if (inFailureHandler)
                inFailureHandler(theOperation.error);
            return;
            }

//        if ([[inParameter objectForKey:@"ok"] boolValue] == NO)
//            {
//            NSError *theError = [NSError errorWithDomain:kCouchErrorDomain code:-3 userInfo:NULL];
//            if (inFailureHandler)
//                inFailureHandler(theError);
//            return;
//            }

        if (inSuccessHandler)
            inSuccessHandler(theOperation.JSON);
        };

    return(theOperation);
    }

@end
