//
//  CRunLoopHelper.m
//  CLI Sample
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CRunLoopHelper.h"

@implementation CRunLoopHelper

@synthesize flag;
@synthesize runLoop;
@synthesize thread;

- (void)setFlag:(BOOL)inFlag
{
//NSLog(@"SET FLAG: %d", inFlag);
flag = inFlag;
}

- (void)prepare
{
self.flag = YES;
self.runLoop = [NSRunLoop currentRunLoop];
self.thread = [NSThread currentThread];
}

- (void)run
{
while (self.flag)
	{
//	NSLog(@"LOOP: %@", [NSThread currentThread]);
	[self.runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10.0]];
	}
}

- (void)stop
{
//NSLog(@"STOP: %@", [NSThread currentThread]);
if (self.thread != [NSThread currentThread])
	{
	[self performSelector:@selector(stop) onThread:self.thread withObject:NULL waitUntilDone:YES modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
	return;
	}
	
[self.runLoop performSelector:@selector(resetFlag) target:self argument:NULL order:0 modes:[NSArray arrayWithObject:NSDefaultRunLoopMode]];
}

- (void)resetFlag
{
self.flag = NO;
}

@end
