//
//  MainViewController.m
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/28/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize download;

DragView * drag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 640, 480)];
    self.view = view;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        BaiduSDK *sdk = [[BaiduSDK shared] initWithAPI:@"V7ViaVrbDMSHozCj23bHEg2X" andPath:@"api0" andDelegate:self];
        
        WebView *authPage = [[WebView alloc] initWithFrame:CGRectMake(0, 0, 640, 480)];
        [sdk auth:authPage withSelector:@selector(didFinishAuth)];
        [self.view addSubview:authPage];
        [self.view setAutoresizingMask:63];

    }
    
    return self;
}

- (void) didFinishAuth
{
    [[BaiduSDK shared] getQuota:@selector(receivedQuota)];
    
    NSLog(@"fi");
    CGSize size = self.view.window.frame.size;
    drag = [[DragView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [self.view addSubview:drag];
    [drag setAutoresizingMask:63];


//    NSURL *url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://pcs.baidu.com/rest/2.0/pcs/file?method=meta&access_token=%@&path=%%2fapps%%2fapi0", token] ];
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    CGSize size = self.view.window.frame.size;
//    DragView *drag = [[DragView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
//    [self.view addSubview:drag];
//    [drag setAutoresizingMask:63];
//    
    download = [[NSTextField alloc] initWithFrame:NSMakeRect(40, 340, 500, 20)];
    NSButton * addTask = [[NSButton alloc] initWithFrame:CGRectMake(550, 340, 60, 20)];
    [addTask setTitle:@"离线下载"];
    [addTask setTarget:self];
    [addTask setAction:@selector(digitButtonPressed:)];
    [drag addSubview:addTask];
    [drag addSubview:download];
}


- (void)digitButtonPressed:(id)_sender {
    NSLog(@"press");
    [[BaiduSDK shared] addTask:[download stringValue]];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"321");
    NSDictionary *dic = [[request responseData] objectFromJSONData];
    if ([dic objectForKey:@"rapid_download"] && [[dic objectForKey:@"rapid_download"] isEqualToString:@"1"])
    {
        [download setStringValue:@""];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    
}

- (void) didReceive: (NSDictionary *)dic
{
    NSString *method =[dic objectForKey:@"method"];
    if ([method isEqualToString:@"info"]){
        //info
    }
    else if ([method isEqualToString:@"upload"])
    {
        [drag receiveData:dic];
    }
    else if ([method isEqualToString:@"add_task"])
    {
        NSLog(@"add");
    }
}

@end
