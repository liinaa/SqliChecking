//
//  ViewController.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITextViewDelegate>{
    NSMutableDictionary* tab;
    NSArray* semaine;
    NSMutableDictionary* jours;
    NSMutableDictionary* dureeTotal;
    NSMutableArray* lundis;
    int dureeAccum;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSArray *userInfo;


- (NSDate*) getPreviousMonday:(NSDate*)dateX;
- (void)stopOBLE;
- (void)startOBLE;
- (void) verifyStartOBLE;
- (NSArray*) userWorkTime:(NSString*)start until:(NSString*)end;
- (NSNumber*) timeToSeconds:(NSString*)string;
- (NSString*) secondsToTime:(NSString*)string;
- (void)imagePicked:(NSURL*)url;  // get Image from Asset URL
- (BOOL) searchUser;    // true if user exists in sqlite3 db 
- (NSString*) userImage;  //from sqlit3 db

@end

