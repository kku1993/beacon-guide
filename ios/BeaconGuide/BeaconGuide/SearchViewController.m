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
    [api getBeaconBuilding:ESTIMOTE_PROXIMITY_UUID :1 :1 :^(AFHTTPRequestOperation *operation, id data) {
        self.building = data;
        [self.beaconsTableView reloadData];
    } :^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [self.beaconManager startMonitoringForRegion:self.scanRegion];
    }];
}

- (void)initNavBar {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                    style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.navigationItem.title = @"Beacons in the Building";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goNext {
    MapViewController *mapViewController = [[MapViewController alloc]initWithNibName:nil bundle:NULL];
    [self.navigationController pushViewController:mapViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(goBack) withObject:nil afterDelay:5.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"BeaconCell";
    
    BeaconCellTableViewCell *cell = [self.beaconsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BeaconCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.beaconUUIDLabel.text = self.building[@"beaconDetails"][indexPath.row][@"UUID"];
    cell.beaconDescriptionLabel.text = self.building[@"beaconDetails"][indexPath.row][@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.building[@"beaconDetails"] count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

// beacon
-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if([beacons count] > 0) {
        [self.beaconManager stopMonitoringForRegion:self.scanRegion];
        
        ESTBeacon* closestBeacon = [beacons objectAtIndex:0];
        NSUUID *UUID = closestBeacon.proximityUUID;
        NSUInteger majorNumber = [closestBeacon.major unsignedIntegerValue];
        NSUInteger minorNumber = [closestBeacon.minor unsignedIntegerValue];
        
        // get building info
        BeaconGuideAPI *api = [BeaconGuideAPI instance];
        [api getBeaconBuilding:UUID :majorNumber :minorNumber :^(AFHTTPRequestOperation *operation, id data) {
            self.building = data;
            [self.beaconsTableView reloadData];
        } :^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [self.beaconManager startMonitoringForRegion:self.scanRegion];
        }];
    }
}

@end
