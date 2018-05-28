//
//  AwardHistoryViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 28/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "AwardHistoryViewController.h"
#import "MXParallaxHeader.h"
#import "RHWebServiceManager.h"
#import "SVProgressHUD.h"
#import "AwardHistory.h"
#import "NewsHeader.h"
#import "AwardCollectionViewCell.h"
#import "AwardHistoryDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AwardHistoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,RHWebServiceDelegate>

@property (strong,nonatomic) RHWebServiceManager *myWebService;
@property (strong,nonatomic) NSMutableArray *awardArray;
@property (strong,nonatomic) AwardHistory *awardObject;
@property (strong,nonatomic) NewsHeader *myHeaderView;

@property (weak, nonatomic) IBOutlet UICollectionView *awardCollectionview;
- (IBAction)homeButtonAction:(id)sender;

@end

@implementation AwardHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NewsHeader" owner:self options:nil] objectAtIndex:0];
    self.awardCollectionview.parallaxHeader.view = self.myHeaderView;
    self.awardCollectionview.parallaxHeader.height = 263;
    self.awardCollectionview.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.awardCollectionview.parallaxHeader.minimumHeight = 240;
    
    self.myHeaderView.titleLabel.text = @"La hall of fame";
    self.myHeaderView.bannerImageview.image = [UIImage imageNamed:@"award_banner"];
    self.awardArray = [NSMutableArray new];
    [self CallAwardHistoryWebservice];
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

-(void) CallAwardHistoryWebservice
{
    [SVProgressHUD show];
    NSString *startingLimit = [NSString stringWithFormat:@"%li",self.awardArray.count];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,AwardHistory_URL_API,startingLimit];
    self.myWebService = [[RHWebServiceManager alloc]initWebserviceWithRequestType:HTTPRequestypeAwardHistory Delegate:self];
    [self.myWebService getDataFromWebURLWithUrlString:urlStr];
}

-(void) dataFromWebReceivedSuccessfully:(id) responseObj
{
    [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
    if(self.myWebService.requestType == HTTPRequestypeAwardHistory)
    {
        [self.awardArray addObjectsFromArray:(NSArray *)responseObj];
        
    }
    [self.awardCollectionview reloadData];
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
        
        [self CallAwardHistoryWebservice];
        
    }
}

#pragma mark - Collectionview datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.awardArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"awardCell";
    
    AwardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    self.awardObject = [self.awardArray objectAtIndex:indexPath.row];
    cell.awardTitleLabel.text = self.awardObject.awardTitle;
    cell.awardDetailsLabel.text = self.awardObject.awardDetails;
    if (self.awardObject.awardCoverPhotoUrlString.length > 0) {
        [cell.wardImageview sd_setImageWithURL:[NSURL URLWithString:self.awardObject.awardCoverPhotoUrlString]
                              placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    else {
        cell.wardImageview.image = nil;
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.awardObject = [self.awardArray objectAtIndex:indexPath.row];
    AwardHistoryDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"awardDetails"];
    vc.object = self.awardObject;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //return CGSizeMake(120.0, 120.0);
    
    switch ((int)[[UIScreen mainScreen] nativeBounds].size.height) {
            
        case 1136:
            printf("iPhone 5 or 5S or 5C");
            return CGSizeMake(150.0, 175.0);
            break;
        case 1334:
            printf("iPhone 6/6S/7/8");
            return CGSizeMake(170.0, 185.0);
            break;
        case 2208:
            printf("iPhone 6+/6S+/7+/8+");
            return CGSizeMake(180.0, 195.0);
            break;
        case 2436:
            printf("iPhone X");
            return CGSizeMake(180.0, 195.0);
            break;
        default:
            printf("unknown");
            return CGSizeMake(180.0, 195.0);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0;
}


- (IBAction)homeButtonAction:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

@end
