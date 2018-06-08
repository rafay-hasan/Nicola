//
//  EventDetailsViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 23/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventDetailsTableViewCell.h"
#import "MXParallaxHeader.h"
#import "NewsHeader.h"
#import "HomeViewController.h"
#import "NotificationViewController.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"
@interface EventDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *eventDetailsTableview;
- (IBAction)navigationButtonAction:(UIButton *)sender;

@property (strong,nonatomic) NewsHeader *myHeaderView;

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NewsHeader" owner:self options:nil] objectAtIndex:0];
    self.eventDetailsTableview.parallaxHeader.view = self.myHeaderView;
    self.eventDetailsTableview.parallaxHeader.height = 263;
    self.eventDetailsTableview.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.eventDetailsTableview.parallaxHeader.minimumHeight = 240;
    self.eventDetailsTableview.estimatedRowHeight = 215;
    self.eventDetailsTableview.rowHeight = UITableViewAutomaticDimension;
    
    self.myHeaderView.titleLabel.text = @"Le prossime gare ed eventi";
    self.myHeaderView.bannerImageview.image = [UIImage imageNamed:@"news_pic"];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventDetailsCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.object.eventTitle;
    cell.detailsLabel.text = self.object.eventDetails;
    cell.locationLabel.text = self.object.eventLocation;
    cell.startDateLabel.text = self.object.eventStartTime;
    cell.endDateLabel.text = self.object.eventEndTime;
    cell.timeLabel.text = self.object.eventDate;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
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
