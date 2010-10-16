//
//  CCouchDBSession.m
//  TouchMetricsTest
//
//  Created by Jonathan Wight on 08/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CCouchDBSession.h"

#import "CCouchDBURLOperation.h"
#import "CFilteringJSONSerializer.h"
#import "NSDate_InternetDateExtensions.h"

@implementation CCouchDBSession

@synthesize operationQueue;
@synthesize URLOperationClass;
@synthesize serializer;

- (void)dealloc
{
[operationQueue cancelAllOperations];
[operationQueue waitUntilAllOperationsAreFinished];
[operationQueue release];
operationQueue = NULL;
//
[super dealloc];
}

#pragma mark -

- (NSOperationQueue *)operationQueue
{
if (operationQueue == NULL)
    {
    operationQueue = [[NSOperationQueue alloc] init];
    }
return(operationQueue);
}

- (Class)URLOperationClass
{
if (URLOperationClass == NULL)
    {
    return([CCouchDBURLOperation class]);
    }
return(URLOperationClass);
}

- (CJSONSerializer *)serializer
{
if (serializer == NULL) 
    {
    CFilteringJSONSerializer *theSerializer = [CFilteringJSONSerializer serializer];
    JSONConversionConverter theConverter = ^(id inObject) {
        return((id)[(NSDate *)inObject ISO8601String]);
        };
    theSerializer.convertersByName = [NSDictionary dictionaryWithObject:theConverter forKey:@"date"];
    JSONConversionTest theTest = ^(id inObject) {
        NSString *theName = NULL;
        if ([inObject isKindOfClass:[NSDate class]])
            {
            theName = @"date";
            }
        return(theName);
        };
    theSerializer.tests = [NSSet setWithObject:theTest];
    serializer = [theSerializer retain];
    }
return(serializer);
}

@end
