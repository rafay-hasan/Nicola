//
//  EventViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 23/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "EventViewController.h"
#import "EventTableViewCell.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "EventObject.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface EventViewController ()<UITableViewDelegate,UITableViewDataSource,RHWebServiceDelegate>
@property (strong,nonatomic) NSMutableArray *eventArray;
@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) EventObject *eventObject;
@property (weak, nonatomic) IBOutlet UITableView *eventTableview;
- (IBAction)homeButtonAction:(id)sender;


@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.eventTableview.estimatedRowHeight = 120;
    //self.eventTableview.rowHeight = UITableViewAutomaticDimension;
    self.eventTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self CallEventWebservice];
    self.eventArray = [NSMutableArray new];
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

-(void) CallEventWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.eventArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,Events_URL_API,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeEvent Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeEvent)
    {
        [self.eventArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.eventTableview reloadData];
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


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40) {
        
        [self CallEventWebservice];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.eventArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
    self.eventObject = [self.eventArray objectAtIndex:indexPath.section];
    cell.eventTitleLabel.text = self.eventObject.eventTitle;
    cell.eventDescriptionLabel.text = self.eventObject.eventDetails;
    cell.eventLocationLabel.text = self.eventObject.eventLocation;
    cell.startDateLabel.text = self.eventObject.eventStartTime;
    cell.endDateLabel.text = self.eventObject.eventEndTime;
    if (self.eventObject.eventImageUrlStr.length > 0) {
        [cell.eventImageview sd_setImageWithURL:[NSURL URLWithString:self.eventObject.eventImageUrlStr]
                              placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.eventImageview.image = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:136.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1];
    return footerView;
}




- (IBAction)homeButtonAction:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
@end
