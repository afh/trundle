//
//  CRunLoopHelper.h
//  CLI Sample
//
//  Created by Jonathan Wight on 05/26/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CRunLoopHelper : NSObject {
	BOOL flag;
	NSRunLoop *runLoop;
	NSThread *thread;
}

@property (readwrite, nonatomic, assign) BOOL flag;
@property (readwrite, nonatomic, assign) NSRunLoop *runLoop;
@property (readwrite, nonatomic, assign) NSThread *thread;

- (void)prepare;
- (void)run;
- (void)stop;

@end
