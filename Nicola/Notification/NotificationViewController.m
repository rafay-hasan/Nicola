//
//  NotificationViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 7/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "NotificationViewController.h"
#import "HomeViewController.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"
#import "SVProgressHUD.h"

@interface NotificationViewController ()<UIWebViewDelegate>

- (IBAction)navigationButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *notificationWebview;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebview];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
    self.view.userInteractionEnabled = NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}

-(void) loadWebview {
    NSString *urlString = @"http://bulegas.whatsupitec.com/webview_notification";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.notificationWebview loadRequest:urlRequest];
}

- (IBAction)navigationButtonAction:(UIButton *)sender {
   
    if (sender.tag == 1002) {
        HomeViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"home"];
        if (![self isControllerAlreadyOnNavigationControllerStack:newView]) {
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if (sender.tag == 1003) {
        ChatViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
        if (![self isControllerAlreadyOnNavigationControllerStack:newView]) {
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if (sender.tag == 1004) {
        ProfileViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"profile"];
        if (![self isControllerAlreadyOnNavigationControllerStack:newView]) {
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
}

-(BOOL)isControllerAlreadyOnNavigationControllerStack:(UIViewController *)targetViewController{
    // MainViewController *mainViewController = [MainViewController new];
    //UINavigationController *nav = (UINavigationController *) mainViewController.rootViewController;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:targetViewController.class]) {
            [self.navigationController popToViewController:vc animated:NO];
            return YES;
        }
    }
    return NO;
}

@end
