//
//  CCouchDBDatabase.h
//  CouchTest
//
//  Created by Jonathan Wight on 02/16/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CouchDBClientTypes.h"

@class CCouchDBServer;
@class CCouchDBDocument;
@class CURLOperation;

@interface CCouchDBDatabase : NSObject {
	CCouchDBServer *server;
	NSString *name;
	NSString *encodedName;
	NSURL *URL;
	NSCache *cachedDocuments;
}

@property (readonly, assign) CCouchDBServer *server;
@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *encodedName;
@property (readonly, copy) NSURL *URL;
@property (readonly, retain) NSCache *cachedDocuments;

- (id)initWithServer:(CCouchDBServer *)inServer name:(NSString *)inName;

- (CURLOperation *)operationToCreateDocument:(NSDictionary *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (CURLOperation *)operationToCreateDocument:(NSDictionary *)inDocument identifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

- (void)createDocument:(NSDictionary *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)createDocument:(NSDictionary *)inDocument identifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

- (void)fetchAllDocumentsWithSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)fetchDocumentForIdentifier:(NSString *)inIdentifier successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;
- (void)fetchDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

- (void)updateDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

- (void)deleteDocument:(CCouchDBDocument *)inDocument successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

//- (CURLOperation *)operationForChangesSuccessHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

- (CURLOperation *)operationToBulkCreateDocuments:(id)inDocuments successHandler:(CouchDBSuccessHandler)inSuccessHandler failureHandler:(CouchDBFailureHandler)inFailureHandler;

@end
