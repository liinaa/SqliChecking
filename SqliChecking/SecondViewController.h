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
UIImagePickerControllerDelegate>{
    bool valide;
}

@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *secondName;
@property (strong, nonatomic) IBOutlet UITextField *function;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *tel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImage *photo;
@property (strong, nonatomic) IBOutlet UILabel *firstNameError;
@property (strong, nonatomic) IBOutlet UILabel *lastNameError;
@property (strong, nonatomic) IBOutlet UILabel *functionError;
@property (strong, nonatomic) IBOutlet UILabel *emailError;
@property (strong, nonatomic) IBOutlet UILabel *telError;
@property (nonatomic, strong) NSArray *arrPeopleInfo;
@property (nonatomic, strong) NSArray *userInfo;



- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)CancelButtonClicked:(id)sender;
- (IBAction)editPhotoClicked:(id)sender;
- (IBAction)firstNameEdit:(id)sender;
- (IBAction)lastNameEdit:(id)sender;
- (IBAction)functionEdit:(id)sender;
- (IBAction)emailEdit:(id)sender;
- (IBAction)telEdit:(id)sender;
- (BOOL) valideEmail:(UITextField*)email;
- (BOOL) valideTel:(UITextField*)tel;
- (BOOL) validation;
- (void) loadData;
- (BOOL) searchUser;
- (IBAction)cameraClicked:(id)sender;
- (NSString*) userImage;
- (void) saveImageCam;
-(void)imagePicked:(NSURL*)url;


@end
