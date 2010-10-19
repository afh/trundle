//
//  NSError_CouchDBExtensions.m
//  CLI Sample
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSError_CouchDBExtensions.h"

#import "CouchDBClientConstants.h"

@implementation NSError (NSError_CouchDBExtensions)

+ (NSError *)couchDBErrorWithError:(NSError *)inError JSONDictionary:(NSDictionary *)inJSONDictionary
{
NSError *theError = NULL;
if ([inError.domain isEqual:NSURLErrorDomain] && (inError.code < 200 || inError.code >= 300))
	{
	NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];

    [theUserInfo setObject:inError forKey:NSUnderlyingErrorKey];
	
	if ([inJSONDictionary objectForKey:@"reason"] != NULL)
		[theUserInfo setObject:[inJSONDictionary objectForKey:@"reason"] forKey:NSLocalizedDescriptionKey];
	if (inJSONDictionary)
		[theUserInfo setObject:inJSONDictionary forKey:@"json"];
	
	NSInteger theErrorCode = [self errorCodeForCouchDBError:[inJSONDictionary objectForKey:@"reason"]];
	
	theError = [NSError errorWithDomain:kCouchErrorDomain code:theErrorCode userInfo:theUserInfo];
	}

return(theError);
}

+ (NSError *)couchDBErrorWithURLResponse:(NSURLResponse *)inURLResponse JSONDictionary:(NSDictionary *)inJSONDictionary
{
NSError *theError = NULL;
NSHTTPURLResponse *theHTTPResponse = (NSHTTPURLResponse *)inURLResponse;
NSInteger theStatusCode = theHTTPResponse.statusCode;
if (inJSONDictionary == NULL || theStatusCode < 200 || theStatusCode >= 300)
	{
	NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
	
	if (theHTTPResponse)
		[theUserInfo setObject:theHTTPResponse forKey:@"Response"];
	if ([inJSONDictionary objectForKey:@"reason"] != NULL)
		[theUserInfo setObject:[inJSONDictionary objectForKey:@"reason"] forKey:NSLocalizedDescriptionKey];
	if (inJSONDictionary)
		[theUserInfo setObject:inJSONDictionary forKey:@"json"];
	
	NSInteger theErrorCode = [self errorCodeForCouchDBError:[inJSONDictionary objectForKey:@"reason"]];
	
	theError = [NSError errorWithDomain:kCouchErrorDomain code:theErrorCode userInfo:theUserInfo];
	}

return(theError);
}

+ (NSInteger)errorCodeForCouchDBError:(NSString *)inError
{
if ([inError isEqualToString:@"no_db_file"])
	{
	return(CouchDBErrorCode_NoDatabase);
	}
else
	{
	return(CouchDBErrorCode_ServerError);
	}
}

@end
