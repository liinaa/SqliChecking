//
//  SecondViewController.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "SecondViewController.h"
#import <Photos/Photos.h>
#import "PopUpViewController.h"
#import "DBManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SecondViewController ()
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSString *imgData;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    valide = true;
    // Make self the delegate of the textfields.
    self.firstName.delegate = self;
    self.secondName.delegate = self;
    self.function.delegate = self;
    self.email.delegate = self;
    self.tel.delegate = self;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"preDB.sql"];
     [self loadData];
    
    if([self searchUser]){
        
        NSArray *arr = [self.userInfo objectAtIndex:0];
        
        self.firstName.text = [arr objectAtIndex:1];
        self.secondName.text = [arr objectAtIndex:2];
        self.function.text = [arr objectAtIndex:3];
        self.email.text = [arr objectAtIndex:4];
        self.tel.text = [arr objectAtIndex:5];
        if([self userImage] == nil) {
             self.imageView.image = [UIImage imageNamed:@"profile.png"];
        }
        else {
             NSURL *url = [NSURL URLWithString:[self userImage]];
            [self imagePicked:url];
        }
         self.firstName.userInteractionEnabled = NO;
         self.secondName.userInteractionEnabled = NO;
         self.function.userInteractionEnabled = NO;
         self.email.userInteractionEnabled = NO;
         self.tel.userInteractionEnabled = NO;
  
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[self view] endEditing:TRUE];
    
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    if(_photo == nil){
        _photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
    else     _photo = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.imageView.image = _photo;
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera){
            // save the image to camera roll
            [self saveImageCam];
            NSLog(@"photo taken by camera saved");
    }
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    self.imgData = [imageURL absoluteString];
        [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)editPhotoClicked:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined) {
        // Request photo authorization
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
            UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                         init];
            pickerController.delegate = self;
            pickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
                [self presentViewController:pickerController animated:YES completion:nil];}
            else {
                NSLog(@"denied");
            }
        }];

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

- (IBAction)firstNameEdit:(id)sender {
    self.firstName.userInteractionEnabled = YES;
    [self.firstName becomeFirstResponder];
}

- (IBAction)lastNameEdit:(id)sender {
    self.secondName.userInteractionEnabled = YES;
    [self.secondName becomeFirstResponder];
}

- (IBAction)functionEdit:(id)sender {
    self.function.userInteractionEnabled = YES;
    [self.function becomeFirstResponder];
}

- (IBAction)emailEdit:(id)sender {
    self.email.userInteractionEnabled = YES;
    [self.email becomeFirstResponder];
}

- (IBAction)telEdit:(id)sender {
    self.tel.userInteractionEnabled = YES;
    [self.tel becomeFirstResponder];
}

- (IBAction)saveButtonClicked:(id)sender {
    valide = true;
    [self validation];
    if([self validation])
    {
    // Prepare the query string.
        NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *query;
        if(![self searchUser]){
            query = [NSString stringWithFormat:@"insert into user values(\"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\")", uniqueIdentifier, self.firstName.text, self.secondName.text,self.function.text,self.email.text,self.tel.text,self.imgData];
            NSLog(@"%@",self.imgData);
        }
        else {
            query = [NSString stringWithFormat:@"update user set firstName = \"%@\",lastName = \"%@\",function = \"%@\", email = \"%@\", tel = \"%@\", photo = \"%@\" where IDUser = \"%@\" ", self.firstName.text, self.secondName.text,self.function.text,self.email.text,self.tel.text,self.imgData,uniqueIdentifier];
            NSLog(@"%@",self.imgData);
        }

    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [self performSegueWithIdentifier:@"popCall" sender:nil];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
       }

}

- (IBAction)CancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) valideEmail:(UITextField*)email{
    NSString *regx = @"^[A-Z0-9a-z._%+-]+@[A-Za-z._-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    if ([emailPredicate evaluateWithObject:self.email.text] == YES)
    {
        return true;
    }
    else
    {
        NSLog(@"email not in proper format");
        return false;
    }
}

- (BOOL) valideTel:(UITextField*)tel{
    NSString *temp = [self.tel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *regx = @"^((\\+)|(00)|0)[0-9]{6,14}$";
    NSPredicate *telPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regx];
    if ([telPredicate evaluateWithObject:temp] == YES)
    {
        return true;
    }
    else
    {
        NSLog(@"tel not in proper format");
        return false;
    }

}

- (BOOL) validation{
    if( [self.firstName.text isEqualToString:@""]){
        self.firstNameError.text = @"Please enter your first name";
       valide = false;
    }
    if( [self.secondName.text isEqualToString:@""] ){
        self.lastNameError.text = @"Please enter your last name";
        valide = false;
    }
    if ([self.function.text isEqualToString:@""] ){
        self.functionError.text = @"Please enter your function";
        valide = false;
    }
    if ([self.email.text isEqualToString:@""] ){
        self.emailError.text = @"Please enter your email";
        valide = false;
    }
    if (![self valideEmail:self.email]){
        self.emailError.text = @"Please enter a valid email";
        valide = false;
    }
    if ([self.tel.text isEqualToString:@""]){
        self.telError.text = @"Please enter your phone number";
        valide = false;
    }
    if (![self valideTel:self.tel]){
        self.telError.text = @"Please enter a valid phone number";
        valide = false;
    }
    return valide;
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from user ;";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"Load of data");
    for( NSString * qu in _arrPeopleInfo)
        NSLog(@"%@",qu);
}


- (BOOL) searchUser{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *query = [[@"select * from user where IDUser ='" stringByAppendingString:uniqueIdentifier] stringByAppendingString:@"' "];
    self.userInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if([self.userInfo count] != 0){
        return true;
    }
    else return false;
}

- (IBAction)cameraClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}

- (NSString*) userImage{
      NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
     NSString *query = [[@"select photo from user where IDUser ='" stringByAppendingString:uniqueIdentifier] stringByAppendingString:@"' "];
    NSArray *tab = [self.dbManager loadDataFromDB:query];
        if(tab == nil || ![tab count]){
            return nil;
        }
        else{
            return [[tab objectAtIndex:0] objectAtIndex:0];
        }
}

- (void) saveImageCam{
    NSData* imageData = UIImageJPEGRepresentation(self.imageView.image,0.6);
    UIImage* compressedImage = [UIImage imageWithData:imageData];
   UIImageWriteToSavedPhotosAlbum(compressedImage, self, nil, nil);
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    float newVerticalPosition = -keyboardSize.height+80;
    
    [self moveFrameToVerticalPosition:newVerticalPosition forDuration:0.3f];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveFrameToVerticalPosition:0.0f forDuration:0.3f];
}


- (void)moveFrameToVerticalPosition:(float)position forDuration:(float)duration {
    CGRect frame = self.view.frame;
    frame.origin.y = position;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = frame;
    }];
}

-(void)imagePicked:(NSURL*)url {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:url resultBlock:^(ALAsset *asset)
     {
         UIImage  *copyOfOriginalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage] scale:0.5 orientation:UIImageOrientationUp];
         
         self.imageView.image = copyOfOriginalImage;
         self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2;
         self.imageView.clipsToBounds = YES;
     }
            failureBlock:^(NSError *error)
     {
         // error handling
         NSLog(@"failure-----");
     }];

}




@end
