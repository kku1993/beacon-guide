//
//  NavViewController.m
//  BeaconGuide
//
//  Created by Kaili An on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "NavViewController.h"
#import "SearchViewController.h"

@interface NavViewController ()

@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSString *startBeaconID;
@property (strong, nonatomic) NSString *endBeaconID;

// progress view
@property (strong, nonatomic) MRCircularProgressView *progressView;
@property (nonatomic) CGFloat progress;

// path
@property (strong, nonatomic) NSArray *path;
@property (nonatomic) int currentBeaconNum;
@property (strong, nonatomic) NSDictionary *waypointBeaconData;


// estimote
@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (strong, nonatomic) ESTBeaconRegion *scanRegion;
@end



@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBuildingData:(NSDictionary *)building startBeaconID:(NSString *)startBeaconID endBeaconID:(NSString *)endBeaconID {
    self = [super init];
    if(self) {
        self.building = building;
        self.startBeaconID = startBeaconID;
        self.endBeaconID = endBeaconID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up path
    self.currentBeaconNum = 0;
    BeaconGuideAPI *api = [BeaconGuideAPI instance];
    [api getPath:self.startBeaconID :self.endBeaconID :self.building[@"buildingID"] :^(AFHTTPRequestOperation *operation, id data) {
        self.path = data;
        self.currentBeaconNum = 0;
        if([self.path count]) {
            self.waypointBeaconData = [self.building[@"beaconDetails"] objectAtIndex:[self.path[0] intValue]];
        }
    } :^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    // estimote
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;

    // scan for all estimote beacons
    self.scanRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID identifier:@"building-scan"];
    [self.beaconManager startRangingBeaconsInRegion:self.scanRegion];
    
    // set up progress view
    UIView *topBar =[[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    self.progressView = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(topBar.frame) - 100 / 2.0f,
                                                                                       CGRectGetMidY(topBar.frame) - 100 / 2.0f,
                                                                                       100,
                                                                                       100)];
    [topBar addSubview:self.progressView];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(progressUpdate)
                                   userInfo:nil
                                    repeats:YES];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.bounds), CGRectGetWidth(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    self.progress = 0;
    
    [self.view addSubview:topBar];
    [self.view addSubview:bottomView];
}

-(void)progressUpdate {
    self.progress += 0.1;
    if(self.progress > 1.0f) {
        return;
    }
    [self.progressView setProgress:self.progress animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// beacon
-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if([beacons count] > 0) {
        [self.beaconManager stopMonitoringForRegion:self.scanRegion];
        
        ESTBeacon* closestBeacon = [beacons objectAtIndex:0];
        //NSUUID *UUID = closestBeacon.proximityUUID;
        NSNumber *majorNumber = closestBeacon.major;
        NSNumber *minorNumber = closestBeacon.minor;
        
        
        if([majorNumber intValue] == [self.waypointBeaconData[@"majorNumber"] intValue] && [minorNumber intValue] == [self.waypointBeaconData[@"minorNumber"] intValue]) {
            self.currentBeaconNum++;
            
            if(self.currentBeaconNum == [self.path count]) {
                // reached target
                NSLog(@"Reached Target");
                self.waypointBeaconData = nil;
                [self.beaconManager stopMonitoringForRegion:self.scanRegion];
                return;
            }
            
            self.waypointBeaconData = self.building[@"beaconDetails"][[self.path[self.currentBeaconNum] intValue]];
        }
    }
}


@end
