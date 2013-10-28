//
//  ViewController.h
//  PccuAutoWiFiLogin
//
//  Created by FrankWu on 13/3/4.
//  Copyright (c) 2013年 FrankWu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController<UITextFieldDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    int expectedLength;
    int currentLength;
    
    NSString *theSSID;
    NSString *thePostUrl;
    NSString *thePostData;
    
    NSMutableData *m_data;
}
- (IBAction)selectButton:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *wifiSSIDLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *doneToolbar;

@property (strong, nonatomic) IBOutlet UITextField *accountField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (retain, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButton:(id)sender;
- (IBAction)recheckSSID:(id)sender;

- (void)setAccount:(NSString *) theAccount andPassword:(NSString *) thePassword;
@end