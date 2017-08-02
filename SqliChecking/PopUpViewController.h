//
//  PopUpViewController.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 31/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DBManager.h"

@interface PopUpViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *popUpView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (IBAction)closePopup:(id)sender;

@end
