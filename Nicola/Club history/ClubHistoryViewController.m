//
//  ClubHistoryViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 23/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ClubHistoryViewController.h"
#import "MXParallaxHeader.h"
#import "NewsHeader.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "ClubHistoryTableViewCell.h"
#import "NotificationViewController.h"
#import "HomeViewController.h"
#import "ChatViewController.h"
#import "ProfileViewController.h"

@interface ClubHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,RHWebServiceDelegate,UIWebViewDelegate>

@property (strong,nonatomic) NewsHeader *myHeaderView;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSArray *clubHistoryArray;
@property (nonatomic) NSInteger contentHeight;
@property (weak, nonatomic) IBOutlet UITableView *clubhistoryTableview;

- (IBAction)navigationButtonAction:(UIButton *)sender;

@end

@implementation ClubHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NewsHeader" owner:self options:nil] objectAtIndex:0];
    self.clubhistoryTableview.parallaxHeader.view = self.myHeaderView;
    self.clubhistoryTableview.parallaxHeader.height = 263;
    self.clubhistoryTableview.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.clubhistoryTableview.parallaxHeader.minimumHeight = 240;
    self.clubhistoryTableview.estimatedRowHeight = 215;
    self.clubhistoryTableview.rowHeight = UITableViewAutomaticDimension;
    
    self.contentHeight = 0;
    self.myHeaderView.titleLabel.text = @"";
    self.myHeaderView.bannerImageview.image = [UIImage imageNamed:@"storia"];
    [self CallClubHistoryWebservice];
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

#pragma mark All Web service

-(void) CallClubHistoryWebservice
{
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,ClubHistory_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeClubHistory Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeClubHistory)
    {
        self.clubHistoryArray = [(NSArray *)responseObj valueForKey:@"json_value"];
        self.myHeaderView.titleLabel.text = [[self.clubHistoryArray objectAtIndex:0] valueForKey:@"club_name"];
    }
    NSLog(@"%@",[[self.clubHistoryArray objectAtIndex:0] valueForKey:@"club_details"]);
    [self.clubhistoryTableview reloadData];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
    if (self.contentHeight == 0) {
        cell.historyWebview.opaque = NO;
        cell.historyWebview.backgroundColor =  [UIColor clearColor];
        NSString *detailsWebStrstr = [NSString stringWithFormat:@"<div style='font-family:Helvetica Neue;color:#000000;'>%@",[[self.clubHistoryArray objectAtIndex:0] valueForKey:@"club_details"]];
        [cell.historyWebview loadHTMLString:[NSString stringWithFormat:@"<style type='text/css'>img { display: inline;height: auto;max-width: 100%%; } a {color: #0091d2;} </style>%@",detailsWebStrstr] baseURL:nil];
        cell.historyWebview.delegate = self;
        cell.historyWebview.scrollView.scrollEnabled = NO;
    }
    else {
        cell.webviewHeight.constant = self.contentHeight;
        [self.clubhistoryTableview setNeedsLayout];
    }
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

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    self.contentHeight = aWebView.scrollView.contentSize.height;
    [self.clubhistoryTableview reloadData];
   // [self.clubhistoryTableview endUpdates];
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
