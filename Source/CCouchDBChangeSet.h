//
//  CCouchDBChangeSet.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCouchDBDatabase;

@interface CCouchDBChangeSet : NSObject {
	CCouchDBDatabase *database;
	NSInteger lastSequence;
	NSSet *changedDocuments;
	NSSet *deletedDocuments;
}

@property (readonly, nonatomic, assign) CCouchDBDatabase *database;
@property (readonly, nonatomic, assign) NSInteger lastSequence;
@property (readonly, nonatomic, retain) NSSet *changedDocuments;
@property (readonly, nonatomic, retain) NSSet *deletedDocuments;

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase JSON:(id)inJSON;

@end
