//
//  SecondViewController.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "SecondViewController.h"
#import <Photos/Photos.h>
#import <CoreData/CoreData.h>
#import "User+CoreDataClass.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editPhotoClicked:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined) {
        // Request photo authorization
       
    } else if (status == PHAuthorizationStatusAuthorized) {
        NSLog(@"authorized");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                         init];
            pickerController.delegate = self;
            pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:pickerController animated:YES completion:nil];
        }];

    } else if (status == PHAuthorizationStatusRestricted) {
        NSLog(@"restricted");
    } else if (status == PHAuthorizationStatusDenied) {
        NSLog(@"denied");
    }

}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)CancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)saveButtonClicked:(id)sender {
   AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext* context = appDelegate.persistentContainer.viewContext;
    
   User *user = [[User alloc] initWithContext:context];
    user.firstName = _firstName.text;
    user.secondName = _secondName.text;
    user.function = _function.text;
    user.email = _email.text;
    user.tel = _tel.text;
    
    [appDelegate saveContext];
    NSLog(@"saved!!!");
    

}

@end
