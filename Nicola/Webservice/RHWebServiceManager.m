//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
#import "NewsObject.h"
#import "EventObject.h"
#import "AwardHistory.h"
#import "ChatObject.h"
@implementation RHWebServiceManager


-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del
{
    if (self=[super init])
    {
        self.delegate = del;
        self.requestType = reqType;
    }
    
    return self;
}

-(void)getDataFromWebURLWithUrlString:(NSString *)requestURL
{
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            if(self.requestType == HTTPRequestypeNews)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllNewsItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestypeEvent)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllEventsItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestypeAwardHistory)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllAwardHistoryItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestypeChatHistory)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllChatHistoryItems:responseObject]];
                }
            }
            else {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                }
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            //DebugLog(@"Object conforms this protocol.");
            if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
            {
                // DebugLog(@"Object responds to this selector.");
                [self.delegate dataFromWebReceiptionFailed:error];
            }
            else
            {
                //DebugLog(@"Object Doesn't respond to this selector.");
            }
        }
    }];
}

-(void)getPostDataFromWebURLWithUrlString:(NSString *)requestURL dictionaryData:(NSDictionary *)postDataDic
{
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
    [manager POST:requestURL parameters:postDataDic progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            if(self.requestType == HTTPRequestypeLogin || self.requestType == HTTPRequestypeSendMessage)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {

                    [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                }
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            //DebugLog(@"Object conforms this protocol.");
            if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
            {
                // DebugLog(@"Object responds to this selector.");
                [self.delegate dataFromWebReceiptionFailed:error];
            }
            else
            {
                //DebugLog(@"Object Doesn't respond to this selector.");
            }
        }
    }];
}



-(NSMutableArray *) parseAllNewsItems :(id) response
{
    NSMutableArray *NewsItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"json_value"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"json_value"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            NewsObject *object = [NewsObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_title"] isKindOfClass:[NSString class]])
            {
                object.newsTitle = [[tempArray objectAtIndex:i] valueForKey:@"news_title"];
            }
            else
            {
                object.newsTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_description"] isKindOfClass:[NSString class]])
            {
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[[[tempArray objectAtIndex:i] valueForKey:@"news_description"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
                object.newsDetailsString = [attr string];
            }
            else
            {
                object.newsDetailsString = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_created_edited_date_time"] isKindOfClass:[NSString class]])
            {
                object.newsDateStr = [[tempArray objectAtIndex:i] valueForKey:@"news_created_edited_date_time"];
            }
            else
            {
                object.newsDateStr = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_image_location"] isKindOfClass:[NSString class]])
            {
                object.newsImageUrlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"news_image_location"]];
            }
            else
            {
                object.newsImageUrlStr = @"";
            }
            
            [NewsItemsArray addObject:object];
        }
 
    }
    return NewsItemsArray;

}

-(NSMutableArray *) parseAllAwardHistoryItems :(id) response
{
    NSMutableArray *awardItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"json_value"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"json_value"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            AwardHistory *object = [AwardHistory new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"award_history_title"] isKindOfClass:[NSString class]])
            {
                object.awardTitle = [[tempArray objectAtIndex:i] valueForKey:@"award_history_title"];
            }
            else
            {
                object.awardTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"award_history_details"] isKindOfClass:[NSString class]])
            {
                NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[[[tempArray objectAtIndex:i] valueForKey:@"award_history_details"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                      NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                                 documentAttributes:nil
                                                                              error:nil];
                object.awardDetails = [attr string];
            }
            else
            {
                object.awardDetails = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"award_history_images_path"] isKindOfClass:[NSString class]])
            {
                object.awardHistoryImageUrlString = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"award_history_images_path"]];
            }
            else
            {
                object.awardHistoryImageUrlString = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"award_history_cover_photo_path"] isKindOfClass:[NSString class]])
            {
                object.awardCoverPhotoUrlString = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"award_history_cover_photo_path"]];
            }
            else
            {
                object.awardCoverPhotoUrlString = @"";
            }
            
            [awardItemsArray addObject:object];
        }

    }
    
    return awardItemsArray;
    
}

-(NSMutableArray *) parseAllChatHistoryItems :(id) response
{
    NSMutableArray *chatItemsArray = [NSMutableArray new];
    
    NSArray *tempArray = (NSArray *)response;
    
    for(NSInteger i = 0; i < tempArray.count; i++)
    {
        ChatObject *object = [ChatObject new];
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"chat_message"] isKindOfClass:[NSString class]])
        {
            object.chatMessage = [[tempArray objectAtIndex:i] valueForKey:@"chat_message"];
        }
        else
        {
            object.chatMessage = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"chat_message_sending_edited_date_time"] isKindOfClass:[NSString class]])
        {
            object.chatTime = [[tempArray objectAtIndex:i] valueForKey:@"chat_message_sending_edited_date_time"];
        }
        else
        {
            object.chatTime = @"";
        }
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"chat_from_admin"] isKindOfClass:[NSString class]])
        {
            if ([[[tempArray objectAtIndex:i] valueForKey:@"chat_from_admin"] isEqualToString:@"1"]) {
                
                object.chatFromAdmin = YES;
            }
            else {
                object.chatFromAdmin = NO;
            }
        }
        else
        {
            object.chatFromAdmin = NO;
        }
        [chatItemsArray addObject:object];
    }
    
    return chatItemsArray;
    
}



-(NSMutableArray *) parseAllEventsItems :(id) response
{
    NSMutableArray *EventsItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"json_value"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"json_value"];
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            EventObject *object = [EventObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_title"] isKindOfClass:[NSString class]])
            {
                object.eventTitle = [[tempArray objectAtIndex:i] valueForKey:@"events_race_title"];
            }
            else
            {
                object.eventTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_details"] isKindOfClass:[NSString class]])
            {
                object.eventDetails = [[tempArray objectAtIndex:i] valueForKey:@"events_race_details"];
            }
            else
            {
                object.eventDetails = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_location"] isKindOfClass:[NSString class]])
            {
                object.eventLocation = [[tempArray objectAtIndex:i] valueForKey:@"events_race_location"];
            }
            else
            {
                object.eventLocation = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_cover_photo_path"] isKindOfClass:[NSString class]])
            {
                object.eventImageUrlStr = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"events_race_cover_photo_path"]];
            }
            else
            {
                object.eventImageUrlStr = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_starting_time"] isKindOfClass:[NSString class]])
            {
                object.eventStartTime = [[tempArray objectAtIndex:i] valueForKey:@"events_race_starting_time"];
            }
            else
            {
                object.eventStartTime = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_ending_time"] isKindOfClass:[NSString class]])
            {
                object.eventEndTime = [[tempArray objectAtIndex:i] valueForKey:@"events_race_ending_time"];
            }
            else
            {
                object.eventEndTime = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_race_starting_date"] isKindOfClass:[NSString class]])
            {
                object.eventDate = [[tempArray objectAtIndex:i] valueForKey:@"events_race_starting_date"];
            }
            else
            {
                object.eventDate = @"";
            }
            
            [EventsItemsArray addObject:object];
        }
        
    }
    return EventsItemsArray;
    
}

@end
