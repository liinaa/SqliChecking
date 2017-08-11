//
//  AppDelegate.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "AppDelegate.h"
#import <OrangeBLE/OBConfig.h>
#import <objc/runtime.h>

@interface UIAlertView (Private)
@property (nonatomic, strong) id context;
@end

@implementation UIAlertView (Private)
@dynamic context;
-(void)setContext:(id)context {
    objc_setAssociatedObject(self, @selector(context), context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)context {
    return objc_getAssociatedObject(self, @selector(context));
}
@end

@interface AppDelegate ()

@end

#define UUID_BIDON			@"3D4F13B4-D1FD-4049-80E5-D3EDCC840B6C"

static BOOL autoAlert		= NO;				//	Alertes Customisés --> NO
static BOOL askPermission	= NO;				//	On ne veut pas que le sdk demande les permissions --> NO
static BOOL bStarted		= YES;				//	Demarrage automatique du SDK -> YES

@implementation AppDelegate

+ (AppDelegate *)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _launchOptions					= launchOptions;
    
    // Si le SDK ne doit pas demander les permissions.
    if ( !askPermission ) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    //	Demarrage ou non de la lib OBLE ( si le location Manager ecoutait deja les Orange Beacon )
    if ( [OrangeBeacon isAlreadyMonitoredBeacon] ) {
        [self startOBLE];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// System gives us a chance to update data from server in background.
- (void)              application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [OrangeBeacon applicationPerformFetchWithCompletionHandler:completionHandler];
}

- (void)        application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ( [UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //	Reçoit l'action de la notif clické en background
        NSLog(@"didReceiveLocalNotification() Background _ notification.userInfo : %@", notification.userInfo );
        
        NSString *action					= [notification.userInfo valueForKey:kLocalNotificationActionInfosKey];
        NSString *direction					= [notification.userInfo valueForKey:kLocalNotificationDirectionInfosKey];
        BOOL bAction						= ( action != nil && action.length > 0 );
        NSURL *url							= [NSURL URLWithString:action];
        NSString *urlString					= ( bAction ? url.absoluteString : nil );
        
        if (bAction) {
            NSURL *url = [NSURL URLWithString:action];
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            NSLog(@"didReceiveLocalNotification() No action !" );
        }
        
        //	Send click stat for SDK OBLE
        NSString *fullIdBeacon				= [notification.userInfo valueForKey:kLocalNotificationAlertTriggerKey];
        if ( fullIdBeacon != nil && fullIdBeacon.length > 0 ) {
            OBLEBeaconIdentifier *beaconIdentifier	= [[OBLEBeaconIdentifier alloc] initWithFullId:fullIdBeacon];
            [[OrangeBeacon sharedInstance] notificationClicked:beaconIdentifier direction:direction action:action title:notification.alertBody url:urlString];
        }
    }
    else if (autoAlert) {
        [OrangeBeacon applicationDidReceiveLocalNotification:notification];
    }
}

#ifdef __IPHONE_8_0

- (void) application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"didRegisterUserNotificationSettings");
}

#endif



#pragma mark - OrangeBeacon delegate

- (void) orangeBeaconLocationAuthorizationRefused
{
    NSLog(@"OrangeBeaconLocationAuthorizationRefused");
}

- (BOOL) orangeBeaconAlertTriggeredWithTitle:(NSString *)title
                                      action:(NSString *)action
                                   direction:(NSString *)direction
                                      beacon:(OBLEBeaconIdentifier *)beacon
{
    NSLog(@"orangeBeaconAlertTriggeredWithTitle:%@ action:%@ direction:%@", title, action, direction);
    
    if ( !autoAlert ) {
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
            NSLog(@"orangeBeaconAlertTriggeredWithTitle() not UIApplicationStateActive !" );
            UILocalNotification *notification	= [[UILocalNotification alloc] init];
            notification.userInfo				= @{kLocalNotificationAlertTriggerKey : [beacon fullId],
                                                    kLocalNotificationDirectionInfosKey : direction,
                                                    kLocalNotificationActionInfosKey : action};
            notification.alertBody				= [NSString stringWithFormat:@"Custom Notification\n%@",title];
            
            [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        }
        else {
            NSLog(@"orangeBeaconAlertTriggeredWithTitle() UIApplicationStateActive !" );
            NSString *titleAlert				= @"Custom alert";
            NSString *message					= [NSString stringWithFormat:@"%@|%@|%@", title, action, direction];
            BOOL bAction						= ( action != nil && action.length > 0 );
            NSURL *url							= [NSURL URLWithString:action];
            NSString *urlString					= @"";												//( bAction ? url.absoluteString : nil );
            if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
                UIAlertController* alert			= [UIAlertController alertControllerWithTitle:titleAlert
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:( bAction ) ? @"Cancel" : @"OK"
                                                                        style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * uiAction) {
                                                                          if (!bAction) {
                                                                              //	Send click stat for SDK OBLE
                                                                              [[OrangeBeacon sharedInstance] notificationClicked:beacon direction:direction action:action title:title url:urlString];
                                                                          }
                                                                      }];
                
                UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * uiAction) {
                                                                     NSLog(@"UIAlertAction() action = %@", action );
                                                                     [[UIApplication sharedApplication] openURL:url];
                                                                     
                                                                     //	Send click stat for SDK OBLE
                                                                     [[OrangeBeacon sharedInstance] notificationClicked:beacon direction:direction action:action title:title url:urlString];
                                                                 }];
                
                [alert addAction:defaultAction];
                if ( bAction ) {
                    [alert addAction:okAction];
                }
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            else {
                UIAlertView *alert					= [[UIAlertView alloc] initWithTitle:titleAlert
                                                                    message:message
                                                                   delegate:self
                                                          cancelButtonTitle:( bAction ) ? @"Cancel" : nil
                                                          otherButtonTitles:@"OK", nil];
                alert.context						= @{
                                                        @"beacon":beacon,
                                                        @"direction":direction,
                                                        @"title":title,
                                                        @"action":action,
                                                        @"url":urlString
                                                        };
                
                [alert show];
            }
        }
        
        //	Send notif stat for SDK OBLE
        [[OrangeBeacon sharedInstance] notificationDisplayed:beacon direction:direction action:action title:title];
    }
    
    return autoAlert;
}


#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertView clickedButtonAtIndex()" );
    NSDictionary *context						= alertView.context;
    OBLEBeaconIdentifier *beaconIdentifier		= [context valueForKey:@"beacon"];
    NSString *action							= [context valueForKey:@"action"];
    NSString *direction							= [context valueForKey:@"direction"];
    NSString *title								= [context valueForKey:@"title"];
    NSString *urlString							= [context valueForKey:@"url"];
    
    if ( buttonIndex != alertView.cancelButtonIndex) {
        BOOL bAction							= ( action != nil && action.length > 0 );
        //	Send click stat for SDK OBLE
        [[OrangeBeacon sharedInstance] notificationClicked:beaconIdentifier direction:direction action:action title:title url:urlString];
        
        if ( bAction ) {
            NSLog(@"alertView clickedButtonAtIndex() action = %@", action );
            NSURL *url							= [NSURL URLWithString:action];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


#pragma mark - Location manager

- (void) locationManager:(__unused CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString *statusString;
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            statusString = @"NotDetermined";
            break;
        case kCLAuthorizationStatusRestricted:
            statusString = @"Restricted";
            break;
        case kCLAuthorizationStatusDenied:
            statusString = @"Denied";
            break;
#ifdef __IPHONE_8_0
        case kCLAuthorizationStatusAuthorizedAlways:
            statusString = @"Authorized always";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse :
            statusString = @"Authorized when in use";
            break;
#endif
        default:
            break;
    }
    NSLog(@"locationManager() New authorization status: %@", statusString);
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        if (status == kCLAuthorizationStatusNotDetermined &&
            [manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [manager requestAlwaysAuthorization];
            _locationManager.delegate = nil;
        }
    }
    else {
        // in iOS 7 -> status is NotDetermined even if the user authorized the app
        if (status == kCLAuthorizationStatusNotDetermined ) {
            //	demande de monitoring Bidon
            NSLog(@"locationManager() Demande de Monitoring UUID_BIDON = %@", UUID_BIDON);
            _region					= [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:UUID_BIDON] identifier:@"1"];
            [_locationManager startMonitoringForRegion:_region];
        }
    }
}

- (void)locationManager:(__unused CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"locationManager() Error from location manager: %@", error);
}

// This method is called right after the start of regions monitoring.
- (void)locationManager:(__unused CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLBeaconRegion *)region
{
    // only beacon
    if ( [region isKindOfClass:[CLBeaconRegion class]] ) {
        NSLog(@"locationManager() Stop monitoring region : %@", _region.proximityUUID.UUIDString );
        [_locationManager stopMonitoringForRegion:_region];
        _locationManager.delegate = nil;
        _locationManager = nil;
    }
}


#pragma mark - public methods

-(void) startOBLE {
    if ( !bStarted ) {
#ifdef __IPHONE_8_0
        //	Ask for accept notifications
        if ( [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
        }
#endif
        
        // identifiant d'accès API : login / passwd
        NSString *login					= @"NoGYYqMURSF6xQ2JzoX3fmokHtDpX0rG";
        NSString *passwd				= @"bSc0jJCn8nQXeRpf";
        
        OBConfig *config				= [OBConfig configWithLogin:login password:passwd];
        
        config.logLevel					= INT_MAX;					//	-> LOG_LEVEL_ALL
        config.minUpdateInterval		= INTERVAL_FIFTEEN_MINUTES;
        //		config.minUpdateInterval		= INTERVAL_NEVER;
        
        config.minActionRepeatInterval	= 5;						//	--> peut recevoir la meme notif apres 5 secondes
        config.notificationsWithSound	= YES;
        config.leaveBeaconAreaTimeframe	= 5;
        
        config.shouldSendStats			= YES;
        
        //	Demande les permissions de localisation (Popup) par le SDK ou non
        config.shouldAskPermission		= askPermission;
        
        [OrangeBeacon startWithConfig:config
                          application:[UIApplication sharedApplication]
                              options:_launchOptions
                             delegate:( autoAlert ? nil : self )];
        
        //force update --> non ou alors apres un certain temps (10 sec) apres le demarrage
        //[OrangeBeacon update];
        
        bStarted						= YES;
    }
}

- (void) stopOBLE {
    if ( bStarted ) {
        [OrangeBeacon stop];
        bStarted						= NO;
    }
}

- (void) setAutoAlert:(BOOL) bAutoAlert {
    autoAlert	= bAutoAlert;
    
    if ( [self verifyStartOBLE] ) {
        [self stopOBLE];
    }
    
    [self startOBLE];
}

- (BOOL) getAutoAlert {
    return autoAlert;
}

- (BOOL) getStarted {
    return bStarted;
}

//	Verifit si la lib OBLE est bien demarrée
- (BOOL) verifyStartOBLE {
    bStarted							= [OrangeBeacon isStarted];
    return bStarted;
}

@end

