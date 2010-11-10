//
//  CCouchDBChangeSet.m
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBChangeSet.h"

@interface CCouchDBChangeSet ()
@property (readwrite, nonatomic, assign) NSInteger lastSequence;
@property (readwrite, nonatomic, retain) NSSet *changedDocuments;
@property (readwrite, nonatomic, retain) NSSet *deletedDocuments;

- (BOOL)processJSON:(id)inJSON error:(NSError **)outError;
@end

#pragma mark -

@implementation CCouchDBChangeSet

@synthesize database;
@synthesize lastSequence;
@synthesize changedDocuments;
@synthesize deletedDocuments;

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase JSON:(id)inJSON
	{
	if ((self = [super init]) != NULL)
		{
		database = inDatabase;
		[self processJSON:inJSON error:NULL];
		}
	return(self);
	}
	
- (void)dealloc
	{
	database = NULL;
	[changedDocuments release];
	changedDocuments = NULL;
	[deletedDocuments release];
	deletedDocuments = NULL;
	//
	[super dealloc];
	}

#pragma mark -

- (NSString *)description
	{
	return([NSString stringWithFormat:@"%@ (lastSequence: %d, changed: %@, deleted: %@)", [super description], self.lastSequence, self.changedDocuments, self.deletedDocuments]);
	}

- (BOOL)processJSON:(id)inJSON error:(NSError **)outError
	{
	NSMutableSet *theResults = [NSMutableSet setWithArray:[inJSON objectForKey:@"results"]];
	NSSet *theDeletedDocuments = [theResults filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"deleted == YES"]];
	[theResults minusSet:theDeletedDocuments];
	
	self.changedDocuments = [theResults valueForKey:@"id"];
	self.deletedDocuments = [theDeletedDocuments valueForKey:@"id"];
	self.lastSequence = [[inJSON objectForKey:@"last_seq"] integerValue];
	
	return(YES);
	}

@end
