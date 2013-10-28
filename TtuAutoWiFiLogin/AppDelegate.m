//
//  AppDelegate.m
//  PccuAutoWiFiLogin
//
//  Created by FrankWu on 13/3/4.
//  Copyright (c) 2013年 FrankWu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // Handle url request.
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL Request" message:[url absoluteString] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    //RFC 1808
    //<scheme>://<net_loc>/<path>;<params>?<query>#<fragment>
    //pcculogin://set?account=&password=&type=
    NSLog(@"URL: %@", [url absoluteString]);
    NSLog(@"Scheme: %@", [url scheme]);
    NSLog(@"Host: %@", [url host]);
    NSLog(@"Port: %@", [url port]);
    NSLog(@"Path: %@", [url path]);
    NSLog(@"Relative path: %@", [url relativePath]);
    NSLog(@"Path components as array: %@", [url pathComponents]);
    NSLog(@"Parameter string: %@", [url parameterString]);
    NSLog(@"Query: %@", [url query]);
    NSLog(@"Fragment: %@", [url fragment]);
    NSString *theQuery = [url query];
    if ([[url scheme] isEqualToString:@"pcculogin"]) {
        if ([[url host] isEqualToString:@"set"]) {
            NSString *rule1 = @"account=";
            NSString *rule2 = @"&password=";
            NSString *rule3 = @"&type=";
            NSRange rang1 = [theQuery rangeOfString:rule1];
            NSRange rang2 = [theQuery rangeOfString:rule2];
            NSRange rang3 = [theQuery rangeOfString:rule3];
            if (rang1.length == 0 || rang2.length == 0 || rang3.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"格式錯誤" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [theQuery componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            NSString *theAccount = [params objectForKey:@"account"];
            NSString *thePassword = [params objectForKey:@"password"];
            NSString *theTypeString = [params objectForKey:@"type"];
            NSInteger theType = [[params objectForKey:@"type"] intValue];
            if (theAccount.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"account參數缺少" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            else if (thePassword.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"password參數缺少" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            else if (theTypeString.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"Type參數缺少" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            else if (theType > 40 || theType < 37) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"Type參數錯誤" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            ViewController *viewController = (ViewController *)self.window.rootViewController;
            [viewController setAccount:theAccount andPassword:thePassword];
        }
        if ([[url host] isEqualToString:@"getUser"]) {
            NSString *rule1 = @"appID=";
            NSRange rang1 = [theQuery rangeOfString:rule1];
            
            if (rang1.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"格式錯誤" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            for (NSString *param in [theQuery componentsSeparatedByString:@"&"]) {
                NSArray *elts = [param componentsSeparatedByString:@"="];
                if([elts count] < 2) continue;
                [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
            }
            NSString *appID = [params objectForKey:@"appID"];
            
            if (appID.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"appID參數缺少" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
                [alert show];
                return NO;
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤" message:@"無此呼叫" delegate:nil cancelButtonTitle:@"確認" otherButtonTitles:nil];
            [alert show];
            return NO;
        }
    }
    else return NO;
    return YES;
}

@end
