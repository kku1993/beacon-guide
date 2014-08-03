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

@property (nonatomic,strong) UIButton *displaySearchView;
@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSString *startBeaconID;
@property (strong, nonatomic) NSString *endBeaconID;
@property (strong, nonatomic) UIProgressView *progressBar;
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
    // Do any additional setup after loading the view.
    self.title = @"Beacon Guide";
    self.displaySearchView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.displaySearchView setTitle:@"Search indoor category" forState:UIControlStateNormal];
    [self.displaySearchView sizeToFit];
    self.displaySearchView.center = self.view.center;
    
    [self.displaySearchView addTarget:self action:@selector(performDisplaySearchViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.displaySearchView];
    
    self.progressBar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressBar.center = self.view.center;
    self.progressBar.progress = 10.0f/30.0f;
    [self.view addSubview:self.progressBar];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) performDisplaySearchViewController:(id)paramSender{
    SearchViewController *searchView = [[SearchViewController alloc]initWithNibName:nil bundle:NULL];
    [self.navigationController pushViewController:searchView animated:YES];
}

@end
