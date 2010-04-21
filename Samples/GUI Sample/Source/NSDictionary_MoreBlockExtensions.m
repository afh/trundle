//
//  NSDictionary_MoreBlockExtensions.m
//  Footstool
//
//  Created by Jonathan Wight on 04/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSDictionary_MoreBlockExtensions.h"


@implementation NSDictionary (NSDictionary_MoreBlockExtensions)

- (NSDictionary *)dictionaryFilteredWithEntiresPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))inPredicate
{
return([self dictionaryFilteredWithOptions:0 withEntriesPassingTest:inPredicate]);
}

- (NSDictionary *)dictionaryFilteredWithOptions:(NSEnumerationOptions)inOptions withEntriesPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))inPredicate
{
NSMutableDictionary *theNewDictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];

[self enumerateKeysAndObjectsWithOptions:inOptions usingBlock:^(id key, id obj, BOOL *stop) { if (inPredicate(key, obj, stop) == YES) [theNewDictionary setObject:obj forKey:key]; }];

return([[theNewDictionary copy] autorelease]);
}

@end
