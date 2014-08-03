//
//  SearchViewController.m
//  BeaconGuide
//
//  Created by ; An on 8/2/14.
//  Copyright (c) 2014 Beacon_Guide. All rights reserved.
//

#import "SearchViewController.h"
#import "categoryTableViewCell.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *selectionTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (strong, nonatomic) NSArray *locations;


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
    self.selectionTableView.delegate = self;
   // self.selectionTableView.dataSource = self;
    
    self.ScrollView.contentSize = self.selectionTableView.frame.size;
    
    //search bar as header
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.selectionTableView.tableHeaderView= searchBar;
    //UITableView *selectionView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    //set each table view photo
    UINib *nib = [UINib nibWithNibName:@"categoryTableViewCell" bundle:nil];
    [self.selectionTableView registerNib:nib forCellReuseIdentifier:@"categoryTableViewCell"];
    
   // self.selectionTableView.rowHeight = 320;
    self.selectionTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray *sectionArray = self.arrayOfSections[section];
    return sectionArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    categoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryTableViewCell"];
    cell.textLabel.text = [[NSString alloc]initWithFormat:@"Cell %ld", (long)indexPath.row];
    NSMutableArray *sectionArray = self.arrayOfSections[indexPath.section];
    cell.textLabel.text = sectionArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *) newSectionWithIndex:(NSUInteger)paramIndex cellCount:(NSUInteger)paramCellCount{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSUInteger counter=0;
    for(counter = 0;
        counter < paramCellCount;
        counter++){
        [result addObject:[[NSString alloc]initWithFormat:@"",(unsigned long)paramIndex,(unsigned long)counter+1]];
    }
    return result;
}

- (NSMutableArray *) arrayOfSections{
    
    if(_arrayOfSections == nil){
        
        NSMutableArray *s1 = [self newSectionWithIndex:1 cellCount:3];
        NSMutableArray *s2 = [self newSectionWithIndex:2 cellCount:3];
        NSMutableArray *s3 = [self newSectionWithIndex:3 cellCount:3];
        
        _arrayOfSections = [[NSMutableArray alloc]initWithArray:@[s1,s2,s3]];
    }
    
    return _arrayOfSections;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayOfSections.count;
}
@end
