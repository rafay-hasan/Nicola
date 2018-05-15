//
//  NewsDetailsTableViewCell.h
//  Nicola
//
//  Created by Rafay Hasan on 15/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;


@end
