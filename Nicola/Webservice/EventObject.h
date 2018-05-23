//
//  EventObject.h
//  Nicola
//
//  Created by Rafay Hasan on 23/5/18.
//  Copyright © 2018 Rafay Hasan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObject : NSObject

@property (strong,nonatomic) NSString *eventTitle, *eventDetails, *eventLocation, *eventImageUrlStr, *eventStartTime, *eventEndTime, *eventDate;

@end
