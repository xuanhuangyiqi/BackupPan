//
//  BaiduSDK.h
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/29/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface BaiduSDK : NSObject

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * api_key;
@property (nonatomic, copy) NSString * save_path;
@property (nonatomic, strong) id delegate;

+ (BaiduSDK *) shared;
+ (NSString *) tokenFilter:(NSString *)url andSubstring:(NSString *)sub;
- (BaiduSDK *) initWithAPI: (NSString *)api_key andPath: (NSString *)path andDelegate:(id) d;
- (NSString *) auth: (WebView *) web withSelector: (SEL)selector;
- (ASIFormDataRequest *) getQuota: (SEL)selector;
- (void)performSel:(ASIHTTPRequest *)request;
- (ASIFormDataRequest *) uploadFile: (NSString *)local_path;
- (ASIFormDataRequest *) addTask: (NSString *)source_url;

@end
