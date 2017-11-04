//
//  AppDelegate.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
//BeaconTag
@property (strong, nonatomic) NSDictionary *launchOptions;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, strong) CLBeaconRegion *region;

+ (AppDelegate *)sharedAppDelegate;
- (BOOL) getAutoAlert;
- (void) setAutoAlert:(BOOL) bAutoAlert;
- (BOOL) getStarted;
- (void) stopOBLE;
- (void) startOBLE;
- (BOOL) verifyStartOBLE;


@end

