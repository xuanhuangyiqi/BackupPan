//
//  DragView.m
//  BackupPan
//
//  Created by Xiaoyu Wang on 8/28/13.
//  Copyright (c) 2013 Xiaoyu Wang. All rights reserved.
//

#import "DragView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"

@implementation DragView

NSInteger current_x, current_y;

NSString *kPrivateDragUTI = @"com.yourcompany.cocoadraganddrop";


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
        current_x = 0;
        current_y = 0;
    }
    return self;
}



- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    //NSLog(@"[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSPasteboard *pboard = [sender draggingPasteboard];
    
    if ([[pboard types] containsObject:NSFilenamesPboardType]) {
        NSArray *paths = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in paths) {
            NSError *error = nil;
            NSString *utiType = [[NSWorkspace sharedWorkspace]
                                 typeOfFile:path error:&error];
            if (![[NSWorkspace sharedWorkspace]
                  type:utiType conformsToType:(id)kUTTypeFolder]) {
            return NSDragOperationNone;
            }
        }
    }
    return NSDragOperationEvery;
}
- (void)draggingExited:(id <NSDraggingInfo>)sender {
    CGSize size = self.window.frame.size;
    [self setHighlighted:NO];
    NSPasteboard *pboard = [sender draggingPasteboard];
    NSInteger count = 0;
    if ([[pboard types] containsObject:NSFilenamesPboardType] && NSFilenamesPboardType != NSFileTypeDirectory) {
        
        NSArray *paths = [pboard propertyListForType:NSFilenamesPboardType];
        for (NSString *path in paths) {
            count += 1;
            
            NSTextView * text = [[NSTextView alloc] initWithFrame:CGRectMake(10, 20, 50, 10)];
            NSArray *arr = [path pathComponents];
            NSString *filename = [arr objectAtIndex:[arr count]-1];
            [text setString:[filename substringToIndex:7]];
            [text setEditable:NO];
            
            NSImageView *fileIconDisplay = [[NSImageView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
            NSFileWrapper *theFileWrapper=[[NSFileWrapper alloc]initWithPath:path];
            NSImage *theIcon=[theFileWrapper icon];
            [fileIconDisplay setImageScaling:NSScaleToFit];
            [fileIconDisplay setImage:theIcon];
            [fileIconDisplay setTag:count];
            
            NSView *subview = [[NSView alloc] initWithFrame:CGRectMake(current_x, current_y, 70, 90)];
            [subview addSubview:text];
            [subview addSubview:fileIconDisplay];
            [self addSubview:subview];
            
            current_x += 70;
            if (current_x + 70 > size.width)
            {
                current_x = 0;
                current_y += 90;
            }
            
            [self sendFile:path withTag:count];
        }
    }
}

- (NSViewController*)viewController {
    for (NSView* next = [self superview]; next; next = next.superview) {
        NSResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[NSViewController class]]) {
            return (NSViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)sendFile:(NSString *)filename withTag:(NSInteger)tag
{
    ASIFormDataRequest * request = [[BaiduSDK shared] uploadFile:filename];
    [request setTag:tag];
    
}
- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender  {
    return YES;
}

- (void)receiveData:(NSMutableDictionary *)dic
{
    ASIFormDataRequest *request = [dic objectForKey:@"request"];
    for(NSView *view in [self subviews])
    {
        NSImageView *img = [view.subviews objectAtIndex:1];
        if (img.tag == request.tag)
        {
            [view removeFromSuperview];
            if ([[self subviews] count] == 0)
            {
                current_x = 0;
                current_y = 0;
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    [self setHighlighted:NO];
    return YES;
}


- (void)setHighlighted:(BOOL)value {
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)frame {
    [super drawRect:frame];
    if (true) {

    }
}
@end
