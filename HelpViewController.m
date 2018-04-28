//
//  HelpViewController.m
//  SXSpeechRecognitionTwoWays
//
//  Created by danping yan on 4/25/18.
//  Copyright © 2018 Sankuai. All rights reserved.
//

#import "HelpViewController.h"
#import "StorageUtility.h"
#import "LoginViewController.h"

@interface HelpViewController ()

@property (nonatomic,strong) UITextView *inputView;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.inputView = [[UITextView alloc] initWithFrame:CGRectMake(0, 84, [UIScreen mainScreen].bounds.size.width,300)];
    self.inputView.text = @"Please register your account and password before logining.\nIf you want to use voice input, please click on start button; if you want to delete text, please click on stop button.";
    [self.view addSubview:self.inputView];
    
    
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(150, 550, 100, 30);
    [returnBtn setTitle:@"Return" forState:UIControlStateNormal];
    [returnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(Return:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtn];
    



    
    
    
}


- (IBAction)Return:(id)sender {
    
    // switch to login interface
    LoginViewController *page = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:page];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    
    
    
    
    
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
