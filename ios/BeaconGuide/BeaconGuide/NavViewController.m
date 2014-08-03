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

@interface NavViewController ()

@property (nonatomic,strong) UIButton *displaySearchView;
@property (strong, nonatomic) NSDictionary *building;
@property (strong, nonatomic) NSString *startBeaconID;
@property (strong, nonatomic) NSString *endBeaconID;
@property (strong, nonatomic) UIProgressView *progressBar;
@property (strong, nonatomic) THProgressView *progBar;
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
    
    
    CGRect rect = CGRectMake(10, 180, 300, 44);
    THProgressView *progressView = [[THProgressView alloc] initWithFrame:rect];
    progressView.borderTintColor = [UIColor whiteColor];
    progressView.progressTintColor = [UIColor whiteColor];
    [progressView setProgress:0.5f animated:YES];
    
    
    
//    self.progressBar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//    self.progressBar.progress = 0.0;
//    [self performSelectorInBackground:@selector(progressUpdate) withObject:nil];
//    [self.view addSubview:self.progressBar];

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
