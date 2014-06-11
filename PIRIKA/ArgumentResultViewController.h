//
//  ArgumentResultViewController.h
//  PIRIKA
//
//  Created by katsura on 2013/06/05.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFTCPConnection.h"
#import "AppDelegate.h"
#import "ArgumentTree.h"

@interface ArgumentResultViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *networkState;
//- (IBAction)networkState:(UIBarButtonItem *)sender;
//- (void)openNetwork;
//- (void)createArgumentTree;
- (void)createArgumentTree:(NSMutableArray *)result;
- (void)createArgumentTree:(NSMutableArray *)result :(NSString *)key;
- (void)createArgumentTreeWithName:(NSMutableArray *)result;
- (void)viewSingleTapped:(UITapGestureRecognizer *)sender;
- (void)viewDableTapped:(UITapGestureRecognizer *)sender;
- (void)rotateInit;
- (int)getPageIndex;
- (void)setIndex:(int)index;
- (void)pushRightButton;
- (NSMutableArray *)createWinDialogueTree;
- (ArgumentTree *)getRootNode;
- (id)initWithBackgroundImage:(NSString *)str;
- (id)initWithBackgroundClearColor;
- (id)initWithBackgroundImageResize:(NSString *)str;
- (NSMutableArray *)createRoomWinDialogueTree;
- (void)removeRectAndTextAndImage;
@end
