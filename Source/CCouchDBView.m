//
//  CCouchDBView.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBView.h"

#import "NSURL_Extensions.h"

#import "CCouchDBDatabase.h"
#import "CCouchDBDocument.h"
#import "CCouchDBServer.h"
#import "CCouchDBSession.h"
#import "CCouchDBURLOperation.h"
#import "CouchDBClientConstants.h"

@interface CCouchDBView ()
@property (readonly, nonatomic, retain) CCouchDBSession *session;
@end

#pragma mark -

@implementation CCouchDBView

@synthesize database;
@synthesize identifier;

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase identifier:(NSString *)inIdentifier
    {
    if ((self = [super init]) != NULL)
        {
        database = inDatabase;
        identifier = [inIdentifier retain];
        }
    return(self);
    }

- (void)dealloc
    {
    [database release];
    database = NULL;

    [identifier release];
    identifier = NULL;
    //
    [super dealloc];
    }

#pragma mark -

- (NSURL *)URL
    {
    return([self.database.URL URLByAppendingPathComponent:[NSString stringWithFormat:@"_design/%@", self.identifier]]);
    }

- (CCouchDBSession *)session
    {
    return(self.database.server.session);
    }

#pragma mark -

- (void)fetchViewNamed:(NSString *)inName options:(NSDictionary *)inOptions withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler
    {
    NSURL *theURL = [self.URL URLByAppendingPathComponent:[NSString stringWithFormat:@"_view/%@", inName]];

    if (inOptions.count > 1)
        {
        theURL = [NSURL URLWithRoot:theURL queryDictionary:inOptions];
        }

	NSLog(@"%@", theURL);

    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:theURL];
    theRequest.HTTPMethod = @"GET";
	[theRequest setValue:kContentTypeJSON forHTTPHeaderField:@"Accept"];
    CCouchDBURLOperation *theOperation = [self.session URLOperationWithRequest:theRequest];
    theOperation.successHandler = ^(id inParameter) {
        NSMutableArray *theDocuments = [NSMutableArray array];
        for (NSDictionary *theRow in [inParameter objectForKey:@"rows"])
            {
            CCouchDBDocument *theDocument = [[[CCouchDBDocument alloc] initWithDatabase:self.database] autorelease];
            [theDocument populateWithJSONDictionary:[theRow valueForKeyPath:@"value"]];
            [theDocuments addObject:theDocument];
            }

        if (inSuccessHandler)
            inSuccessHandler(theDocuments);
        };
    theOperation.failureHandler = inFailureHandler;

    [self.session.operationQueue addOperation:theOperation];
    }

@end
