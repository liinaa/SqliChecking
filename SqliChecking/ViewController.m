//
//  ViewController.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "ViewController.h"
#import <OrangeBLE/OrangeBeacon.h>
#import "AppDelegate.h"
#import "DBManager.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITableView *presenceTableView;
@property (strong, nonatomic) IBOutlet UIButton *profilButton;
@property (nonatomic, strong) DBManager *dbManager;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSDate *dateX;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    NSString *previousMonday = [formatter stringFromDate:[self getMondaysDate:dateX]];
    NSLog(@"previousMonday date ===> : %@",previousMonday);
    
    NSDate *d = [self getMondaysDate:dateX];
    self->lundis = [[NSMutableArray alloc]init];
    [self->lundis addObject:d];
    for (int i=1; i<4; i++){
        [self->lundis addObject:[self getMondaysDate:[self->lundis objectAtIndex:i-1]]];
    }
    for (NSDate* d in self->lundis) {
        NSLog(@"%@", [formatter stringFromDate:d]);
    }

    jourSemaine=@[@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday"];
    tab = @{ [@"Week of " stringByAppendingString:[formatter stringFromDate:[lundis objectAtIndex:0]] ] : @{@"Monday":@"7",@"Tuesday":@"8",@"Wednesday":@"7",@"Thursday":@"8"},
             [@"Week of " stringByAppendingString:[formatter stringFromDate:[lundis objectAtIndex:1]] ] : @{@"Monday":@"7",@"Tuesday":@"7",@"Wednesday":@"7",@"Thursday":@"7",@"Friday":@"7",@"Saturday":@"8",@"Sunday":@"7"},
             [@"Week of " stringByAppendingString:[formatter stringFromDate:[lundis objectAtIndex:2]] ] : @{@"Monday":@"7",@"Tuesday":@"8",@"Wednesday":@"7",@"Thursday":@"8",@"Friday":@"7",@"Saturday":@"8",@"Sunday":@"8"},
             [@"Week of " stringByAppendingString:[formatter stringFromDate:[lundis objectAtIndex:3]] ] : @{@"Monday":@"7",@"Tuesday":@"7",@"Wednesday":@"7",@"Thursday":@"7",@"Friday":@"7",@"Saturday":@"8",@"Sunday":@"7"}
             };

    semaine = [[tab allKeys] sortedArrayUsingComparator:^(NSString* s1, NSString* s2){
        NSArray *arr1 = [s1 componentsSeparatedByString:@"of"];
        NSArray *arr2 = [s2 componentsSeparatedByString:@"of"];
        if([[formatter dateFromString:[arr1 objectAtIndex:1]] compare:[formatter dateFromString:[arr2 objectAtIndex:1]]] == NSOrderedAscending){
            return NSOrderedDescending;
        }
        else return NSOrderedAscending;
    }];
    
    jours = [[NSMutableDictionary alloc]init];
    dureeTotal = [[NSMutableDictionary alloc]init];
    
    [tab enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [jours setValue:[[obj allKeys] sortedArrayUsingComparator: ^(NSString* j1, NSString* j2) {
            if( [jourSemaine indexOfObject:j1] < [jourSemaine indexOfObject:j2])
                return NSOrderedAscending;
            else return NSOrderedDescending;
        }] forKey:key];
        NSLog(@"%@",[jours objectForKey:key]);
        }];
   [tab enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
                __block NSNumber *temp = 0;
    
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    temp = @([temp integerValue]+ [obj integerValue]);
                    
                }];
       
        [dureeTotal setObject:temp forKey:key];
   }];
}

-(void)viewWillAppear:(BOOL)animated {
    _controlAutoAlert.selectedSegmentIndex	= [[AppDelegate sharedAppDelegate] getAutoAlert] ? 0 : 1;
    
    [self changeUI];
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [semaine count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   NSString *sectionTitle = [semaine objectAtIndex:section];
    return [[jours objectForKey:sectionTitle]count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionTitle = [semaine objectAtIndex:section];
    NSString *dt = [dureeTotal objectForKey:sectionTitle];
    return [[semaine objectAtIndex:section] stringByAppendingString:[NSString stringWithFormat:@"                 %@ h",dt]];
}

/*- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *sectionTitle = [semaine objectAtIndex:section];
    NSString *dt = [dureeTotal objectForKey:sectionTitle];
    NSString *result = [NSString stringWithFormat:@"Nombre d'heures total               %@",dt];
    return result;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *sectionTitle = [semaine objectAtIndex:indexPath.section];
    
    NSString *jourAffich = [[jours objectForKey:sectionTitle] objectAtIndex:indexPath.row];
    NSString *duree = [[tab objectForKey:sectionTitle] objectForKey:jourAffich];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd"];

    NSDate* vari = [[lundis objectAtIndex:indexPath.section] dateByAddingTimeInterval:24*60*60*indexPath.row];
    cell.textLabel.text = [[jourAffich stringByAppendingString:@" "] stringByAppendingString:[formatter stringFromDate:vari]];
    
    cell.detailTextLabel.text = duree;
    return cell;
}

- (NSDate*) getMondaysDate:(NSDate*)dateX{
    if(dateX == nil){
       dateX = [NSDate date];
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *previousMonday = [calendar nextDateAfterDate:dateX
                                            matchingUnit:NSCalendarUnitWeekday
                                                   value:2
                                                 options:NSCalendarMatchNextTime | NSCalendarSearchBackwards];
    return previousMonday;
}

- (IBAction)handleAutoAlerte:(id)sender {
    UISegmentedControl * segmentedControl	= (UISegmentedControl *)sender;
    BOOL bAutoAlerte						= (segmentedControl.selectedSegmentIndex == 0 ? YES : NO );
    NSLog(@"handleAutoAlerte() %@", ( bAutoAlerte ? @"YES" : @"NO") );
    
    [[AppDelegate sharedAppDelegate] setAutoAlert:bAutoAlerte];
    [self changeUI];
}

- (IBAction)stopOBLE:(id)sender
{
    [[AppDelegate sharedAppDelegate] stopOBLE];
    [self changeUI];
}

- (IBAction)startOBLE:(id)sender
{
    [[AppDelegate sharedAppDelegate] startOBLE];
    [self changeUI];
}

//	Change la visualisation de l'interface
- (void) changeUI {
    
    BOOL bStarted							= [[AppDelegate sharedAppDelegate] getStarted];
    [_startBtn setHidden:bStarted];
    [_stopBtn setHidden:!bStarted];
    
    if (bStarted) {
        NSTimeInterval interval = 5;
        [self performSelector:@selector(verifyStartOBLE) withObject:nil afterDelay:interval];
    }
    else {
      
    }
}

//	Si la lib OBLE est bien demarrée, rien a faire.
- (void) verifyStartOBLE {
    //	Si pas bien demarrée : retourne a l'etat Stop
    if ( ![[AppDelegate sharedAppDelegate] verifyStartOBLE]) {
        [self changeUI];
    }
}

/*- (NSString*) userWorkTime{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *query = [[@"select hours from workTime where userID ='" stringByAppendingString:uniqueIdentifier] stringByAppendingString:@"' AND date = '07 août 2017' "];
    NSArray *tab = [self.dbManager loadDataFromDB:query];
    if(tab == nil || ![tab count]){
        return nil;
    }
    else{
        NSLog(@"jfkshfjhsk %@",[[tab objectAtIndex:0] objectAtIndex:0]);
        return [[tab objectAtIndex:0] objectAtIndex:0];
    }
    
    
}*/


@end
