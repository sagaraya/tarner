//
//  TarnerAppDelegate.m
//  Tarner
//
//  Created by Keisei SHIGETA on 2013/05/11.
//  Copyright (c) 2013年 Keisei SHIGETA. All rights reserved.
//

#import <Parse/Parse.h>

#import "TarnerAppDelegate.h"
#import "TarnerTimelineViewController.h"
#import "TarnerMyPageViewController.h"
#import "TarnerPostViewController.h"
#import "TarnerUser.h"

@implementation TarnerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // parse settings
    [Parse setApplicationId:@"cLymJn8EaOnTYmOCUlZ4sd49Np5aflU3qtjANMU6"
                  clientKey:@"HqnC0QAPE6U1BgRSDfRAEdfM5KUnzgZ8eIXqfxaa"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // user auth
    [[TarnerUser shared] loadOrCreateUser];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[TarnerTimelineViewController alloc] initWithNibName:@"TarnerTimelineViewController" bundle:nil];
    UIViewController *viewController2 = [[TarnerMyPageViewController alloc] initWithNibName:@"TarnerMyPageViewController" bundle:nil];
    UIViewController *tarnerPostVC = [[TarnerPostViewController alloc] initWithNibName:@"TarnerPostViewController" bundle:nil];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[viewController1, viewController2, tarnerPostVC];
    self.window.rootViewController = self.tabBarController;
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
