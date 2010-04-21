//
//  FootstoolAppDelegate.h
//  Footstool
//
//  Created by Jonathan Wight on 04/19/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CouchDBClientTypes.h"

@class CCouchDBServer;

@interface FootstoolAppDelegate : NSObject <NSApplicationDelegate> {
}

@property (readwrite, assign) IBOutlet NSWindow *window;
@property (readwrite, assign) IBOutlet NSArrayController *databasesController;
@property (readwrite, assign) IBOutlet NSArrayController *documentsController;
@property (readwrite, retain) NSURL *serverURL;
@property (readwrite, retain) CCouchDBServer *server;
@property (readwrite, retain) NSArray *databases;
@property (readwrite, retain) NSArray *documents;
@property (readwrite, copy) NSString *status;

- (CouchDBFailureHandler)errorHandler;

- (void)appendStatus:(NSString *)inStatus;
- (void)appendStatusFormat:(NSString *)inFormat, ...;

- (IBAction)addDatabase:(id)inSender;
- (IBAction)removeDatabase:(id)inSender;

- (IBAction)addDocument:(id)inSender;
- (IBAction)removeDocument:(id)inSender;

@end
