//
//  HomeViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 10/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "EventViewController.h"
#import "ClubHistoryViewController.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSArray *menuArray;
@property (weak, nonatomic) IBOutlet UITableView *menuTableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTableheight;
- (IBAction)menuButtonAction:(id)sender;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.menuArray = [[NSArray alloc]initWithObjects:@"la storia del club",@"li ultime notizie",@"li prossime gare ed eventi;",@"la hall of fame",@"Iscriviti al club",@"chat",@"profilo", nil];
    self.menuTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    return self.menuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor colorWithRed:250.0/255.0 green:228.0/255.0 blue:3.0/255.0 alpha:1];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ClubHistoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"history"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        NewsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"news"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        EventViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"event"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:250.0/255.0 green:228.0/255.0 blue:3.0/255.0 alpha:1];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:250.0/255.0 green:228.0/255.0 blue:3.0/255.0 alpha:1];
    return footerView;
}

- (IBAction)menuButtonAction:(id)sender {
    
    if (self.menuTableheight.constant == 0) {
//        [UIView animateWithDuration:0.9f animations:^{
//            self.menuTableheight.constant = self.menuTableview.contentSize.height;
//            [self.view setNeedsLayout];
//        }];
        [UIView transitionWithView:self.menuTableview
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.menuTableheight.constant = self.menuTableview.contentSize.height;
                        }
                        completion:NULL];
    }
    else {
//        [UIView animateWithDuration:0.9f animations:^{
//            self.menuTableheight.constant = 0;
//            [self.view setNeedsLayout];
//        }];
        [UIView transitionWithView:self.menuTableview
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.menuTableheight.constant = 0;
                        }
                        completion:NULL];
    }
    
}
@end
