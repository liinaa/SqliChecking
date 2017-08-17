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

@property (weak, nonatomic) IBOutlet UISegmentedControl *controlAutoAlert;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (NSDate*) getPreviousMonday:(NSDate*)dateX;
- (IBAction)stopOBLE:(id)sender;
- (IBAction)startOBLE:(id)sender;
- (void) verifyStartOBLE;
- (IBAction)handleAutoAlerte:(id)sender;
- (NSArray*) userWorkTime:(NSString*)start until:(NSString*)end;
- (NSNumber*) timeToSeconds:(NSString*)string;
- (NSString*) secondsToTime:(NSString*)string;

@end

