//
//  NewsTableViewCell.h
//  Nicola
//
//  Created by Rafay Hasan on 15/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsCreationDate;

@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsDetails;

@end
