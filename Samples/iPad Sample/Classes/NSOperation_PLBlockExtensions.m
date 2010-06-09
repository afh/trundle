//
//  NSOperation_PLBlockExtensions.m
//  iPad Sample
//
//  Created by Jonathan Wight on 04/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "NSOperation_PLBlockExtensions.h"

@interface NSOperation (NSOperation_PLBlockExtensionsSwizzle)

- (void (^)(void))MY_completionBlock;
- (void)MY_setCompletionBlock:(void (^)(void))block;

@end

@implementation NSOperation (NSOperation_PLBlockExtensionsSwizzle)

- (void (^)(void))MY_completionBlock
{
return(NULL);
}

- (void)MY_setCompletionBlock:(void (^)(void))block
{
}

@end
