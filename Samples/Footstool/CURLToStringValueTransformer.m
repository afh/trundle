//
//  CURLToStringValueTransformer.m
//  Footstool
//
//  Created by Jonathan Wight on 04/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CURLToStringValueTransformer.h"


@implementation CURLToStringValueTransformer

+ (void)load
{
NSAutoreleasePool *thePool = [[NSAutoreleasePool alloc] init];
//
[self setValueTransformer:[[[self alloc] init] autorelease] forName:NSStringFromClass(self)];
//
[thePool release];
}

+ (Class)transformedValueClass
{
return([NSString class]);
}

+ (BOOL)allowsReverseTransformation
{
return(YES);
}

- (id)transformedValue:(id)value
{
return([value absoluteString]);
}

- (id)reverseTransformedValue:(id)value
{
return([NSURL URLWithString:value]);
}

@end
