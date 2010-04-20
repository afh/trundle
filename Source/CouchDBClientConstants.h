//
//  CouchDBClientConstants.h
//  CouchTest
//
//  Created by Jonathan Wight on 02/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kCouchErrorDomain /* = @"CouchErrorDomain" */;

typedef enum {
	CouchDBErrorCode_ContentTypeNotJSON = -100,
	CouchDBErrorCode_ServerError = -101,
	} ECouchDBErrorCode;

extern NSString *kContentTypeJSON /* = @"application/json" */;