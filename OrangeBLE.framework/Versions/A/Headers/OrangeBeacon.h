@class DDFileLogger;
@class OBConfig;
@protocol OrangeBeaconDelegate;


#import <UIKit/UIKit.h>
#import "OBLEBeaconIdentifier.h"

#define OBVERSION @"2.0.7"

#define UUID_OBLE @"3D4F13B4-D1FD-4049-80E5-D3EDCC840B6C"

extern NSString *const OrangeBeaconAlertNotification;
extern NSString *const OrangeBeaconDelegateTriggered;
extern NSString *const OrangeBeaconNotificationSent;
extern NSString *const OrangeBeaconNotificationClicked;

extern NSString *const kLocalNotificationActionInfosKey;
extern NSString *const kLocalNotificationDirectionInfosKey;
extern NSString *const kLocalNotificationAlertTriggerKey;

/**
* # ORANGE BEACON LIBRARY
* OrangeBeacon class allows automatic tracking of iBeacon regions and reacts depending on server instructions.
*
* ## GET STARTED:
* The recommended way is to do the following stuff in -application:didFinishLaunchingWithOptions:.
*
* 1) Start by creating a OBConfig to initialize the OrangeBeacon library.
* OBConfig *config = [OBConfig configWithBaseUrl:@"YOUR_BASE_URL"
*                                          login:@"YOUR_LOGIN"
*                                       password:@"YOUR_PASSWORD"];
*
* 2) Start the OrangeBeacon library by giving it the configuration, the application and the options
* [OrangeBeacon startWithConfig:config
*                   application:application
*                       options:launchOptions];
*
* 3) Overrides the 3 AppDelegate methods and call the corresponding static methods from OrangeBeacon
* -application:performFetchWithCompletionHandler:
* -application:didReceiveLocalNotification:
* -application:didRegisterUserNotificationSettings: // ONLY for iOS 8
*
* For more details about custom properties, please check the OBConfig class documentation.
*
* ## Default Notification
* By default, OrangeBeacon embeds a system to notify the user about alerts.
* It will show a simple Notification + AlertView for each alert triggered.
*
* ### Manually handle the alert
* Set an OrangeBeaconDelegate to receive all the alerts.
* You can handle every alerts triggered and decide if you want to let the lib displaying the default notif + alert_view or not.
* Check the delegate for more details.
*
*/

@interface OrangeBeacon : NSObject

@property(nonatomic, assign) NSObject <OrangeBeaconDelegate> *delegate;


/**
* Start the OrangeBeacon lib from a given configuration.
* This method will set also the minimum_interval for background_fetching and handle automatically the notifications
* if the auto_alert mode is enabled.
*/
+ (void)startWithConfig:(OBConfig *)config
            application:(UIApplication *)application
                options:(NSDictionary *)options;

/**
* If you need the functionnalities provided by OrangeBeaconDelegate you can use this method to set it in one call.
*/
+ (void)startWithConfig:(OBConfig *)config
            application:(UIApplication *)application
                options:(NSDictionary *)options
               delegate:(NSObject <OrangeBeaconDelegate> *)delegate;

/**
* Force an update
*/
+ (void)update;

/**
* Stop the OrangeBeacon lib - you need to call startWithConfig: again to start the lib.
*/
+ (void)stop;

/**
* Access the singleton OrangeBeacon instance.
*/
+ (instancetype)sharedInstance;

/**
* This method should be called from the AppDelegate method -application:performFetchWithCompletionHandler:
*
* @param completion This block will be called after download is completed
* with result flag as a parameter. If your application uses BG-fetching by itself,
* you can pass a custom completion block, otherwise — just pass the block given to AppDelegate.
*/
+ (void)applicationPerformFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completion;

/**
 *	stop all the monitored Orange Beacon
 */
+(void) stopMonitoredBeacon;

/**
*	Return True if there is at least one monitored Orange Beacon by the CoreLocation Manager
 */
+(BOOL) isAlreadyMonitoredBeacon;

/**
 *	Return True if the OrangeBeacon lib is started
 */
+(BOOL) isStarted;


///------------------------------------------------------------------------------------------------
/// @name Auto Alert Notifications
///------------------------------------------------------------------------------------------------

/**
* /!\ You need to call this method only if you use the auto_alert
* This method should be called from AppDelegate method -application:didReceiveLocalNotification:
*/
+ (void)applicationDidReceiveLocalNotification:(UILocalNotification *)notification;

#ifdef __IPHONE_8_0

/**
* /!\ You need to call this method only if you use the auto_alert
* This method should be called from the AppDelegate -application:didRegisterUserNotificationSettings:
* method of AppDelegate.
*/
+ (void)applicationDidRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings;

#endif


///------------------------------------------------------------------------------------------------
/// @name Advanced configuration
///-------------------------------------------------------------------------------------------------

/**
* This method is for advanced usage. We advice to use startWithConfig:application:options.
* - This method won't call setMinimumBackgroundFetchInterval: for background fetching
* - You have to manually call handleNotificationWithOptions: in application:didFinishLaunchingWithOptions:
*/
+ (void)startWithConfig:(OBConfig *)config;

/**
* Only needed if you use the auto_alert
*/
+ (void)handleNotificationWithOptions:(NSDictionary *)launchOptions;


///-------------------------------------------------------------------------------------------------
/// @name External event trigger
///-------------------------------------------------------------------------------------------------

/**
 * This method must be called when a notification has been displayed to the user.
 */
- (void)notificationDisplayed:(OBLEBeaconIdentifier *)beaconIdentifier direction:(NSString *)directionString action:(NSString *)action title:(NSString *)title;

/**
 * This method must be called when the user has clicked on ok on the notification.
 */
- (void)notificationClicked:(OBLEBeaconIdentifier *)beaconIdentifier direction:(NSString *)directionString action:(NSString *)action title:(NSString *)title url:(NSString *)url;

@end


///------------------------------------------------------------------------------------------------
/// @name OrangeBeacon Delegate
///-------------------------------------------------------------------------------------------------

@protocol OrangeBeaconDelegate <NSObject>
@optional

/**
* Called if the user refused to give us the authorization to use the Location system.
*/
- (void)orangeBeaconLocationAuthorizationRefused;

/**
* Called when an alert is triggered by the OrangeBeacon lib.
* Returns YES if you want to let displaying the default notification, returns NO if not.
*/
- (BOOL)orangeBeaconAlertTriggeredWithTitle:(NSString *)title
                                     action:(NSString *)action
								  direction:(NSString *)direction
								 beacon:(OBLEBeaconIdentifier *)beacon;

@end
