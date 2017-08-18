//
//  OpeningViewController.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 18/08/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "OpeningViewController.h"
#import "ViewController.h"

@interface OpeningViewController ()

@end

@implementation OpeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

                         
                         [UIView animateWithDuration:2.0f
                                          animations:^{
                                              
                                              self.Checking.center = CGPointMake(self.Checking.center.x, self.Checking.center.y - 200.0f);
                                              
                                          } completion:^(BOOL finished) {
                                              
                                          }];
    [self performSelector:@selector(loadingNextView)
               withObject:nil afterDelay:6.0];
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

- (void)loadingNextView{
    
    [self performSegueWithIdentifier:@"entering" sender:nil];
}


@end
