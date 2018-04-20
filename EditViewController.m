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
#import "DBManager.h"




@interface EditViewController ()

@property (nonatomic,strong) UITextView *inputView;

@property (nonatomic, strong) DBManager *dbManager;

//@property (nonatomic,strong)IFlyRecognizerView *iflyRecognizerView;

/*@property (nonatomic,strong) IFlySpeechUnderstander *iFlySpeechUnderstander;
 @property (nonatomic,strong) NSString               *result;
 @property (nonatomic,strong) NSString               *str_result;
 @property (nonatomic)         BOOL                  isCanceled;*/



@end

@implementation EditViewController

-(void) saveNotes {
    
    
    // if content is empty, cannot be saved
    if (self.inputView.text.length == 0) {
        
        UIAlertController *notification2 = [UIAlertController alertControllerWithTitle:@"content cannot be empty" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [notification2 addAction:action2];
        [self presentViewController:notification2 animated:YES completion:nil];
        
        
        return;
    }
    
    
    
    // if characters > 1000, push notification
    if(self.inputView.text.length > 1000) {
        
        // push notification
        UIAlertController *notification = [UIAlertController alertControllerWithTitle:@"cannot be saved if characters > 1000" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [notification addAction:action];
        [self presentViewController:notification animated:YES completion:nil];
        
        
        return;
        
        
    }
    
    
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
    
    NSString *query = [NSString stringWithFormat:@"insert into userInfo values(null, '%@','%@','%@')", self.inputView.text,self.inputView.text,self.inputView.text];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query2 was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    
    
    
}



-(void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*- (void)startListenning:(id)sender{
    [self.iflyRecognizerView start];
    NSLog(@"开始识别");
}

//返回数据处理
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    NSLog(@"DIC:%@",dic);
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    //把相应的控件赋值为result.例如:label.text = result;
    self.inputView.text = result;
}

- (void)onError:(IFlySpeechError *)error
{
    
}  */







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
    
    
    self.inputView.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    
    
    /*NSString *appid = @"5ac6d6f5";// appId
    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
    [IFlySpeechUtility createUtility:initString];
    
    self.iflyRecognizerView.delegate = self;
    [self.view addSubview:self.iflyRecognizerView];
    [self.iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名,默认目录是documents
    [self.iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //设置返回的数据格式为默认plain
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [self startListenning:self.iflyRecognizerView];//可以建一个按钮,点击按钮调用此方法 */

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
