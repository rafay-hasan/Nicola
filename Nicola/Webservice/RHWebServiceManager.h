//
//  RHWebServiceManager.h
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define BASE_URL_API @"http://bulegas.whatsupitec.com/"
#define News_URL_API @"api_news_by_limit/"
#define Events_URL_API @"api_race_events_by_limit/"
#define Login_URL_API @"api_login_authentication_ios"
#define ClubHistory_URL_API @"api_club_history"
#define AwardHistory_URL_API @"api_award_history_by_limit/"

enum {
    HTTPRequestypeNews,
    HTTPRequestypeEvent,
    HTTPRequestypeLogin,
    HTTPRequestypeClubHistory,
    HTTPRequestypeAwardHistory
};
typedef NSUInteger HTTPRequestType;


@protocol RHWebServiceDelegate <NSObject>

@optional

-(void) dataFromWebReceivedSuccessfully:(id) responseObj;
-(void) dataFromWebReceiptionFailed:(NSError*) error;
-(void) dataFromWebDidnotReceiveSuccessMessage:( id )responseObj;


@end


@interface RHWebServiceManager : NSObject

@property (nonatomic, retain) id <RHWebServiceDelegate> delegate;


@property (readwrite, assign) HTTPRequestType requestType;

-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del;

-(void)getDataFromWebURLWithUrlString:(NSString *)requestURL;

-(void)getPostDataFromWebURLWithUrlString:(NSString *)requestURL dictionaryData:(NSDictionary *)postDataDic;


@end
