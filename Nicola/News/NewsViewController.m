//
//  NewsViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 15/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "NewsHeader.h"
#import "MXParallaxHeader.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "NewsObject.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewsDetailsViewController.h"

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,RHWebServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *newsTableview;
@property (strong,nonatomic) NewsHeader *myHeaderView;

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NewsObject *newsObject;
@property (strong,nonatomic) NSMutableArray *newsArray;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NewsHeader" owner:self options:nil] objectAtIndex:0];
    self.newsTableview.parallaxHeader.view = self.myHeaderView;
    self.newsTableview.parallaxHeader.height = 263;
    self.newsTableview.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.newsTableview.parallaxHeader.minimumHeight = 240;
    self.newsArray = [NSMutableArray new];
    [self CallNewsWebservice];
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

-(void) CallNewsWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.newsArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,News_URL_API,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeNews Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeNews)
    {
        [self.newsArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.newsTableview reloadData];
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
        
        [self CallNewsWebservice];
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.newsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    self.newsObject = [self.newsArray objectAtIndex:indexPath.row];
    cell.newsTitle.text = self.newsObject.newsTitle;
    cell.newsDetails.attributedText = self.newsObject.newsDetails;
    cell.newsCreationDate.text = self.newsObject.newsDateStr;
    if (self.newsObject.newsImageUrlStr.length > 0) {
        [cell.newsImageView sd_setImageWithURL:[NSURL URLWithString:self.newsObject.newsImageUrlStr]
                              placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.newsImageView.image = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.newsObject = [self.newsArray objectAtIndex:indexPath.row];
    NewsDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"newsDetails"];
    vc.object = self.newsObject;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
