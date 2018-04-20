//
//  DetailViewController.m
//  MyFirstApp
//
//  Created by danping yan on 1/28/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "DetailViewController.h"
#import "INotesStorageManager.h"
#import "StorageUtility.h"
#import "DBManager.h"


@interface DetailViewController ()

@property (nonatomic,strong) NSDictionary *dictionary;

@property (nonatomic,strong) UITextView *inputView;

@property (nonatomic) int recordIDToEdit;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic, strong) NSIndexPath * indexPath;
-(void)loadInfoToEdit;


@end

@implementation DetailViewController

-(void) removeNote {
    id array = [INotesStorageManager getNote];
    NSMutableArray *note = [NSMutableArray arrayWithArray:array];
    
    NSInteger count, i;
    count = note.count;
    for (i=0; i<count; i=i+1) {
        if([[note[i] objectForKey:@"timestamp"] isEqual:[self.dictionary objectForKey:@"timestamp"]]) {
            [note removeObjectAtIndex:i];
            BOOL saveSuccess = [INotesStorageManager storeNote:note];
            if(saveSuccess) {
                
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                NSNotification *notification = [NSNotification notificationWithName:@"deleteReload" object:nil];
                
                [center postNotification:notification];
                [self.navigationController popViewControllerAnimated:YES];
                
                return;
                
                
            }
        }
    }
    
    int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:_indexPath.row] objectAtIndex:0] intValue];
    
    // Prepare the query.
    NSString *query = [NSString stringWithFormat:@"delete from userInfo where userInfoID=%d", recordIDToDelete];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    
    
    
}

-(void) saveNote {
    
    
    NSString *content = self.inputView.text;
    NSNumber *timestamp = [StorageUtility timestamp];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content",
                                timestamp,@"timestamp",nil];
    
    BOOL saveSuccess = [INotesStorageManager storeDictionary:dictionary];
    if(saveSuccess) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSNotification *notification = [NSNotification notificationWithName:@"newNoteSave" object:nil];
        [center postNotification:notification];
        
        //[self dismissViewControllerAnimated:YES completion:nil];
        id array = [INotesStorageManager getNote];
        NSMutableArray *note = [NSMutableArray arrayWithArray:array];
        
        NSInteger count, i;
        count = note.count;
        for (i=0; i<count; i=i+1) {
            if([[note[i] objectForKey:@"timestamp"] isEqual:[self.dictionary objectForKey:@"timestamp"]]) {
                [note removeObjectAtIndex:i];
                BOOL saveSuccess = [INotesStorageManager storeNote:note];
                if(saveSuccess) {
                    
                    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    NSNotification *notification = [NSNotification notificationWithName:@"deleteReload" object:nil];
                    
                    [center postNotification:notification];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
                    
                    
                }
            }
        }
        
    }
    
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into userInfo values(null, '%@', '%@', %@)", self.inputView.text, self.inputView.text, self.inputView.text];
    }
    else{
        query = [NSString stringWithFormat:@"update peopleInfo set content='%@', content='%@', content=%@ where userID=%d", self.inputView.text, self.inputView.text, self.inputView.text, self.recordIDToEdit];
    }
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeNote)];
    
    self.navigationItem.rightBarButtonItem = removeButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNote)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
    
    //NSString *year = [self.dictionary objectForKey:@"yearAndMonthAndDay"];
    NSString *content = [self.dictionary objectForKey:@"content"];
    
    // [self setTitle: year];
    
    CGSize contentSize = CGSizeMake([StorageUtility screenWidth]-40, 999999999999999);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    
    CGRect contentRect = [content boundingRectWithSize:contentSize
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil];
    
    
    /*
     //正文文字
     UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [StorageUtility screenWidth]-40, contentRect.size.height)];
     contentText.text = content;
     contentText.textColor = [UIColor blackColor];
     contentText.font = [UIFont systemFontOfSize:15];
     contentText.numberOfLines = 0;
     
     UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, [StorageUtility screenWidth], [StorageUtility screenHeight]-64)];
     scroll.contentSize = CGSizeMake(contentRect.size.width, contentRect.size.height+40);
     [scroll addSubview:contentText];
     [self.view addSubview:scroll];
     */
    
    self.inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width,300)];
    self.inputView.text = content;
    [self.view addSubview:self.inputView];
    
    [self.inputView becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (DetailViewController*) initWithDictionary:(NSDictionary*)dictionary {
    
    self = [super init];
    self.dictionary = dictionary;
    
    return self;
    
}



-(void)loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from userInfo where userID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.inputView.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"content"]];
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
