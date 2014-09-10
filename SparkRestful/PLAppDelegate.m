//
//  PLAppDelegate.m
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLAppDelegate.h"
#import "PLViewController.h"
#import <GAI.h>
#import <Flurry.h>

@implementation PLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
   
    /*
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-53957877-1"];
 
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"VJHMX3C6HQ9C5VSMFHS4"];
    */
    
    PLViewController *viewController=[[PLViewController alloc] initWithNibName:@"PLViewController" bundle:nil];
     UINavigationController *navVC=[[UINavigationController alloc] initWithRootViewController:viewController];
    
    
    self.window.rootViewController=navVC;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.105 green:0.689 blue:0.998 alpha:1.000]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.990 green:0.995 blue:0.995 alpha:1.000]];
 
    
    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
