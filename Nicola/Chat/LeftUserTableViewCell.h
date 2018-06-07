//
//  LeftUserTableViewCell.h
//  Nicola
//
//  Created by Rafay Hasan on 7/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageDateLabel;


@end
