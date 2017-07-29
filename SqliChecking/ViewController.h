//
//  ViewController.h
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITextViewDelegate>{
    NSDictionary* tab;
    NSArray* semaine;
    NSMutableDictionary* jours;
    NSMutableDictionary* dureeTotal;
    NSArray *jourSemaine;
}

@end

