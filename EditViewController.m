//
//  EditViewController.m
//  MyFirstApp
//
//  Created by danping yan on 2/10/18.
//  Copyright © 2018 danping yan. All rights reserved.
//

#import "EditViewController.h"
#import "StorageUtility.h"
#import "INotesStorageManager.h"

@interface EditViewController ()

@property (nonatomic,strong) UITextView *inputView;



@end

@implementation EditViewController

-(void) saveNotes {
    
    NSString *content = self.inputView.text;
    NSNumber *timestamp = [StorageUtility timestamp];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:content,@"content",
                                                                          timestamp,@"timestamp",nil];
    
    BOOL saveSuccess = [INotesStorageManager storeDictionary:dictionary];
    if(saveSuccess) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        NSNotification *notification = [NSNotification notificationWithName:@"newNoteSave" object:nil];
        [center postNotification:notification];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
   
    
    
}



-(void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setContentTitle:@"Edit"];
    
    
    
    UIBarButtonItem *completeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveNotes)];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    
    self.navigationItem.rightBarButtonItem = completeButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
    self.inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width,300)];
    [self.view addSubview:self.inputView];
    /*self.inputView.delegate = self;
    self.inputView.delegate = self;
    self.inputView.editable = YES;*/
    
    [self.inputView becomeFirstResponder];
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
