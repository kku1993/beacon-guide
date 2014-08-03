//
//  NavViewController.m
//  BeaconGuide
//
//  Created by Kaili An on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "NavViewController.h"
#import "SearchViewController.h"
#import "THProgressView.h"

static const CGSize progressViewSize = { 200.0f, 30.0f };

@interface NavViewController ()

@property (nonatomic,strong) UIButton *displaySearchView;
@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSString *startBeaconID;
@property (strong, nonatomic) NSString *endBeaconID;

@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) THProgressView *progBar;

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
    
    [self.view addSubview:self.displaySearchView];
    
    
//    CGRect rect = CGRectMake(10, 180, 300, 44);
//    THProgressView *progressView = [[THProgressView alloc] initWithFrame:rect];
//    progressView.borderTintColor = [UIColor whiteColor];
//    progressView.progressTintColor = [UIColor whiteColor];
//    [progressView setProgress:0.5f animated:YES];
    
    
    
//    self.progressBar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//    self.progressBar.progress = 0.0;
//    [self performSelectorInBackground:@selector(progressUpdate) withObject:nil];
//    [self.view addSubview:self.progressBar];
    
    
    UIView *topBar =[[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.bounds), CGRectGetMidY(self.view.bounds))];
    THProgressView *topProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(CGRectGetMidX(topBar.frame) - progressViewSize.width / 2.0f,
                                                                                       CGRectGetMidY(topBar.frame) - progressViewSize.height / 2.0f,
                                                                                       progressViewSize.width,
                                                                                       progressViewSize.height)];
    topProgressView.borderTintColor = [UIColor whiteColor];
    topProgressView.progressTintColor = [UIColor whiteColor];
    [topBar addSubview:topProgressView];
    [self.view addSubview:topBar];
}


-(void)progressUpdate {
    for(int i = 0; i<100; i++){
        [self performSelectorOnMainThread:@selector(setProgress:) withObject:[NSNumber numberWithFloat:(1/(float)i)] waitUntilDone:YES];
    }
}

- (void)setProgress:(NSNumber *)number
{
    [self.progressBar setProgress:number.floatValue animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
