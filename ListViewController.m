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


@interface ListViewController ()

@property (nonatomic,strong) NSArray *notes;

@property (nonatomic,strong) UITableView *tableView;


@end

@implementation ListViewController

-(void) refreshList {
    
    self.notes = [INotesStorageManager getNote];
    [self.tableView reloadData];
    
}


-(void) showEdit {
    EditViewController * edit = [[EditViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:edit];
    
    
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(refreshList) name:@"newNoteSave" object:nil];
    [center addObserver:self selector:@selector(refreshList) name:@"deleteReload" object:nil];
    
    
    
    self.notes = [INotesStorageManager getNote];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIBarButtonItem *editButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    
    
    [self.view addSubview:self.tableView];
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setContentTitle:@"Notes"];
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
    
    return 200.0;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
