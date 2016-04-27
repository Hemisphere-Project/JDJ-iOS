//
//  AppDelegate.m
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigConst.h"


@interface AppDelegate () 
@end

@implementation AppDelegate

@synthesize window;
@synthesize disPlay;
@synthesize comPort;
@synthesize runMachine;
@synthesize checkMachine;
@synthesize filesManager;
@synthesize moviePlayer;
@synthesize webPlayer;
@synthesize textPlayer;
@synthesize mainController;

//###########################################################
//STARTUP

//APPLICATION START
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //OBJECTS
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //COMMUNICATION
    comPort = [[ComClass alloc] init];
    
    //RUN MACHINE (Clock & Dispatch Orders)
    runMachine = [[RunClass alloc] init];
    
    //RUN MACHINE (Clock & Check states)
    checkMachine = [[CheckerClass alloc] init];
    
    //FILES MANAGER
    filesManager = [[FilesClass alloc] init];
    
    //MOVIE PLAYER
    moviePlayer = [[MovieClass alloc] init];
    
    //MOVIE PLAYER
    webPlayer = [[WebClass alloc] init];
    
    //MOVIE PLAYER
    textPlayer = [[TextClass alloc] init];
    
    //DISPLAY
    disPlay = [[DisplayClass alloc] init];
    
    //APP START
    [runMachine start];
    [checkMachine start];
    
    //VIEW CONTROLLER
    mainController = (ViewController*) self.window.rootViewController;
    
    //end of startup
    return YES;
}

-(void) showSettings {
    [mainController.SettingsBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [moviePlayer pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [moviePlayer resume];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
