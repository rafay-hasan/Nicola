//
//  AwardHistoryDetailsViewController.m
//  Nicola
//
//  Created by Rafay Hasan on 5/28/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "AwardHistoryDetailsViewController.h"
#import "KASlideShow.h"
#import "AwardDetailsTableViewCell.h"

@interface AwardHistoryDetailsViewController ()<KASlideShowDelegate,KASlideShowDataSource,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * _datasource;
}
@property (weak, nonatomic) IBOutlet KASlideShow *slideShow;
- (IBAction)homeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *awardDetailsTableview;

@end

@implementation AwardHistoryDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.slideShow.datasource = self;
    self.slideShow.delegate = self;
    [self.slideShow setDelay:2]; // Delay between transitions
    [self.slideShow setTransitionDuration:1]; // Transition duration
    [self.slideShow setTransitionType:KASlideShowTransitionFade]; // Choose a transition type (fade or slide)
    [self.slideShow setImagesContentMode:UIViewContentModeScaleAspectFill]; // Choose a content mode for images to display
    [self.slideShow addGesture:KASlideShowGestureTap]; // Gesture to go previous/next directly on the image
    
    _datasource = [@[[NSURL URLWithString:self.object.awardCoverPhotoUrlString],
                     [NSURL URLWithString:self.object.awardHistoryImageUrlString]] mutableCopy];
    self.awardDetailsTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.slideShow start];
    
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

#pragma mark - KASlideShow datasource

- (NSObject *)slideShow:(KASlideShow *)slideShow objectAtIndex:(NSUInteger)index
{
    return _datasource[index];
}

- (NSUInteger)slideShowImagesNumber:(KASlideShow *)slideShow
{
    return _datasource.count;
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
    AwardDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"awardDetailsCell" forIndexPath:indexPath];
    cell.awardNameLabel.text = self.object.awardTitle;
    cell.awardDetailsLabel.text = self.object.awardDetails;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}


- (IBAction)homeButtonAction:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
@end
