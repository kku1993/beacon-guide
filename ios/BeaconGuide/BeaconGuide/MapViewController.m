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

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    NSArray *displays_; //array of JSON exhibit data
    NSDictionary *display_;
    GMSMarker *marker_;
    NSDictionary *levels_;
    
}

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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.38 longitude:-122.06 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.myLocationButton = NO;
    mapView_.settings.indoorPicker = NO;
    mapView_.delegate = self;
    mapView_.indoorDisplay.delegate = self;
    
    self.view = mapView_;
    
    //Parsing json data to map
    NSString *jsonPath = [[NSBundle mainBundle]pathForResource:@"indoorMap" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    displays_ = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]init];
    [segmentedControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segmentedControl setTintColor:[UIColor colorWithRed:0.333f green:0.666f blue:0.882f alpha:.7f]];
    
    segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
    [segmentedControl addTarget:self action:@selector(displaysSelected:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    for(NSDictionary *display in displays_){
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:display[@"key"]] atIndex:[displays_ indexOfObject:display] animated:NO];
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(segmentedControl);
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"[segmentedControl]-|" options:kNilOptions metrics:nil views:views ]];
    
    
    [self.view addConstraint:[NSLayoutConstraint
                              constraintsWithVisualFormat:@"V: [segmentedControl]-|" options:kNilOptions metrics:nil views:views ]];
    
    
    
}

- (void)moveMarker {
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([display_[@"lat"] doubleValue], [display_[@"lng"] doubleValue]);
    
    if(marker_ == nil){
        marker_ = [GMSMarker markerWithPosition:location];
        marker_.map = mapView_;
    } else {
        marker_.position = location;
    }
    
    marker_.title = display_[@"name"];
    [mapView_ animateToLocation:location];
    [mapView_ animateToZoom:19];
}

- (void)displaysSelected: (UISegmentedControl *)segmentedControl {
    display_ = displays_[[segmentedControl selectedSegmentIndex]];
    [self moveMarker];
}

- (void)mapView: (GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)camera {
    if(display_ != nil){
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([display_[@"lat"] doubleValue], [display_[@"lng"] doubleValue]);
        if([mapView_.projection containsCoordinate:location] && levels_ != nil){
            [mapView.indoorDisplay setActiveLevel:levels_[display_[@"level"]]];
        }
    }
}

- (void)didChangeActiveBuilding: (GMSIndoorBuilding *)building{
    if(building != nil){
        NSMutableDictionary *levels = [NSMutableDictionary dictionary];
        for(GMSIndoorLevel *level in building.levels){
            [levels setObject:level forKey:level.shortName];
        }
        
        levels_ = [NSDictionary dictionaryWithDictionary:levels];
    }
    else {
        levels_ = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (GMSMapView *)mapView{
//    
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
    
//    if(!_mapView){
//        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.38 longitude:-122.06 zoom:6];
//        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//        _mapView.buildingsEnabled = NO;
//        _mapView.myLocationEnabled = YES;
//    }
//    return _mapView;
//}
@end
