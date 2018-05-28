//
//  AwardCollectionViewCell.h
//  Nicola
//
//  Created by Rafay Hasan on 28/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *wardImageview;
@property (weak, nonatomic) IBOutlet UILabel *awardTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *awardDetailsLabel;

@end
