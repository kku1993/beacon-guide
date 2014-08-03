//
//  NavViewController.h
//  BeaconGuide
//
//  Created by Kaili An on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavViewController : UIViewController

- (id)initWithBuildingData:(NSDictionary *)building startBeaconID:(NSString *)startBeaconID endBeaconID:(NSString *)endBeaconID;

@end
