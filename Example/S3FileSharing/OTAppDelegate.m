//
//  OTAppDelegate.m
//  S3FileSharing
//
//  Created by Charley Robinson on 03/18/2016.
//  Copyright (c) 2016 Charley Robinson. All rights reserved.
//

#import "OTAppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AWSCore/AWSCore.h>

@implementation OTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    
    // Be sure to create a Config.plist (see Config.plist.sample)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config"
                                                     ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString* cognitoPoolID = [settings objectForKey:@"AWS_COGNITO_POOL_ID"];
    NSLog(@"Config.plist: Using Cognito Pool ID %@", cognitoPoolID);
    
    AWSCognitoCredentialsProvider *credentialsProvider =
    [[AWSCognitoCredentialsProvider alloc]
     initWithRegionType:AWSRegionUSEast1
     identityPoolId:cognitoPoolID];
    
    AWSServiceConfiguration *configuration =
    [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                credentialsProvider:credentialsProvider];
    
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration =
    configuration;
    
    // Retrieve your Amazon Cognito ID just for kicks.
    // You may see errors if configs are bad.
    [[credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask *task) {
        if (task.error) {
            NSLog(@"Cognito initialization error: %@", task.error);
        }
        else {
            NSString *cognitoId = task.result;
            NSLog(@"This device Cognito ID: %@", cognitoId);
        }
        return nil;
    }];

    // Override point for customization after application launch.
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
