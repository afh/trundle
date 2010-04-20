//
//  CouchDBClientTypes.h
//  CouchTest
//
//  Created by Jonathan Wight on 02/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CouchDBSuccessHandler)(id inParameter);
typedef void (^CouchDBFailureHandler)(NSError *inError);