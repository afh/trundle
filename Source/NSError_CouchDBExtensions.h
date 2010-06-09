//
//  NSError_CouchDBExtensions.h
//  CLI Sample
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (NSError_CouchDBExtensions)

+ (NSError *)errorWithCouchDBURLResponse:(NSURLResponse *)inURLResponse JSONDictionary:(NSDictionary *)inJSONDictionary;
+ (NSInteger)errorCodeForCouchDBError:(NSString *)inError;

@end
