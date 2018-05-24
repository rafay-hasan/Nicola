//
//  ClubHistoryTableViewCell.h
//  Nicola
//
//  Created by Rafay Hasan on 24/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIWebView *historyWebview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webviewHeight;

@end
