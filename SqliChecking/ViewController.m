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
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"preDB.sql"];
    NSDate *dateX;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:usLocale];
    
    NSDate *d = [self getPreviousMonday:dateX];
    self->lundis = [[NSMutableArray alloc]init];
    [self->lundis addObject:d];
    for (int i=1; i<4; i++){
        [self->lundis addObject:[self getPreviousMonday:[self->lundis objectAtIndex:i-1]]];
    }
    for (NSDate* d in self->lundis) {
        NSLog(@"%@", [formatter stringFromDate:d]);
    }
    
    NSMutableArray *arrOfDict = [[NSMutableArray alloc]init] ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0;i<lundis.count;i++) {
        NSString *d1 = [dateFormatter stringFromDate:[lundis objectAtIndex:i]];
        NSDate *d2;
        if(i!=0)
        d2 = [lundis objectAtIndex:i-1];
        else  d2 = [NSDate date];
        BOOL temp = true;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init] ;
        for (NSArray* sarr in [self userWorkTime:d1 until:[dateFormatter stringFromDate:[d2 dateByAddingTimeInterval:-24*60*60]]]) {
            [dict setObject:[sarr objectAtIndex:1] forKey:[sarr objectAtIndex:0]];
            temp = false;
        }
        if(!temp)
            [arrOfDict addObject:dict];
    }
    
    NSMutableDictionary* tab1 = [[NSMutableDictionary alloc]init];
    for(int j=0;j<arrOfDict.count;j++){
        [tab1 setObject:[arrOfDict objectAtIndex:j] forKey:[formatter stringFromDate:[lundis objectAtIndex:j]]];
    }
    NSLog(@"%@",tab1);
    tab = tab1;
    
    semaine = [[tab allKeys] sortedArrayUsingComparator:^(NSString* s1, NSString* s2){
        if([[formatter dateFromString:s1] compare:[formatter dateFromString:s2]] == NSOrderedAscending){
            return NSOrderedDescending;
        }
        else return NSOrderedAscending;
    }];
    jours = [[NSMutableDictionary alloc]init];
    dureeTotal = [[NSMutableDictionary alloc]init];
    
    [tab enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       [jours setValue:[[obj allKeys] sortedArrayUsingComparator: ^(NSDate* j1, NSDate* j2) {
            if( [j1 compare:j2] == NSOrderedAscending)
                return NSOrderedDescending;
            else return NSOrderedAscending;
        }] forKey:key];
        }];
    
     __block NSString *resultDureeTotal;
    
   [tab enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       dureeAccum = 0;
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull subKey, id  _Nonnull subObj, BOOL * _Nonnull stop) {
                    dureeAccum = [[self timeToSeconds:subObj] intValue] + dureeAccum;
                    resultDureeTotal = [self secondsToTime:[@(dureeAccum) stringValue]] ;
                }];
        [dureeTotal setObject:resultDureeTotal forKey:key];
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
    NSArray *hourMinute = [dt componentsSeparatedByString:@":"];
    return [[semaine objectAtIndex:section] stringByAppendingString:[NSString stringWithFormat:@"              %@h %@min",[hourMinute objectAtIndex:0],[hourMinute objectAtIndex:1]]];
}

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
    
    NSDateFormatter *dureeFormatter = [[NSDateFormatter alloc] init];
    [dureeFormatter setDateFormat:@"HH:mm"];
    NSDateFormatter *dureeFormatter1 = [[NSDateFormatter alloc] init];
    [dureeFormatter1 setDateFormat:@"HH"];
    duree = [dureeFormatter stringFromDate:[dureeFormatter1 dateFromString:duree]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *formatterOther = [[NSDateFormatter alloc] init];
    [formatterOther setDateFormat:@"EEEE dd MMMM"];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatterOther setLocale:usLocale];
    
    cell.textLabel.text =  [formatterOther stringFromDate:[formatter dateFromString:jourAffich]] ;
    cell.detailTextLabel.text = duree;
    return cell;
}

 // Previous Monday of dateX
- (NSDate*) getPreviousMonday:(NSDate*)dateX{
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

//Orange BeaconTag

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

- (NSArray*) userWorkTime:(NSString*)start until:(NSString*)end{
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *query = [[[[[[@"select date, hours from workTime where date BETWEEN '" stringByAppendingString:start] stringByAppendingString:@"' AND '"] stringByAppendingString:end ] stringByAppendingString:@"' AND userID ='" ] stringByAppendingString:uniqueIdentifier] stringByAppendingString:@"' "];
    NSArray *tabl = [self.dbManager loadDataFromDB:query];
    if(tabl == nil || ![tabl count]){
        return nil;
    }
    else{
        return tabl;
    }
}

- (NSNumber*) timeToSeconds:(NSString*)string{
   NSArray* components = [string componentsSeparatedByString:@":"];
   NSString* hour = [components objectAtIndex:0];
   NSString* minutes;
    if([components count] == 1)
        minutes = @"00";
    else  minutes = [components objectAtIndex:1];
    
    return [NSNumber numberWithInteger:[hour integerValue] * 60 * 60 + [minutes integerValue] * 60];

}

- (NSString*) secondsToTime:(NSString*)string{
    
    int totalSeconds = [string intValue];
    
        int minutes = (totalSeconds / 60) % 60;
        int hours = totalSeconds / 3600;
        
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
    
}




@end
