//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
#import "NewsObject.h"

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
//            if(self.requestType == HTTPRequestypeUserDetails)
//            {
//                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                {
//
//                    [self.delegate dataFromWebReceivedSuccessfully:responseObject];
//                }
//            }
//            else if(self.requestType == HTTPRequestTypePharmacySearch || self.requestType == HTTPRequestTypePharmacySearchForCurrentLocation)
//            {
//                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                {
//
//                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllPharmacyItems:responseObject]];
//                }
//            }
//            else if(self.requestType == HTTPRequestTypeProductSearch)
//            {
//                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                {
//
//                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllProducts:responseObject]];
//                }
//            }
//            else {
//                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                {
//                    [self.delegate dataFromWebReceivedSuccessfully:responseObject];
//                }
//            }
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
                object.newsDetails = [[NSAttributedString alloc]initWithString:[[tempArray objectAtIndex:i] valueForKey:@"news_description"]];
            }
            else
            {
                object.newsDetails = [[NSAttributedString alloc]initWithString:@""];
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



@end
