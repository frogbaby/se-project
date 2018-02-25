//
//  DetailViewController.m
//  MyFirstApp
//
//  Created by danping yan on 1/28/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "DetailViewController.h"
#import "INotesStorageManager.h"

@interface DetailViewController ()

@property (nonatomic,strong) NSDictionary *dictionary;

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
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIBarButtonItem *removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeNote)];
    
    self.navigationItem.rightBarButtonItem = removeButton;
    
    
    NSString *year = [self.dictionary objectForKey:@"yearAndMonthAndDay"];
    NSString *content = [self.dictionary objectForKey:@"content"];
    
    [self setTitle: year];
    
    
    //正文文字
    UILabel *contentText = [[UILabel alloc] initWithFrame:CGRectMake(20, 84, [UIScreen mainScreen].bounds.size.width-40,20)];
    contentText.text = content;
    contentText.textColor = [UIColor blackColor];
    contentText.font = [UIFont systemFontOfSize:15];
    contentText.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:contentText];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
