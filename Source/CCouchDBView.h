//
//  CCouchDBView.h
//  AnythingBucket
//
//  Created by Jonathan Wight on 10/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CouchDBClientTypes.h"

@class CCouchDBDatabase;

@interface CCouchDBView : NSObject {
    CCouchDBDatabase *database;
    NSString *identifier;
}

@property (readonly, nonatomic, assign) CCouchDBDatabase *database;
@property (readonly, nonatomic, retain) NSString *identifier;
@property (readonly, nonatomic, retain) NSURL *URL;

- (id)initWithDatabase:(CCouchDBDatabase *)inDatabase identifier:(NSString *)inIdentifier;

- (void)fetchViewNamed:(NSString *)inName options:(NSDictionary *)inOptions withSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
