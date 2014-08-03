//
//  SearchViewController.m
//  BeaconGuide
//
//  Created by ; An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *selectionTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;


@end

@implementation SearchViewController

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
    self.view.userInteractionEnabled = TRUE;
    self.ScrollView.contentSize = self.selectionTableView.frame.size;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.selectionTableView.tableHeaderView= searchBar;
    UITableView *selectionView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGPoint contentOffset = self.selectionTableView.contentOffset;
    contentOffset.y += CGRectGetHeight(self.selectionTableView.tableHeaderView.frame);
    self.selectionTableView.contentOffset = contentOffset;
    [self.view endEditing:YES];
}

- (void) dismissKeyBoard
{
    [self.searchBar resignFirstResponder];
}
@end
