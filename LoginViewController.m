//
//  ViewController.m
//  LoginNostoryboard
//
//  Created by Niall Caparon on 3/27/18.
//  Copyright © 2018 Niall Caparon. All rights reserved.
//

#import "LoginViewController.h"
#import "DBManager.h"
#import "ListViewController.h"
#import "INotesStorageManager.h"
#import "StorageUtility.h"
#import "HelpViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic)  UITextField *usernameField;
@property (strong, nonatomic)  UITextField *passwordField;
@property (strong, nonatomic)  UITextField *reenterPasswordField;

@property (strong, nonatomic)  UIButton *registerBtn;
@property (strong, nonatomic)  UIButton *loginBtn;

@property (strong, nonatomic)  NSString *usernameoutput;
@property (strong, nonatomic)  NSString *passoutput;
@property (strong, nonatomic)  NSString *repass;

@property (nonatomic, strong) DBManager *dbManager;

-(IBAction)registerUser:(id)sender;
- (IBAction)LoginUser:(id)sender;
- (void)checkExistingUserName;

@end

@implementation LoginViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Username Textfield
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(150, 200, 195, 30)];
    self.usernameField.placeholder = @"username";
    [self.view addSubview:self.usernameField];
    
    //Password Textfield
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(150, 250, 195, 30)];
    self.passwordField.placeholder = @"password";
    self.passwordField.secureTextEntry = YES;
    [self.view addSubview:self.passwordField];
    
    //Re-Enter Password Field
    self.reenterPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(150, 300, 195, 30)];
    self.reenterPasswordField.placeholder = @"reenter password";
    self.reenterPasswordField.secureTextEntry = YES;
    [self.view addSubview:self.reenterPasswordField];
    
    //Register Button
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(150, 350, 100, 30);
    [registerBtn setTitle:@"Register" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    
    //Login Button
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(150, 400, 100, 30);
    [loginBtn setTitle:@"Login" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(LoginUser:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    
    
    //help button
    UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    helpBtn.frame = CGRectMake(150, 550, 100, 30);
    [helpBtn setTitle:@"Help" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [helpBtn addTarget:self action:@selector(Help:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:helpBtn];
    
    
    //Intialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"notesAppDB2.sql"];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    
    //Check to see if all required fields have been filled out.
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]
        || [_reenterPasswordField.text isEqualToString:@""]) {
        
        //Show Alert that all required field have not been entered.
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"You must complete All fields"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        
        //[alert show];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
        //Use method to check and see if password matches re-enter password.
        //[self checkPasswordsMatch];
        
        //Check if username is avaliable
        [self checkExistingUserName];
        
    }
}

- (void) checkPasswordsMatch {
    //Check Passwords
    if( [_passwordField.text isEqualToString:_reenterPasswordField.text]){
        
        //Print to the log
        NSLog(@"passwords match!");
        //Now that we are sure passwords match, send to register new user.
        [self registerNewUser];
    }
    else{
        //Print to the log
        NSLog(@"passwords dont match!");
        
        //Alert the user that the password and re-enter password fields do not match
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"Passwords Dont Match"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void) registerNewUser {
    
    // Prepare the query string.
    NSString *query = [NSString stringWithFormat:@"insert into loginInfo values('%@', '%@')", _usernameField.text, _passwordField.text];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // Tell Log whether query was excuted or not
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    
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
    
    //_loginBtn.hidden = NO;
    
}



- (IBAction)LoginUser:(id)sender {
    
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""]){
        //show pop up error; Alert the user that login fields are not filled out
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"Login fields not filled out"
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
    else{
        
        // Create the query.
        NSString *query = [NSString stringWithFormat:@"select * from loginInfo where username='%@'", _usernameField.text];
        NSLog(@"%@",  query);
        
        // Load the relevant data.
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        NSLog(@"%@",  results);
        
        // Set the loaded data to the strings.
        NSString *usernameLoad = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"username"]];
        NSString *passwordLoad = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"password"]];
        
        //check to the log for correct data
        NSLog(@"%@", usernameLoad);
        NSLog(@"%@", passwordLoad);
        
        //Check to see if username and password provided by the user in the textfields
        //Matches the corresponding data loaded by the database
        if ([_usernameField.text isEqualToString:usernameLoad] && [_passwordField.text isEqualToString:passwordLoad]) {
            
            //Print to the console login is successful
            NSLog(@"login creds accepted");
            
            //Erase textfields
            _usernameField.text = nil;
            _passwordField.text = nil;
            _reenterPasswordField.text = nil;
            
            //_reenterPasswordField.hidden = YES;
            //_registerBtn.hidden = YES;
            
            // switch to list interface
            ListViewController *list = [[ListViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:list];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
            
        }
        
        else{
            //Print to the log no success
            NSLog(@"login creds not accepted");
            
            //show pop up error; Alert the user that login credentials are not correct
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
}

- (void)checkExistingUserName {
    
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from loginInfo where username='%@'", _usernameField.text];
    NSLog(@"%@",  query);
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"%@",  results);
    
    //Check Lenght of array
    int size = results.count;
    NSLog(@"%d",  size);
    
    //Return values based on whether username exists or not
    //[results containsObject: _usernameField.text]
    if(size != 0 ){
        //Show Alert that username entered already exists
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Ooops"
                                     message:@"That username already exists!"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        
        //[alert show];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else{
        
        //Use method to check and see if password matches re-enter password.
        [self checkPasswordsMatch];
        
    }
    
}

- (IBAction)Help:(id)sender {
    
    // switch to help interface
    HelpViewController *list = [[HelpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:list];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    
    
    
    
    
}




@end
