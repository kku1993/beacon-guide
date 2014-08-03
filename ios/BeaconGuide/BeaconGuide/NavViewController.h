//
//  NavViewController.h
//  BeaconGuide
//
//  Created by Kaili An on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BeaconGuideAPI.h"
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"

#import "MRProgress.h"

@interface NavViewController : UIViewController <ESTBeaconManagerDelegate>

- (id)initWithBuildingData:(NSDictionary *)building startBeaconID:(NSString *)startBeaconID endBeaconID:(NSString *)endBeaconID;

@end
