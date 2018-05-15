//
//  NewsObject.h
//  Nicola
//
//  Created by Rafay Hasan on 15/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject

@property (strong,nonatomic) NSString *newsTitle, *newsImageUrlStr, *newsDateStr;
@property (strong,nonatomic) NSAttributedString *newsDetails;

@end
