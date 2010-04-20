//
//  CCouchDBURLOperation.m
//  CouchTest
//
//  Created by Jonathan Wight on 04/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBURLOperation.h"

#import "CJSONDeserializer.h"
#import "CouchDBClientConstants.h"

@implementation CCouchDBURLOperation

@synthesize JSON;

- (void)dealloc
{
[JSON release];
JSON = NULL;
//
[super dealloc];
}

- (void)didFinish
{
NSHTTPURLResponse *theHTTPResponse = (NSHTTPURLResponse *)self.response;

NSError *theError = NULL;

NSString *theContentType = [theHTTPResponse.allHeaderFields objectForKey:@"Content-Type"];
if ([theContentType isEqualToString:kContentTypeJSON])
	{
	theError = [NSError errorWithDomain:kCouchErrorDomain code:CouchDBErrorCode_ContentTypeNotJSON userInfo:NULL];
	}

id theJSON = NULL;
if (theError == NULL)
	{
	theJSON = [[CJSONDeserializer deserializer] deserialize:self.data error:&theError];
	NSInteger theStatusCode = theHTTPResponse.statusCode;
	if (theJSON == NULL || theStatusCode < 200 || theStatusCode >= 300)
		{
		NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
		
		if (theError != NULL)
			[theUserInfo setObject:theError forKey:NSUnderlyingErrorKey];
		if (theHTTPResponse)
			[theUserInfo setObject:theHTTPResponse forKey:@"Response"];
		if ([theJSON objectForKey:@"reason"] != NULL)
			[theUserInfo setObject:[theJSON objectForKey:@"reason"] forKey:NSLocalizedDescriptionKey];
		
		theError = [NSError errorWithDomain:kCouchErrorDomain code:CouchDBErrorCode_ServerError userInfo:theUserInfo];
		}
	}

if (theError != NULL)
	{
	[self didFail:theError];
	}
else
	{
	self.JSON = theJSON;
	[super didFinish];
	}
}

@end
