//
//  JoinClubViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 7/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "JoinClubViewController.h"
#import "NotificationViewController.h"
#import "HomeViewController.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"

@interface JoinClubViewController ()
- (IBAction)navigationButtonAction:(UIButton *)sender;

@end

@implementation JoinClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)navigationButtonAction:(UIButton *)sender {
    if (sender.tag == 1001) {
        NotificationViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        if (![self isControllerAlreadyOnNavigationControllerStack:newView]) {
            [self.navigationController pushViewController:newView animated:YES];
            
        }
    }
    else if (sender.tag == 1002) {
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
@end
