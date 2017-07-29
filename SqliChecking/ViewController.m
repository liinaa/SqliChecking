//
//  ViewController.m
//  SqliChecking
//
//  Created by Lina Ait Khouya on 25/07/2017.
//  Copyright © 2017 Lina Ait Khouya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITableView *presenceTableView;
@property (strong, nonatomic) IBOutlet UIButton *profilButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    jourSemaine=@[@"Lundi",@"Mardi",@"Mercredi",@"Jeudi",@"Vendredi",@"Samedi",@"Dimanche"];
    tab = @{ @"Semaine 1" : @{@"Lundi":@"7",@"Mardi":@"8",@"Mercredi":@"7",@"Jeudi":@"8"},
             @"Semaine 2" : @{@"Lundi":@"7",@"Mardi":@"7",@"Mercredi":@"7",@"Jeudi":@"7",@"Vendredi":@"7",@"Samedi":@"8",@"Dimanche":@"7"},
             @"Semaine 3" : @{@"Lundi":@"7",@"Mardi":@"8",@"Mercredi":@"7",@"Jeudi":@"8",@"Vendredi":@"7",@"Samedi":@"8",@"Dimanche":@"8"},
             @"Semaine 4" : @{@"Lundi":@"7",@"Mardi":@"7",@"Mercredi":@"7",@"Jeudi":@"7",@"Vendredi":@"7",@"Samedi":@"8",@"Dimanche":@"7"}
             };

    semaine = [[tab allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
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
   [tab enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { __block NSNumber *temp = 0;
       
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    temp = @([temp integerValue]+ [obj integerValue]);
                    
                }];
       
        [dureeTotal setObject:temp forKey:key];
   }];
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
    return [semaine objectAtIndex:section];
}

- (NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *sectionTitle = [semaine objectAtIndex:section];
    NSString *dt = [dureeTotal objectForKey:sectionTitle];
    NSString *result = [NSString stringWithFormat:@"Nombre d'heures total               %@",dt];
    return result;
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

    cell.textLabel.text = jourAffich;
    cell.detailTextLabel.text = duree;
    return cell;
}

@end
