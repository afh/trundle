//
//  CDictionaryToJSONStringValueTransformer.m
//  Footstool
//
//  Created by Jonathan Wight on 04/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CDictionaryToJSONStringValueTransformer.h"

#import "CJSONDataSerializer.h"
#import "NSDictionary_MoreBlockExtensions.h"

@implementation CDictionaryToJSONStringValueTransformer

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
return(NO);
}

- (id)transformedValue:(id)value
{
if (value == NULL)
	return(@"<NULL>");
NSDictionary *theDictionary = value;

NSSet *theBannedKeys = [NSSet setWithObjects:@"_rev", @"_id", NULL];
theDictionary = [theDictionary dictionaryFilteredWithEntiresPassingTest:^(id key, id obj, BOOL *stop) { return((BOOL)([theBannedKeys containsObject:key] == NO)); }];
	
NSData *theData = [[CJSONDataSerializer serializer] serializeDictionary:theDictionary];
NSString *theString = [[[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding] autorelease];

return(theString);
}

/*
- (id)reverseTransformedValue:(id)value
{
return(<#some value#>;
}
*/

@end
