//
//  Node.h
//  PIRIKA
//
//  Created by katsura on 2013/11/20.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Node : UIView<UIPopoverControllerDelegate>
@property (retain) NSString *argument;
@property int num;

- (id)initWithFrame:(CGRect)frame;
- (void)addAttackRelation:(NSString *)attackNum ref:(Node *)node;
- (void)addRecieveRelation:(NSString *)recieveNum ref:(Node *)node;
- (int)getRecieveNum;
- (int)getAttackNum;
- (NSArray *)getAttackNode;
- (NSArray *)setBehavior:(UIDynamicAnimator *)animator view:(UIView *)view;
- (void)setPoint:(int)parentNum list:(NSMutableArray *)list;
- (void)changeBlueColor:(BOOL)b;
@end
