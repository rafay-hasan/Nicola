//
//  HomeTableViewCell.m
//  Nicola
//
//  Created by Rafay Hasan on 8/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.chatMarkerView.layer.masksToBounds = YES;
    self.chatMarkerView.layer.cornerRadius = self.chatMarkerView.frame.size.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
