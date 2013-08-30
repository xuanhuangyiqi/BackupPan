//
//  BaiduSDK.m
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/29/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import "BaiduSDK.h"






@implementation BaiduSDK

SEL sel;

+ (BaiduSDK *)shared
{
    static BaiduSDK *_instance;
    if (!_instance)
        _instance = [[BaiduSDK alloc] init];
    return _instance;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (BaiduSDK *)initWithAPI: (NSString *)key andPath: (NSString *)folder andDelegate:(id)d
{
    // TODO test key folder legel
    self.api_key = key;
    self.save_path = folder;
    self.delegate = d;

    return self;
}
- (NSString *)auth: (WebView *)web withSelector:(SEL)selector
{
    sel = selector;
    NSString *url = [[NSString alloc] initWithFormat:@"https://openapi.baidu.com/oauth/2.0/authorize?response_type=token&client_id=%@&redirect_uri=oob&scope=netdisk&display=page", self.api_key];
    [web setFrameLoadDelegate:self];
    [web setMainFrameURL:url];
}

+ (NSString *)tokenFilter:(NSString *)url andSubstring:(NSString *)sub
{
    NSRange range = [url rangeOfString:sub];
    NSUInteger start = range.location+range.length;
    NSString *temp = [url substringFromIndex:start];
    range = [temp rangeOfString:@"&"];
    return [temp substringToIndex:range.location];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    // TODO auth page check
    self.token = [BaiduSDK tokenFilter:sender.mainFrameURL andSubstring:@"access_token="];
    [sender close];
    //[sender removeFromSuperview];
    [self.delegate performSelector:sel];
}

- (ASIFormDataRequest *)getQuota: (SEL)selector
{
    NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://pcs.baidu.com/rest/2.0/pcs/quota?method=info&access_token=%@", self.token, self.save_path] ];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    return request;
}

-(ASIFormDataRequest *) uploadFile: (NSString *)local_path
{
    NSArray *arr = [local_path pathComponents];
    NSString *file = [arr objectAtIndex:[arr count]-1];
    
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"https://c.pcs.baidu.com/rest/2.0/pcs/file?method=upload&path=%%2fapps%%2f%@%%2f%@&access_token=%@", self.save_path, file, self.token]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setFile:local_path forKey:@"file"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];
    return request;
}

-(ASIFormDataRequest *) addTask:(NSString *)source_url
{
    NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://pcs.baidu.com/rest/2.0/pcs/services/cloud_dl"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:@"add_task" forKey:@"method"];
    [request addPostValue:self.token forKey:@"access_token"];
    [request addPostValue:source_url forKey:@"source_url"];
    [request addPostValue:[[NSString alloc] initWithFormat:@"/apps/%@",self.save_path ] forKey:@"save_path"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Error");
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *origin = request.url.query;
    NSDictionary *dic = [[request responseData] objectFromJSONData];
    NSMutableDictionary *resp = [[NSMutableDictionary alloc ] init];
    [resp setValue:dic forKey:@"response"];
    [resp setValue:[BaiduSDK tokenFilter:origin andSubstring:@"method="] forKey:@"method"];
    if (![resp objectForKey:@"method"])
    {
    }
    [resp setValue:request forKey:@"request"];
    [self.delegate performSelector:@selector(didReceive:) withObject:resp];
    NSLog(@"finish");
}
@end
