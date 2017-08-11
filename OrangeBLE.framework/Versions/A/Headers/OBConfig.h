#import <Foundation/Foundation.h>

/**
* This is the predefined server update intervals
*/
static const NSTimeInterval INTERVAL_FIFTEEN_MINUTES = 15 * 60;
static const NSTimeInterval INTERVAL_THIRTY_MINUTES = 30 * 60;
static const NSTimeInterval INTERVAL_ONE_HOUR = 60 * 60;
static const NSTimeInterval INTERVAL_FIVE_HOURS = 5 * INTERVAL_ONE_HOUR;
static const NSTimeInterval INTERVAL_ONE_DAY = 24 * INTERVAL_ONE_HOUR;
static const NSTimeInterval INTERVAL_NEVER = 100 * 365 * INTERVAL_ONE_DAY;

//typedef NS_ENUM(NSInteger, UpdateIntervalTime) {
//    INTERVAL_FIFTEEN_MINUTES,
//    INTERVAL_THIRTY_MINUTES,
//    INTERVAL_ONE_HOUR,
//    INTERVAL_FIVE_HOURS,
//    INTERVAL_ONE_DAY,
//    INTERVAL_NEVER,
//};

@interface OBConfig : NSObject

/**
* Initialize a configuration for OrangeBeacon.
* It will create a simple configuration with all others properties set to their default values.
*/
+ (instancetype)configWithLogin:(NSString *)login
                       password:(NSString *)password;

/**
* Use this way to set another base_url
*/
+ (instancetype)configWithBaseUrl:(NSString *)baseUrl
                            login:(NSString *)login
                         password:(NSString *)password;

/**
* The base api URL that will be called to get post/get data.
*/
@property(readonly, copy, nonatomic) NSString *baseUrl;

/**
* Your login and password to be identified on the server.
*/
@property(readonly, copy, nonatomic) NSString *login;
@property(readonly, copy, nonatomic) NSString *password;

///------------------------------------------------------------------------------------------------
/// @name Custom properties
///------------------------------------------------------------------------------------------------

/**
* Used to identify stats from different applications.
* The expected format is 32 hex digits in lowercase, without separators.
* By default a random appId is generated while the library instance is initialized.
*/
@property(copy, nonatomic) NSString *appId;

/**
* Allow sending stats to server.
* Default is YES.
*/
@property(readwrite, nonatomic) BOOL shouldSendStats;

/**
 * Allow the ability for the SDK to ask permission for Localisation and Notification.
 * Default is YES.
 */
@property(readwrite, nonatomic) BOOL shouldAskPermission;

/**
* Interval (in seconds) in which the same user action will not be shown.
* Default value is 12 hours.
*/
@property(readwrite, nonatomic) NSTimeInterval minActionRepeatInterval;

/**
* Interval in which a new action can cancel previously scheduled action.
* Default value is 0 seconds (off).
*/
@property(readwrite, nonatomic) NSTimeInterval minUniqueActionTimeframe;

/**
* Interval in which the LEAVE event is simulated
* if we've got no signals from the corresponding beacon.
* Default value is 40 seconds.
*/
@property(readwrite, nonatomic) NSTimeInterval leaveBeaconAreaTimeframe;

/**
* Minimum interval between server updates. Available values are:
*
* INTERVAL_FIFTEEN_MINUTES,
* INTERVAL_THIRTY_MINUTES,
* INTERVAL_ONE_HOUR,
* INTERVAL_FIVE_HOURS,
* INTERVAL_ONE_DAY,
* INTERVAL_NEVER.
*
* Default is INTERVAL_ONE_HOUR.
*/
@property(readwrite, nonatomic) NSTimeInterval minUpdateInterval;

/**
 *	Contains the Beacons list (with actions) for the first initialisation ( if no network and then no cache ) !
 */
@property(readwrite, nonatomic)  NSString *initialListBeacons;

/**
* Play standard notification sound when action happens in background mode.
* Default value is YES.
*/
@property(readwrite, nonatomic) BOOL notificationsWithSound;

/**
* Clear notification center for the application when launched or opened from BG.
* Default value is YES.
*/
@property(readwrite, nonatomic) BOOL shouldResetNotificationsOnLaunch;

/**
* CocoaLumberjack log-level for the library logs.
* Set it to LOG_LEVEL_OFF, if you don't want to see any messages from the library.
* Default value is LOG_LEVEL_INFO.
*/
@property(nonatomic, assign) int logLevel;

- (BOOL)check;
@end