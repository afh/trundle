//
//  CHackyOperation.m
//  iPad Sample
//
//  Created by Jonathan Wight on 04/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CHackyOperation.h"

#include <objc/runtime.h>
#import "CURLOperation.h"

void AliasMethod(Class inClass, SEL inNewSelector, SEL inOldSelector)
{
Method theOldMethod = class_getInstanceMethod(inClass, inOldSelector);
IMP theOldImplementation = method_getImplementation(theOldMethod);
BOOL theResult = class_addMethod(inClass, inNewSelector, theOldImplementation, method_getTypeEncoding(theOldMethod));
NSLog(@"RESULT: %d", theResult);
}

@implementation NSOperation (NSOperation_HackExtensions)

+ (void)load
{
NSLog(@"LOAD");

AliasMethod([NSOperation class], @selector(completionBlock), @selector(hackyCompletionBlock));
AliasMethod([NSOperation class], @selector(setCompletionBlock:), @selector(setHackyCompletionBlock:));



}

- (void (^)(void))hackyCompletionBlock
{
return(NULL);
}

- (void)setHackyCompletionBlock:(void (^)(void))block
{
NSLog(@"FUCK");
}

@end
