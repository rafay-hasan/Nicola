//
//  RightUserTableViewCell.m
//  Nicola
//
//  Created by Rafay Hasan on 7/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "RightUserTableViewCell.h"

@implementation RightUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
