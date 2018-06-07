//
//  ViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 4/30/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"

@interface ViewController ()<RHWebServiceDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewContainerHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong,nonatomic) RHWebServiceManager *myWebserviceManager;
- (IBAction)skipButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *paswordTextfield;
- (IBAction)loginButtonAction:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textViewHeight.constant = self.introTextView.contentSize.height;
    [self.view setNeedsLayout];
    self.scrollviewContainerHeight.constant = self.loginButton.frame.origin.y + self.loginButton.frame.size.height + 16;
    [self.view setNeedsLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)skipButtonAction:(id)sender {
}

-(void) CallUserDetailsWebserviceWithUDID:(NSString *)ID forDeviceToken:(NSString *)deviceToken
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:self.emailTextfield.text,@"user_name",self.paswordTextfield.text,@"password",@"123456",@"ios_push_token",nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,Login_URL_API];
    self.myWebserviceManager = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeLogin Delegate:self];
    [self.myWebserviceManager getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",responseObj);
    [User_Details sharedInstance].membershipId = [responseObj valueForKey:@"ref_membership_details_login_id"];
    [User_Details sharedInstance].loginStatus = [responseObj valueForKey:@"login_status"];
    NSLog(@"%@",[User_Details sharedInstance].membershipId);
    if ([[responseObj valueForKey:@"membership_chat_disable"] isKindOfClass:[NSString class]]) {
        if ([[responseObj valueForKey:@"membership_chat_disable"] isEqualToString:@"1"]) {
            [User_Details sharedInstance].chatDisabled = YES;
        }
        else {
            [User_Details sharedInstance].chatDisabled = NO;
        }
    }
}

-(void) dataFromWebReceiptionFailed:(NSError*) error
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)loginButtonAction:(id)sender {
    [self CallUserDetailsWebserviceWithUDID:@"" forDeviceToken:@""];
}
@end
