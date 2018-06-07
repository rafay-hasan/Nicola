//
//  ChatObject.h
//  Nicola
//
//  Created by Rafay Hasan on 7/6/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatObject : NSObject
@property (strong,nonatomic) NSString *chatMessage,*chatTime;
@property (nonatomic) BOOL chatFromAdmin;

@end
