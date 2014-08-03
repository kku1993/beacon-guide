//
//  BeaconCellTableViewCell.h
//  BeaconGuide
//
//  Created by Kevin Ku on 8/3/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconCellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *beaconUUIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *beaconDescriptionLabel;

@end
