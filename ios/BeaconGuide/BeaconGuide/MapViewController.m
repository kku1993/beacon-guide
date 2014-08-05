//
//  MapViewController.m
//  BeaconGuide
//
//  Created by Kaili An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "MapViewController.h"
#import "GoogleMaps/GoogleMaps.h"


@interface MapViewController ()< GMSIndoorDisplayDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource>

@property (strong, nonatomic) NSDictionary *building;


@end

@implementation MapViewController{
    GMSMapView *mapView_;
//    NSArray *displays_; //array of JSON exhibit data
//    NSDictionary *display_;
//    GMSMarker *marker_;
    
    UIPickerView *levelPickerView_;
//    NSDictionary *levels_;
    NSArray *levels_;
    GMSMarker *_currentLocationMarker;
    GMSMarker *_nextDestMarker;
    GMSMarker *_thirdMarker;
    UIView *_contentView;
    UIView *_contentView2;
    UIView *_contentView3;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBuildingData:(NSDictionary *)building {
    self = [super init];
    if(self) {
        self.building = building;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Indoor Map";
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.78318
                                                            longitude:-122.403874
                                                                 zoom:18];
    
    
    
    // set backgroundColor, otherwise UIPickerView fades into the background
    self.view.backgroundColor = [UIColor grayColor];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.myLocationButton = NO;
    mapView_.settings.indoorPicker = NO; // We are implementing a custom level picker.
    
    mapView_.indoorEnabled = YES; // Defaults to YES. Set to NO to hide indoor maps.
    mapView_.indoorDisplay.delegate = self;
    mapView_.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mapView_];
    
    NSArray *beaconData = self.building[@"beaconDetails"];
    
    _currentLocationMarker = [[GMSMarker alloc]init];
    _currentLocationMarker.title = @"Starting point";
    _currentLocationMarker.snippet = @"Current Store is: Victoria Secret";
    _currentLocationMarker.position = CLLocationCoordinate2DMake([beaconData[0][@"position"][@"lat"] doubleValue], [beaconData[0][@"position"][@"lng"] doubleValue]);
    _currentLocationMarker.map = mapView_;
    NSLog(@"Starting point location: %@", _currentLocationMarker);
    
    
    
    _nextDestMarker = [[GMSMarker alloc]init];
    _nextDestMarker.title = @"first stopping point";
    _nextDestMarker.snippet = @"Current Store is: Nordstrom";
    _nextDestMarker.position = CLLocationCoordinate2DMake([beaconData[1][@"position"][@"lat"] doubleValue], [beaconData[1][@"position"][@"lng"] doubleValue]);
    _nextDestMarker.map = mapView_;
    NSLog(@"First stopping point location: %@", _nextDestMarker);
    
    _thirdMarker = [[GMSMarker alloc]init];
    _thirdMarker.title = @"last stopping point";
    _thirdMarker.snippet = @"Current Store is: Nordstrom";
    _thirdMarker.position = CLLocationCoordinate2DMake([beaconData[2][@"position"][@"lat"] doubleValue], [beaconData[2][@"position"][@"lng"] doubleValue]);
    _thirdMarker.map = mapView_;
    NSLog(@"First stopping point location: %@", _thirdMarker);
    
    
    
    // This UIPickerView will be populated with the levels of the active building.
    levelPickerView_ = [[UIPickerView alloc] init];
    levelPickerView_.delegate = self;
    levelPickerView_.dataSource = self;
    levelPickerView_.showsSelectionIndicator = YES;
    levelPickerView_.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:levelPickerView_];
    
    // The height of the UIPickerView, used below in the vertical constraint
    NSDictionary *metrics = @{@"height": @180.0};
    NSDictionary *views = NSDictionaryOfVariableBindings(mapView_, levelPickerView_);
    
    // Constraining the map to the full width of the display.
    // The |levelPickerView_| is constrained below with the NSLayoutFormatAlignAll*
    // See http://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/Articles/formatLanguage.html
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"|[mapView_]|"
                               options:0
                               metrics:metrics
                               views:views]];
    
    // Constraining the mapView_ and the levelPickerView_ as siblings taking
    // the full height of the display, with levelPickerView_ at 200 points high
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[mapView_][levelPickerView_(height)]|"
                               options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight
                               metrics:metrics
                               views:views]];
    
    mapView_.delegate = self;
    self.view = mapView_;
    
    
    _contentView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step1"]];
//    _contentView2 =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step2"]];
//    _contentView3 =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step3"]];
    }


- (void)didChangeActiveBuilding:(GMSIndoorBuilding *)building {
    // Everytime we change active building force the picker to re-display the labels.
    
    NSMutableArray *levels = [NSMutableArray array];
    if (building.underground) {
        // If this building is completely underground, add a fake 'top' floor. This must be the 'boxed'
        // nil, [NSNull null], as NSArray/NSMutableArray cannot contain nils.
        [levels addObject:[NSNull null]];
    }
    [levels addObjectsFromArray:building.levels];
    levels_ = [levels copy];
    
    [levelPickerView_ reloadAllComponents];
    [levelPickerView_ selectRow:-1 inComponent:0 animated:NO];
    
    // UIPickerView insists on having some data; disable interaction if there's no levels.
    levelPickerView_.userInteractionEnabled = ([levels_ count] > 0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didChangeActiveLevel:(GMSIndoorLevel *)level {
    // On level change, sync our level picker's selection to the IndoorDisplay.
    if (level == nil) {
        level = (id)[NSNull null];  // box nil to NSNull for use in NSArray
    }
    NSUInteger index = [levels_ indexOfObject:level];
    if (index != NSNotFound) {
        NSInteger currentlySelectedLevel = [levelPickerView_ selectedRowInComponent:0];
        if ((NSInteger)index != currentlySelectedLevel) {
            [levelPickerView_ selectRow:index inComponent:0 animated:NO];
        }
    }
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    // On user selection of a level in the picker, set the right level in IndoorDisplay
    id level = levels_[row];
    if (level == [NSNull null]) {
        level = nil;  // unbox NSNull
    }
    [mapView_.indoorDisplay setActiveLevel:level];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    id object = levels_[row];
    if (object == [NSNull null]) {
        return @"\u2014";  // use an em dash for 'above ground'
    }
    GMSIndoorLevel *level = object;
    return level.name;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [levels_ count];
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    if(marker == _currentLocationMarker){
        return _contentView;
    }
//    else if(marker == _nextDestMarker)
//    {
//        return _contentView2;
//    }
    return nil;
}
                   
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker{
//    if(marker == _thirdMarker){
//        return _contentView3;
//    }
//    return nil;
//}

@end
