//
//  FootstoolAppDelegate.m
//  Footstool
//
//  Created by Jonathan Wight on 04/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "FootstoolAppDelegate.h"

#import "CCouchDBServer.h"
#import "CCouchDBDocument.h"
#import "CCouchDBDatabase.h"
#import "CKVOBlockNotificationCenter.h"
#import "NSArray_ConvenienceExtensions.h"

@implementation FootstoolAppDelegate

@synthesize window;
@synthesize databasesController;
@synthesize documentsController;
@synthesize serverURL;
@synthesize server;
@synthesize databases;
@synthesize documents;
@synthesize status;

- (id)init
{
if ((self = [super init]) != NULL)
	{
	self.serverURL = [NSURL URLWithString:@"http://localhost:5984"];
	status = [@"" copy];
	}
return(self);
}

- (void)dealloc
{

//
[super dealloc];
}

#pragma mark -

- (void)setServerURL:(NSURL *)inServerURL
{
if (serverURL != inServerURL)
	{
	[serverURL release];
	serverURL = [inServerURL retain];
	
	self.server = [[CCouchDBServer alloc] initWithURL:serverURL];
	self.databases = NULL;
	self.documents = NULL;

	[self appendStatus:@"Fetching all databases."];

	CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(void)
		{
		dispatch_async(dispatch_get_main_queue(), ^{ self.databases = [self.server.databases allObjects]; });	
		[self appendStatusFormat:@"Fetched %d databases.", [self.server.databases count]];
		};
	[self.server fetchDatabasesWithSuccessHandler:theSuccessHandler failureHandler:[self errorHandler]];

	}
}


#pragma mark -

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
KVOBlock theUpdateSelectedDatabasesBlock = ^(NSString *keyPath, id object, NSDictionary *change, id identifier)
	{
	for (CCouchDBDatabase *theDatabase in self.databasesController.selectedObjects)
		{
		CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(NSArray *inDocuments)
			{
			[self appendStatusFormat:@"All documents fetched."];
			dispatch_async(dispatch_get_main_queue(), ^{ self.documents = inDocuments;  NSLog(@"%@", self.documents); });	
			};
		[theDatabase fetchAllDocumentsWithSuccessHandler:theSuccessHandler failureHandler:[self errorHandler]];
		}
	};
[self.databasesController addKVOBlock:theUpdateSelectedDatabasesBlock forKeyPath:@"selection" options:0 identifier:@"TODO_1"];

// #############################################################################

KVOBlock theUpdateSelectedDocumentsBlock = ^(NSString *keyPath, id object, NSDictionary *change, id identifier)
	{
	for (CCouchDBDocument *theDocument in self.documentsController.selectedObjects)
		{
		CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBDocument *inDocument)
			{
			[self appendStatusFormat:@"Document fetched: %@", inDocument.identifier];
			};
		[theDocument.database fetchDocumentForIdentifier:theDocument.identifier successHandler:theSuccessHandler failureHandler:[self errorHandler]];
		}
	};
[self.documentsController addKVOBlock:theUpdateSelectedDocumentsBlock forKeyPath:@"selection" options:0 identifier:@"TODO_1"];

// #############################################################################
}

- (CouchDBFailureHandler)errorHandler
{
void (^theErrorHandler)(NSError *inError) = ^(NSError *inError)
	{
	[self appendStatusFormat:@"Error: %@", inError];
	[NSApp presentError:inError];
	};

return([theErrorHandler copy]);
}

- (void)appendStatus:(NSString *)inStatus
{
dispatch_async(dispatch_get_main_queue(), ^{ self.status = [self.status stringByAppendingFormat:@"%@\n", inStatus]; });
}

- (void)appendStatusFormat:(NSString *)inFormat, ...
{
va_list argList;
va_start(argList, inFormat);
NSString *theString = [[[NSString alloc] initWithFormat:inFormat arguments:argList] autorelease];
[self appendStatus:theString];
}

- (IBAction)addDatabase:(id)inSender
{
NSString *theName = [NSString stringWithFormat:@"database-%d", random()];
CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBDatabase *inDatabase)
	{
	dispatch_async(dispatch_get_main_queue(), ^{ self.databases = [self.databases arrayByAddingObject:inDatabase]; });	
	[self appendStatusFormat:@"Database created.", inDatabase.name];
	};
[self.server createDatabaseNamed:theName withSuccessHandler:theSuccessHandler failureHandler:[self errorHandler]];
}

- (IBAction)removeDatabase:(id)inSender
{
for (CCouchDBDatabase *theDatabase in self.databasesController.selectedObjects)
	{
	[self appendStatusFormat:@"Deleting database '%@'.", theDatabase.name];

	CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(void)
		{
		dispatch_async(dispatch_get_main_queue(), ^{ self.databases = [self.databases arrayByRemovingObject:theDatabase]; });
		
		[self appendStatusFormat:@"Deleting database '%@' done.", theDatabase.name];
		};
	[self.server deleteDatabase:theDatabase withSuccessHandler:theSuccessHandler failureHandler:[self errorHandler]];
	}
}

- (IBAction)addDocument:(id)inSender
{
for (CCouchDBDatabase *theDatabase in self.databasesController.selectedObjects)
	{
	CouchDBSuccessHandler theSuccessHandler = (CouchDBSuccessHandler)^(CCouchDBDocument *inDocument)
		{
		dispatch_async(dispatch_get_main_queue(), ^{ self.documents = [self.documents arrayByAddingObject:inDocument]; });	
		[self appendStatusFormat:@"Document created '%@'.", inDocument.identifier];
		};
	[theDatabase createDocument:[NSDictionary dictionary] successHandler:theSuccessHandler failureHandler:self.errorHandler];
	}

}

- (IBAction)removeDocument:(id)inSender
{
for (CCouchDBDocument *theDocument in self.documentsController.selectedObjects)
	{
	[self appendStatusFormat:@"Deleting document '%@'.", theDocument.identifier];

	CouchDBSuccessHandler theHandler = (CouchDBSuccessHandler)^(void) {
		dispatch_async(dispatch_get_main_queue(), ^{ self.documents = [self.documents arrayByRemovingObject:theDocument]; });	
		[self appendStatusFormat:@"Deleting document '%@' done.", theDocument.identifier];
		};
	[theDocument.database deleteDocument:theDocument successHandler:theHandler failureHandler:[self errorHandler]];
	}
}

@end
