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
#import "NSError_CouchDBExtensions.h"

@implementation CCouchDBURLOperation

@synthesize successHandler;
@synthesize failureHandler;
@synthesize JSON;

- (void)dealloc
{
[JSON release];
JSON = NULL;
//
[super dealloc];
}

#pragma mark -

- (void)didFailWithError:(NSError *)inError
{
[super didFailWithError:inError];
//
if (self.failureHandler != NULL)
    {
    self.failureHandler(inError);
    }
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
		theError = [NSError errorWithCouchDBURLResponse:self.response JSONDictionary:theJSON];
		}
	}

if (theError != NULL)
	{
	[self didFailWithError:theError];
	}
else
	{
	self.JSON = theJSON;
	[super didFinish];
    
    if (self.successHandler)
        {
        self.successHandler(theJSON);
        }
	}
}

@end
