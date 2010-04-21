//
//  NSArray_ConvenienceExtensions.m
//  Footstool
//
//  Created by Jonathan Wight on 04/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSArray_ConvenienceExtensions.h"


@implementation NSArray (NSArray_ConvenienceExtensions)

- (NSArray *)arrayByRemovingObject:(id)anObject
{
NSMutableArray *theArray = [[self mutableCopy] autorelease];
[theArray removeObject:anObject];
return([[theArray copy] autorelease]);
}

@end
