//
//  CCouchDBURLOperation.h
//  CouchTest
//
//  Created by Jonathan Wight on 04/14/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CURLOperation.h"

@interface CCouchDBURLOperation : CURLOperation {
	id JSON;
}

@property (readwrite, nonatomic, retain)	id JSON;

@end
