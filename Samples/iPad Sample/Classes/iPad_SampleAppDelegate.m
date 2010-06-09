//
//  iPad_SampleAppDelegate.m
//  iPad Sample
//
//  Created by Jonathan Wight on 04/21/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import "iPad_SampleAppDelegate.h"

#import "CCouchDBServer.h"

@implementation iPad_SampleAppDelegate

@synthesize window;
@synthesize tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
CCouchDBServer *theServer = [[[CCouchDBServer alloc] init] autorelease];
[theServer fetchDatabasesWithSuccessHandler:NULL failureHandler:NULL];
	
	
    return YES;
}


/*
 // Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
 */

/*
 // Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
 */


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

