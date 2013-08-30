//
//  DragView.h
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/28/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "BaiduSDK.h"

#import "MainViewController.h"
@interface DragView : NSView

- (void) receiveData: (NSMutableDictionary *)dic;
@end
