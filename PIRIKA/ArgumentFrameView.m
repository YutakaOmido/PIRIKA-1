//
//  ArgumentFrameView.m
//  PIRIKA
//
//  Created by katsura on 2013/11/29.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "ArgumentFrameView.h"
#import "Node.h"

@interface ArgumentFrameView ()
@property (nonatomic) UIDynamicAnimator* animator;
@end

@implementation ArgumentFrameView
{
    NSArray *_node;
    UISnapBehavior *_snap;
    Node *n0;
}

- (id)initWithFrame:(CGRect)frame Node:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        _node = array;
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        NSMutableArray *obj = [NSMutableArray array];
        [obj addObjectsFromArray:_node];
        n0 = _node[0];
        
        int num=0;
        for (int i=0; i<[_node count]; i++) {
            Node *n = [_node objectAtIndex:i];
            if ([n getAttackNum]==0 && [n getRecieveNum]==0) {
                n.frame = CGRectMake(20, 80+70*num, 50, 50);
                num++;
            }
            [self addSubview:n];
        }
        
        Node *n = [_node objectAtIndex:0];
        NSMutableArray *list = [NSMutableArray array];
        [list addObject:[NSString stringWithFormat:@"%d",n.num]];
        
        [n setPoint:-1 list:list];
        
        for (int i=0; i<[_node count]; i++) {
            Node *n = [_node objectAtIndex:i];
            NSArray *a = [n setBehavior:_animator
                                   view:self];
            [obj addObjectsFromArray:a];
            [n setNeedsDisplay];
        }
        
        UIGravityBehavior *gb = [[UIGravityBehavior alloc] initWithItems:_node];
        [gb setAngle:1.5707963267948966f magnitude:1.5f];
//        [_animator addBehavior:gb];
        
        UICollisionBehavior *col = [[UICollisionBehavior alloc] initWithItems:obj];
        col.translatesReferenceBoundsIntoBoundary = YES;
        [_animator addBehavior:col];
        
        UIDynamicItemBehavior *pro = [[UIDynamicItemBehavior alloc] initWithItems:_node];
        pro.allowsRotation = NO;
//        pro.density = 1.0;
        pro.resistance = 1.0;
        [_animator addBehavior:pro];

        
    }
    return self;
}

// タッチイベントを取る
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
	[_animator removeBehavior:_snap];
    _snap = [[UISnapBehavior alloc] initWithItem:n0 snapToPoint:location];
    [_animator addBehavior:_snap];
}

- (void)changeColor:(NSArray *)array
{
    for (int i=0; i<[array count]; i++) {
        int k = [array[i] intValue];
        Node *n = [_node objectAtIndex:k];
        [n changeBlueColor:YES];
    }
}

- (void)resetColor
{
    for (int i=0; i<[_node count]; i++) {
        Node *n = [_node objectAtIndex:i];
        [n changeBlueColor:NO];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
