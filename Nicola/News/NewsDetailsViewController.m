//
//  NewsDetailsViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 15/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "NewsDetailsTableViewCell.h"
#import "MXParallaxHeader.h"
#import "NewsHeader.h"

@interface NewsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NewsHeader *myHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *newsDetailsTableview;
- (IBAction)homeButtonAction:(id)sender;

@end

@implementation NewsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"NewsHeader" owner:self options:nil] objectAtIndex:0];
    self.newsDetailsTableview.parallaxHeader.view = self.myHeaderView;
    self.newsDetailsTableview.parallaxHeader.height = 263;
    self.newsDetailsTableview.parallaxHeader.mode = MXParallaxHeaderModeFill;
    self.newsDetailsTableview.parallaxHeader.minimumHeight = 240;
    self.myHeaderView.titleLabel.text = @"La ultime  notizie";
    self.myHeaderView.bannerImageview.image = [UIImage imageNamed:@"news_pic"];
    self.newsDetailsTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    NewsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsDetails" forIndexPath:indexPath];
    cell.titleLabel.text = self.object.newsTitle;
    cell.detailsLabel.text = self.object.newsDetailsString;
    cell.dateLabel.text = self.object.newsDateStr;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (IBAction)homeButtonAction:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
@end
