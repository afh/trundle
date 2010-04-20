//
//  NSDictionary_MoreBlockExtensions.h
//  Footstool
//
//  Created by Jonathan Wight on 04/20/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSDictionary_MoreBlockExtensions)

- (NSDictionary *)dictionaryFilteredWithEntiresPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))inPredicate;
- (NSDictionary *)dictionaryFilteredWithOptions:(NSEnumerationOptions)inOptions withEntriesPassingTest:(BOOL (^)(id key, id obj, BOOL *stop))inPredicate;

@end
