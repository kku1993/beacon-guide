//
//  SearchViewController.h
//  BeaconGuide
//
//  Created by Kaili An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BeaconGuideAPI.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import "ESTBeacon.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ESTBeaconManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *beaconsTableView;

@end