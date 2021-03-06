//
//  ChatViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 5/28/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "ChatViewController.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "User Details.h"
#import "ChatObject.h"
#import "LeftUserTableViewCell.h"
#import "RightUserTableViewCell.h"
#import "NotificationViewController.h"
#import "HomeViewController.h"
#import "ProfileViewController.h"

@interface ChatViewController ()<RHWebServiceDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *chatTableview;
- (IBAction)messageSendButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
- (IBAction)navigationButtonAction:(UIButton *)sender;

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *chatMessageArray;
@property (strong,nonatomic) ChatObject *object;
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatMessageArray = [NSMutableArray new];
    self.chatTableview.estimatedRowHeight = 80;
    self.chatTableview.rowHeight = UITableViewAutomaticDimension;
    if ([User_Details sharedInstance].chatDisabled) {
        self.chatTextField.userInteractionEnabled = NO;
    }
    else {
        self.chatTextField.userInteractionEnabled = YES;
    }
    [self CallChatWebservice];
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

#pragma mark Chat Web service

-(void) CallMessageSendWebservice
{
    NSDictionary *postData = [NSDictionary dictionaryWithObjectsAndKeys:[User_Details sharedInstance].membershipId,@"ref_chat_membership_details_id",self.chatTextField.text,@"chat_message", nil];
    [SVProgressHUD show];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,SendMessage_URL_API];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeSendMessage Delegate:self];
    [self.myWebService getPostDataFromWebURLWithUrlString:urlStr dictionaryData:postData];
}

-(void) FetchNextChatHistory
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.chatMessageArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/%@",BASE_URL_API,ChatHistory_URL_API,[User_Details sharedInstance].membershipId,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeFetchNextChatHistory Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) CallChatWebservice
{
    [SVProgressHUD show];
    //NSString *startingLimit = [NSString stringWithFormat:@"%li",self.chatMessageArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@/0",BASE_URL_API,ChatHistory_URL_API,[User_Details sharedInstance].membershipId];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeChatHistory Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeChatHistory)
    {
        [self.chatMessageArray removeAllObjects];
        [self.chatMessageArray addObjectsFromArray:(NSArray *)responseObj];
        [self.chatTableview reloadData];
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: 0 inSection: self.chatMessageArray.count - 1];
        [self.chatTableview scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];

    }
    else if (self.myWebService.requestType == HTTPRequestypeSendMessage) {
        self.chatTextField.text = @"";
        NSLog(@"%@",responseObj);
        [self CallChatWebservice];
        
    }
    else if (self.myWebService.requestType == HTTPRequestypeFetchNextChatHistory) {
        NSArray *tempArray = (NSArray *)responseObj;
        for (NSInteger i = tempArray.count - 1; i >=0;i--) {
            [self.chatMessageArray insertObject:[tempArray objectAtIndex:i] atIndex:0];
        }
        [self.chatTableview reloadData];
        
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if (scrollView.contentOffset.y < 0) {
        NSLog(@"scrolled on top");
        [self FetchNextChatHistory];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chatMessageArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.object = [self.chatMessageArray objectAtIndex:indexPath.section];
    if (self.object.chatFromAdmin) {
        LeftUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftUser" forIndexPath:indexPath];
        cell.messageLabel.text = self.object.chatMessage;
        cell.messageDateLabel.text = self.object.chatTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        RightUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightUser" forIndexPath:indexPath];
        cell.messgLabel.text = self.object.chatMessage;
        cell.messageDateLabel.text = self.object.chatTime;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
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


- (IBAction)messageSendButtonAction:(id)sender {
    if(self.chatTextField.text.length > 0) {
        [self CallMessageSendWebservice];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Message", Nil) message:@"Please enter some message" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
