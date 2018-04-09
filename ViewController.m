//
//  ViewController.m
//  LoginNostoryboard
//
//  Created by Niall Caparon on 3/27/18.
//  Copyright © 2018 Niall Caparon. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import "INotesStorageManager.h"
#import "StorageUtility.h"

@interface ViewController ()
@property (strong, nonatomic)  UITextField *usernameField;
@property (strong, nonatomic)  UITextField *passwordField;
@property (strong, nonatomic)  UITextField *reenterPasswordField;

@property (strong, nonatomic)  UIButton *registerBtn;
@property (strong, nonatomic)  UIButton *loginBtn;

@property (strong, nonatomic)  NSString *usernameoutput;
@property (strong, nonatomic)  NSString *passoutput;
@property (strong, nonatomic)  NSString *repass;


-(IBAction)registerUser:(id)sender;
- (IBAction)LoginUser:(id)sender;

@end

@implementation ViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(150, 200, 195, 30)];
    self.usernameField.placeholder = @"username";
    [self.view addSubview:self.usernameField];
    
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(150, 250, 195, 30)];
    self.passwordField.placeholder = @"password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    
    self.reenterPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(150, 300, 195, 30)];
    self.reenterPasswordField.placeholder = @"reenter password";
    self.reenterPasswordField.secureTextEntry = YES;
    [self.view addSubview:self.reenterPasswordField];

    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(150, 350, 100, 30);
    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
     
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(150, 400, 100, 30);
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(LoginUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
     
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    _usernameoutput = _usernameField.text;
    _passoutput = _passwordField.text;
    _repass = _reenterPasswordField.text;
    
    if ([_usernameoutput isEqualToString:@""] || [_passoutput isEqualToString:@""]
        || [_repass isEqualToString:@""]) {
        //NSLog(@"Error, all fields must be filled in");
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"You must complete All fields"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        
        //[alert show];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        NSLog(@"%@", _usernameoutput);
        NSLog(@"%@", _passoutput);
        NSLog(@"%@", _repass);
        
    }
    else{
        [self checkPasswordsMatch];
        
    }
    
    
}

- (void) checkPasswordsMatch {
    if( [_passoutput isEqualToString:_repass]){
        NSLog(@"passwords mathc!");
        [self registerNewUser];
    }
    else{
        NSLog(@"passwords dont match!");
        NSLog(@"%@", _usernameoutput);
        NSLog(@"%@", _passoutput);
        NSLog(@"%@", _repass);
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"Passwords Dont Match"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void) registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_usernameoutput forKey:@"username"];
    [defaults setObject:_passoutput forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    //alert view for success
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Success"
                                 message:@"You are now registered!"
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"login" sender:self];
    
    
}

- (IBAction)LoginUser:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([_usernameoutput isEqualToString:[defaults objectForKey:@"username"]] &&
        [_passoutput isEqualToString:[defaults objectForKey:@"password"]]){
        NSLog(@"login creds accepted");
        _usernameField.text = nil;
        _passwordField.text = nil;
        _reenterPasswordField.text = nil;
        
        //_reenterPasswordField.hidden = YES;
        //_registerBtn.hidden = YES;
        
        //[self performSegueWithIdentifier:@"login" sender:self];
        
        
        // switch to list interface
        ListViewController *list = [[ListViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:list];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        

   
    }
            
        
        
    
    else{
        NSLog(@"login creds not accepted");
        
        //show pop up error
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"Login not recognized"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle your yes please button action here
                                   }];
        
        //[alert show];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



@end

