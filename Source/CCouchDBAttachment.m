//
//  CCouchDBAttachment.m
//  CouchTest
//
//  Created by Jonathan Wight on 02/23/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBAttachment.h"

@implementation CCouchDBAttachment

@synthesize document;
@synthesize identifier;
@synthesize contentType;
@synthesize data;

- (id)initWithIdentifier:(NSString *)inIdentifier contentType:(NSString *)inContentType data:(NSData *)inData;
	{
	if ((self = [super init]) != NULL)
		{
		identifier = [inIdentifier retain];
		contentType = [inContentType retain];
		data = [inData retain];
		}
	return(self);
	}

- (void)dealloc
    {
    [identifier release];
    identifier = NULL;
    [contentType release];
    contentType = NULL;
    [data release];
    data = NULL;
    //
    [super dealloc];
    }

@end
