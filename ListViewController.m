//
//  ListViewController.m
//  MyFirstApp
//
//  Created by danping yan on 1/28/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"
#import "DetailViewController.h"
#import "EditViewController.h"
#import "INotesStorageManager.h"
#import "StorageUtility.h"
#import "BlankView.h"


@interface ListViewController ()

@property (nonatomic,strong) NSArray *notes;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *blankView;


@end

@implementation ListViewController


-(void) refreshList {
    
    // sort lists
    NSMutableArray *changedNotes = [INotesStorageManager getNote];
    self.notes = [changedNotes sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        NSNumber *obj1Timestamp = [obj1 objectForKey:@"timestamp"];
        NSNumber *obj2Timestamp = [obj2 objectForKey:@"timestamp"];
        
        if(obj1Timestamp > obj2Timestamp) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        if(obj2Timestamp > obj1Timestamp) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [self dealwithView];
}

//3 situations
- (void) dealwithView {
    
    [self.tableView reloadData];
    

    
    // read notes successfully, row = 0
    if([self.notes count] == 0) {
        
        [self.tableView removeFromSuperview];
        [self.blankView removeFromSuperview];
        
        [self.view addSubview:self.blankView];
        return;
    }
    
    // read notes successfully, row != 0
    [self.tableView removeFromSuperview];
    [self.blankView removeFromSuperview];
    
    [self.view addSubview:self.tableView];
    
    
}


-(void) showEdit {
    EditViewController * edit = [[EditViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:edit];
    
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // list view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    //blank list view
    self.blankView = [BlankView buttonContent:@"EDIT" target:self action:@selector(showEdit)];
    
    
    
    
    
    UIBarButtonItem *editButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setContentTitle:@"Notes"];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(refreshList) name:@"newNoteSave" object:nil];
    [center addObserver:self selector:@selector(refreshList) name:@"deleteReload" object:nil];
    
    
    [self refreshList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.notes == nil) {
        return 0;
    }
    
    return [self.notes count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ListCell *cell = [ListCell searchCellForTableView:tableView];
    
    NSInteger row = indexPath.row;
    
    NSDictionary *dictionary = self.notes[row];
    
    NSNumber *timestamp = [dictionary objectForKey:@"timestamp"];
    NSMutableDictionary *dateDictionary = [StorageUtility nowDate:timestamp];
    NSString *year = [dateDictionary objectForKey:@"year"];
    NSString *month = [dateDictionary objectForKey:@"month"];
    NSString *date = [NSString stringWithFormat:@"%@year%@month",year,month];
    [dateDictionary setObject:date forKey:@"yearAndMonth"];
    
    [dateDictionary addEntriesFromDictionary:dictionary];
    
    [cell setContentInList: dateDictionary];
    
    return cell;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSDictionary *dictionary = self.notes[row];
    NSString *content = [dictionary objectForKey:@"content"];
    CGFloat height = [ListCell cellHeight:content];
    
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    NSDictionary *dictionary = self.notes[row];
    
    NSNumber *timestamp = [dictionary objectForKey:@"timestamp"];
    NSMutableDictionary *dateDictionary = [StorageUtility nowDate:timestamp];
    NSString *year = [dateDictionary objectForKey:@"year"];
    NSString *month = [dateDictionary objectForKey:@"month"];
    NSString *day = [dateDictionary objectForKey:@"day"];
    NSString *date2 = [NSString stringWithFormat:@"%@year%@month%@day",year,month,day];
    [dateDictionary setObject:date2 forKey:@"yearAndMonthAndDay"];
    
    [dateDictionary addEntriesFromDictionary:dictionary];
    
    
    DetailViewController *detail = [[DetailViewController alloc] initWithDictionary:dateDictionary];
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    
    if (self.tableView != nil) {
        
        NSIndexPath *row = [self.tableView indexPathForSelectedRow];
        
        if (row != nil) {
            [self.tableView deselectRowAtIndexPath:row animated:YES];
        }
        
        
    }
    
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
