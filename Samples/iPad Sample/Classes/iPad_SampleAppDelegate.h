//
//  iPad_SampleAppDelegate.h
//  iPad Sample
//
//  Created by Jonathan Wight on 04/21/10.
//  Copyright toxicsoftware.com 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPad_SampleAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
