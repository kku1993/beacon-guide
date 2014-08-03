//
//  SearchViewController.m
//  BeaconGuide
//
//  Created by ; An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "SearchViewController.h"
#import "GoogleMaps/GoogleMaps.h"
#import "NavViewController.h"
#import "MapViewController.h"
#import "BeaconCellTableViewCell.h"

@interface SearchViewController ()

@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (strong, nonatomic) ESTBeaconRegion *scanRegion;
@property (strong, nonatomic) NSDictionary *currentBeaconData;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavBar];
    
    self.beaconsTableView.delegate = self;
    self.beaconsTableView.dataSource = self;
    
    self.building = nil;
    
    // estimote
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // scan for all estimote beacons
    self.scanRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"building-scan"];
    [self.beaconManager startRangingBeaconsInRegion:self.scanRegion];
    
    // DEBUG
    BeaconGuideAPI *api = [BeaconGuideAPI instance];
    [api getBeaconBuilding:ESTIMOTE_PROXIMITY_UUID :[[NSNumber alloc] initWithInt: 1] :[[NSNumber alloc] initWithInt: 1] :^(AFHTTPRequestOperation *operation, id data) {
        self.building = data;
        
        NSArray *beacons = self.building[@"beaconDetails"];
        for(int i = 0; i < [beacons count]; i++) {
            NSDictionary *b = beacons[i];
            if([b[@"majorNumber"] intValue] == 1 && [b[@"minorNumber"] intValue] == 1) {
                self.currentBeaconData = b;
                break;
            }
        }
        
        [self.beaconsTableView reloadData];
    } :^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.beaconManager startMonitoringForRegion:self.scanRegion];
    }];
}

- (void)initNavBar {
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleDone target:self action:@selector(showMap)];
    self.navigationItem.rightBarButtonItem = mapButton;
    
    self.navigationItem.title = @"Beacons in the Building";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) showMap {
    MapViewController *map = [[MapViewController alloc] initWithBuildingData:self.building];
    [self.navigationController pushViewController:map animated:YES];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BeaconCell";
    
    BeaconCellTableViewCell *cell = [self.beaconsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BeaconCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(indexPath.section == 0) {
        //current beacon
        cell.beaconUUIDLabel.text = [[NSString alloc] initWithFormat:@"%@-%@", self.currentBeaconData[@"majorNumber"], self.self.currentBeaconData[@"minorNumber"]];
        cell.beaconDescriptionLabel.text = @"My Current Location";
        return cell;
    }
    
    //TODO: filter out the current beacon
    // all beacons
    NSDictionary *b = self.building[@"beaconDetails"][indexPath.row];
    cell.beaconUUIDLabel.text = [[NSString alloc] initWithFormat:@"%@-%@", b[@"majorNumber"], b[@"minorNumber"]];
    cell.beaconDescriptionLabel.text = self.building[@"beaconDetails"][indexPath.row][@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // launch navigation to the selected beacon
    if(indexPath.section != 0) {
        NavViewController *nav = [[NavViewController alloc] initWithBuildingData:self.building startBeaconID:self.currentBeaconData[@"beaconID"] endBeaconID:self.building[@"beaconDetails"][indexPath.row][@"beaconID"]];
        [self.navigationController pushViewController:nav animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) {
        return 1;
    }
    return [self.building[@"beaconDetails"] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"Current Location";
            break;
        case 1:
            sectionName = @"Other Beacons in the Building";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

// beacon
-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if([beacons count] > 0) {
        [self.beaconManager stopMonitoringForRegion:self.scanRegion];
        
        ESTBeacon* closestBeacon = [beacons objectAtIndex:0];
        NSUUID *UUID = closestBeacon.proximityUUID;
        NSNumber *majorNumber = closestBeacon.major;
        NSNumber *minorNumber = closestBeacon.minor;
        
        // get building info
        BeaconGuideAPI *api = [BeaconGuideAPI instance];
        [api getBeaconBuilding:UUID :majorNumber :minorNumber :^(AFHTTPRequestOperation *operation, id data) {
            self.building = data;
            
            NSArray *beacons = self.building[@"beaconDetails"];
            for(int i = 0; i < [beacons count]; i++) {
                NSDictionary *b = beacons[i];
                if(b[@"UUID"] == closestBeacon.proximityUUID && b[@"majorNumber"] == closestBeacon.major && b[@"minorNumber"] == closestBeacon.minor) {
                    self.currentBeaconData = b;
                    break;
                }
            }
            
            [self.beaconsTableView reloadData];
        } :^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self.beaconManager startMonitoringForRegion:self.scanRegion];
        }];
    }
}

@end
