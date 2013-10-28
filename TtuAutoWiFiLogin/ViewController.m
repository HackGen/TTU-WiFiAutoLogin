//
//  ViewController.m
//  PccuAutoWiFiLogin
//
//  Created by FrankWu on 13/3/4.
//  Copyright (c) 2013年 FrankWu. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize wifiSSIDLabel;
@synthesize doneToolbar;
@synthesize accountField;
@synthesize passwordField;
@synthesize loginButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    
    //config - START
    theSSID = @"ttuweb";
    thePostUrl = @"https://securelogin.arubanetworks.com/cgi-bin/login";
    thePostData = @"user=%@&password=%@&cmd=authenticate&Login=Log+In";
    //%@[1] <- account
    //%@[2] <- password
    
    //config - END
    
    
    //Check WiFi and SSID - START
    if ([[self currentWifiSSID] isEqualToString:theSSID]) {
        
    }
    //Check WiFi and SSID - END
    
    //初始化 - START
    accountField.inputAccessoryView = doneToolbar;
    accountField.delegate = self;
    passwordField.inputAccessoryView = doneToolbar;
    passwordField.delegate = self;
    //初始化 - END
    
    //Load Setting - START
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSString *theAccount = [defs stringForKey:@"account_preference"];
    NSString *thePassword = [defs stringForKey:@"password_preference"];
    
    if (theAccount.length != 0 && thePassword.length != 0) {
        [self setAccount:theAccount andPassword:thePassword];
    }
    else
    {
        [defs setObject:@"" forKey:@"account_preference"];
        [defs setObject:@"" forKey:@"password_preference"];
    }
    //Load Setting - END
    
    //NSLog(@"account_preference: %@", theAccount);
    //NSLog(@"password_preference: %@", thePassword);
}

- (NSDictionary *) fetchSSIDInfo  //- (id) fetchSSIDInfo
{
    NSArray *ifs = (id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    NSDictionary *info = nil;
    //id info = nil;
    for (NSString *ifnam in ifs) {
        info = (id)CNCopyCurrentNetworkInfo((CFStringRef)ifnam);
        NSLog(@"%s: %@ => %@", __func__, ifnam, info);
        if (info && [info count]) {
            break;
        }
        [info release];
    }
    [ifs release];
    return [info autorelease];
}

- (NSString *) currentWifiSSID
{
    NSDictionary *theWiFiInfo = [self fetchSSIDInfo];
    NSString *theWiFiName = theWiFiInfo[@"SSID"];
    NSLog(@"WiFi SSID => %@", theWiFiName);
    
    if (theWiFiName) {
        [wifiSSIDLabel setText:theWiFiName];
    }
    else {
        [wifiSSIDLabel setText:@"not found"];
    }
    
    if (theWiFiInfo) {
        if (![theWiFiName isEqualToString:theSSID]) {
            NSLog(@"!!!! Thw WiFi SSID is not \"%@\" !!!!" , theSSID);
        }
        else {
            NSLog(@"---- Thw WiFi SSID is \"%@\" ----", theSSID);
        }
    }
    else
    {
        NSLog(@"!!!! The wireless network is not connected !!!!");
    }
    //[theWiFiInfo release];
    return theWiFiName;
}

- (IBAction)recheckSSID:(id)sender
{
    [wifiSSIDLabel setText:@"checking..."];
    [self currentWifiSSID];
//    if ([[self currentWifiSSID] isEqualToString:@"pccu"]) {
//        
//    }
}


- (void)viewDidAppear:(BOOL)animated
{
    //[self logout];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSInteger row = [selectPicker selectedRowInComponent:0];
    //self.typeField.text = [[pickerArray objectAtIndex:row] substringFromIndex:2];
    //typeID = row + 37;
}
- (IBAction)selectButton:(id)sender
{
    [accountField endEditing:YES];
    [passwordField endEditing:YES];
}

- (void)setAllFieldAndButtonInteractionEnabled:(BOOL)enabled {
    //[buttonGetDataFromWebService setEnabled:NO];
    [accountField setUserInteractionEnabled:enabled];
    [passwordField setUserInteractionEnabled:enabled];
    [loginButton setUserInteractionEnabled:enabled];;
    
    if (enabled)
    {
        //[logActivity stopAnimating];
        
        [HUD hide:YES];
    
    }
    else
    {
        //[logActivity startAnimating];
    }
}

- (IBAction)loginButton:(id)sender
{
    [self currentWifiSSID];
    
    HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES] retain];
	//HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = @"登入中";
    HUD.minSize = CGSizeMake(110.f, 110.f);
    
    //[HUD showWhileExecuting:@selector(myHUDTask) onTarget:self withObject:nil animated:YES];
        
    [self setAllFieldAndButtonInteractionEnabled:NO];
    
    if ([accountField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                        message:[NSString stringWithFormat:@"請輸入您的 ID."]
                                                       delegate:self
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self setAllFieldAndButtonInteractionEnabled:YES];
        [accountField becomeFirstResponder];
    }
    else if ([passwordField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                        message:[NSString stringWithFormat:@"請輸入您的 Password."]
                                                       delegate:self
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self setAllFieldAndButtonInteractionEnabled:YES];
        [passwordField becomeFirstResponder];
    }
    else {
        [accountField resignFirstResponder];
        [passwordField resignFirstResponder];
        
        [self login];
    }
}

- (void)login
{    
    NSString *theAccount = accountField.text;
    NSString *thePassword = passwordField.text;
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:theAccount forKey:@"account_preference"];
    [defs setObject:thePassword forKey:@"password_preference"];
    
    NSString *postData = [[NSString alloc] initWithFormat:thePostData, theAccount, thePassword];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:thePostUrl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody: [postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:10];
    
    //[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (connection) {
        m_data = [[NSMutableData data] retain];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"連線失敗"
                                                            message:@"無法建立連線"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        
        [self setAllFieldAndButtonInteractionEnabled:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"接收到回應");
    [m_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"下載中");
    [m_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseString = [[NSString alloc] initWithData:m_data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    
    [HUD hide:YES];
    
    [m_data release];
    [connection release];
    
    [self setAllFieldAndButtonInteractionEnabled:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [HUD hide:YES];
    // 下載錯誤
    
    NSString *errorMsg = [[NSString alloc] initWithFormat:@"Connection failed: \n%@",[error description]];
    NSLog(@"%@", errorMsg);
    /*
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"連線失敗"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    //[alertView show];
    //[alertView release];
     */
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        
    if (error.code == NSURLErrorTimedOut) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"連線失敗"
                                                        message:[NSString stringWithFormat:@"請確定您所連線的Wifi為%@.", theSSID]
                                                       delegate:self
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (error.code == NSURLErrorNotConnectedToInternet) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                        message:[NSString stringWithFormat:@"無法建立連線"]
                                                       delegate:self
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if (error.code == -1003) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"錯誤"
                                                        message:[NSString stringWithFormat:@"找無登入伺服器\r\n請確定您所連線的Wifi為%@.", theSSID]
                                                       delegate:self
                                              cancelButtonTitle:@"確定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self setAllFieldAndButtonInteractionEnabled:YES];
}

- (void)dealloc {
    [wifiSSIDLabel release];
    [loginButton release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setWifiSSIDLabel:nil];
    [super viewDidUnload];
}

- (void)setAccount:(NSString *) theAccount andPassword:(NSString *) thePassword {
    [accountField setText:theAccount];
    [passwordField setText:thePassword];
    
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    [defs setObject:theAccount forKey:@"account_preference"];
    [defs setObject:thePassword forKey:@"password_preference"];
}

@end
