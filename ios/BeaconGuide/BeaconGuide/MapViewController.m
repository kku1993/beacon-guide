//
//  MapViewController.m
//  BeaconGuide
//
//  Created by Kaili An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"


@interface MapViewController ()
@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation MapViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (GMSMapView *)mapView{
    
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.38 longitude:-122.06 zoom:6];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES;
//    self.view = mapView_;
//    
//    //create a market in the center of the map
//    GMSMarker *marker = [[GMSMarker alloc]init];
//    marker.position = CLLocationCoordinate2DMake(37.38, -122.06);
//    marker.title = @"Mountain View";
//    marker.snippet = @"California, CA";
//    marker.map = mapView_;
    
    if(!_mapView){
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.38 longitude:-122.06 zoom:6];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView.buildingsEnabled = NO;
        _mapView.myLocationEnabled = YES;
    }
    return _mapView;
}
@end
