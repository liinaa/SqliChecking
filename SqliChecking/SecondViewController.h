//
//  SecondViewController.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SecondViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *secondName;
@property (strong, nonatomic) IBOutlet UITextField *function;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)CancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)editPhotoClicked:(id)sender;

@end
