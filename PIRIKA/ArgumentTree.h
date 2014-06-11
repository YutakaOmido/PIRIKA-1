//
//  ArgumentTree.h
//  PIRIKA
//
//  Created by katsura on 2013/06/13.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawRect.h"

@interface ArgumentTree : NSObject<DrawRectDelegate,UIPopoverControllerDelegate>

- (id)initWithTree:(id)prev next:(NSMutableArray*)next depth:(int)depth maxsize:(int)maxsize text:(NSString*)text space:(int)space mainViewBounds:(CGRect)bounds;
- (id)initWithTree:(id)prev next:(NSMutableArray*)next depth:(int)depth maxsize:(int)maxsize text:(NSString*)text space:(int)space mainViewBounds:(CGRect)bounds name:(NSString *)name;
- (void)setNextTree:(NSMutableArray *)next;
- (void)setPrevTree:(id)prev;
- (NSString*)getText;
- (void)outputText;
- (void)drawTree:(CGRect)rect mainView:(UIView*)view arrowImage:(UIImageView *)arrow;
- (int)maxSize;
- (void)moveObject;
- (void)moveObjectAndTextView;
- (void)undoObject;
- (void)removeRectAndTextView;
- (void)removeRectAndTextViewRoot;
- (void)removeRectAndTextAndImage;
- (void)createRectAndTextView;
- (NSMutableArray *)createWinDialogueTree;
- (NSMutableArray *)createWinDialogueTreeRoot;
- (NSMutableArray *)createRoomWinDialogueTree;
- (NSMutableArray *)createRoomWinDialogueTreeRoot;
- (void)setRootNode:(ArgumentTree *)root;
@end
