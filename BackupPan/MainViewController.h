//
//  MainViewController.h
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/28/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "DragView.h"
#import "BaiduSDK.h"
#import "JSONKit.h"
#import "ASIFormDataRequest.h"

@interface MainViewController : NSViewController
@property (nonatomic, strong) NSTextField *download;

- (void) didReceive: (NSDictionary *)dic;
@end
