//
//  SocialAppDelegate.m
//  SocialDemo
//
//  Created by Cygnus Infomedia on 11/18/14.
//  Copyright (c) 2014 cygnusinfomedia. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SocialAppDelegate.h"
#import "SocialViewController.h"

#import "AFLinkedInOAuth1Client.h"
#import "AFNetworkActivityIndicatorManager.h"


@implementation SocialAppDelegate


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //NSLog(@"%@",url);
    
    if ([ [url absoluteString] rangeOfString:@"com.facebook.sdk_client_state"].location == NSNotFound) {
        
       if ([ [url absoluteString] rangeOfString:@"twitter_access_tokens"].location == NSNotFound)
       {
           NSLog(@"LinkedIn Loop");
           NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification object:nil userInfo:[NSDictionary dictionaryWithObject:url forKey:kAFApplicationLaunchOptionsURLKey]];
           [[NSNotificationCenter defaultCenter] postNotification:notification];
       }
    
        else
        {
            NSLog(@"Twitter Loop");
            if ([[url scheme] isEqualToString:@"myapp"] == NO) return NO;
        
            NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
            NSString *token = d[@"oauth_token"];
            NSString *verifier = d[@"oauth_verifier"];
        
            SocialViewController *vc = (SocialViewController *)[[self window] rootViewController];
            [vc setOAuthToken:token oauthVerifier:verifier];
        }
        return YES;
    }
    else
    {
        NSLog(@"Facebook Loop");
        // attempt to extract a token from the url
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");}];
    }
}


- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //Facebook
    [FBLoginView class];
    [FBProfilePictureView class];
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
    
    // Logs 'install' and 'app activate' App Events.
    
    [FBAppEvents activateApp];
   
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
}

@end
