//
//  AppDelegate.m
//  BackpropagationNeuralNet
//
//  Created by jay on 2/11/13.
//  Copyright (c) 2013 Jurgen Schwietering. All rights reserved.
//

#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "IIWrapController.h"

#import "ViewController.h"
#import "MainNavigationViewController.h"
#import "MainMenuViewController.h"

@interface AppDelegate()
{
    ViewController *mainViewController;
    UIViewController *selectorController;
}
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    mainViewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    selectorController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    
    IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:mainViewController
                                                                                   leftViewController:selectorController];
    deckController.automaticallyUpdateTabBarItems = YES;
    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
    deckController.rightSize = [UIScreen mainScreen].bounds.size.width;
    deckController.maxSize = [UIScreen mainScreen].bounds.size.width;
    deckController.openSlideAnimationDuration = 0.25f;
    deckController.closeSlideAnimationDuration = 0.5f;
    
    MainNavigationViewController * navigationController = [[MainNavigationViewController alloc] initWithRootViewController:deckController];
    IIWrapController*wrapController = [[IIWrapController alloc] initWithViewController:navigationController];
    self.window.rootViewController = wrapController;
    
    self.window.backgroundColor = [UIColor darkGrayColor];
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


- (UIViewController*)controllerForIndex:(int)index {
    switch (index) {
        case 0:
            return mainViewController;
        case 1:
            return mainViewController;
        case 2:
            return mainViewController;
        case 3:
            return mainViewController;
        case 4:
            return mainViewController;
        default:
            NSAssert(0,@"Index of controllers out of range");
            break;
    }
    return nil;
}

@end
