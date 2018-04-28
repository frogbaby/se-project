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
#import "AVAudioManager.h"
#import <Speech/Speech.h>




@interface EditViewController ()

@property (nonatomic,strong) UITextView *inputView;

@property (nonatomic, strong) DBManager *dbManager;

@property(nonatomic,strong)SFSpeechRecognizer *bufferRec;
@property(nonatomic,strong)SFSpeechAudioBufferRecognitionRequest *bufferRequest;
@property(nonatomic,strong)SFSpeechRecognitionTask *bufferTask;
@property(nonatomic,strong)AVAudioEngine *bufferEngine;
@property(nonatomic,strong)AVAudioInputNode *buffeInputNode;


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




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // voice
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {

        if(status != SFSpeechRecognizerAuthorizationStatusAuthorized){
            NSLog(@"exit");
            [@[] objectAtIndex:1];
        }
    }];
    [[AVAudioManager shareAudioManager] startRecording];
    
    
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
    
    

    
    
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(150, 350, 100, 30);
    [registerBtn setTitle:@"Start" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(startBufferR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(150, 400, 100, 30);
    [loginBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(stopBufferR:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
 

}

- (IBAction)startBufferR:(id)sender {
    
    self.bufferRec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    self.bufferEngine = [[AVAudioEngine alloc]init];
    self.buffeInputNode = [self.bufferEngine inputNode];
    
    if (_bufferTask != nil) {
        [_bufferTask cancel];
        _bufferTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [audioSession setActive:true error:nil];
    
    self.bufferRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    self.bufferRequest.shouldReportPartialResults = true;
    __weak EditViewController *weakSelf = self;
    self.bufferTask = [self.bufferRec recognitionTaskWithRequest:self.bufferRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        if (result != nil) {
            weakSelf.inputView.text = result.bestTranscription.formattedString;
        }
        if (error != nil) {
            NSLog(@"%@",error.userInfo);
        }
    }];
    

    AVAudioFormat *format =[self.buffeInputNode outputFormatForBus:0];
    [self.buffeInputNode installTapOnBus:0 bufferSize:1024 format:format block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [weakSelf.bufferRequest appendAudioPCMBuffer:buffer];
    }];
    
    [self.bufferEngine prepare];
    NSError *error = nil;
    if (![self.bufferEngine startAndReturnError:&error]) {
        NSLog(@"%@",error.userInfo);
    };
    self.inputView.text = @"Say something.....";
}

- (IBAction)stopBufferR:(id)sender {
    [self.bufferEngine stop];
    [self.buffeInputNode removeTapOnBus:0];
    self.inputView.text = @"";
    self.bufferRequest = nil;
    self.bufferTask = nil;
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
