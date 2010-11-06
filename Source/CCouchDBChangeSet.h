//
//  CCouchDBChangeSet.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 11/03/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCouchDBChangeSet : NSObject {
	NSInteger lastSequence;
	NSSet *changedDocuments;
	NSSet *deletedDocuments;
}

@property (readonly, nonatomic, assign) NSInteger lastSequence;
@property (readonly, nonatomic, retain) NSSet *changedDocuments;
@property (readonly, nonatomic, retain) NSSet *deletedDocuments;

- (id)initWithJSON:(id)inJSON;

@end
