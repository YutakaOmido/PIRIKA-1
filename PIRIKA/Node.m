//
//  Node.m
//  PIRIKA
//
//  Created by katsura on 2013/11/20.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "Node.h"
#import "DetailInArgument.h"


@implementation Node
{
    NSMutableDictionary *_recieve;
    NSMutableDictionary *_attack;
    UIPopoverController *_popoverController;
    BOOL _blue;
}

@synthesize argument;
@synthesize num;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _recieve = [NSMutableDictionary dictionary];
        _attack = [NSMutableDictionary dictionary];
        _blue = false;
        
        UILongPressGestureRecognizer *longPressGesture =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        
        //　ジェスチャーを追加
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

/**
 * ビューが長押しされたとき
 */
- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    if ([sender state]==UIGestureRecognizerStateBegan) {
        UIViewController *v = [[UIViewController alloc] init];
        UIImage *img = [UIImage imageNamed:@"ami4.png"];
        v.view.backgroundColor=[UIColor colorWithPatternImage:img];
//        v.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        v.view.contentMode = UIViewContentModeCenter;
        
        NSMutableArray *detail = [self splitConclusionAndReasonTree:argument];
        
        CGSize size = CGSizeMake(0, 0);
        
        // 各ノードから見た最大幅を計算.
        float width[[detail count]];
        int prevDepth = -1;
        float prev = 0.0;
        for (int i=(int)[detail count]-1; i>0; i=i-2) {
            UILabel *l= [detail objectAtIndex:i];
            int nowDepth = [[detail objectAtIndex:i-1] intValue];
            if (prevDepth < nowDepth) {
                prev = 0.0;
            }
            
            prevDepth = nowDepth;
            
            if (prev < l.bounds.size.width) {
                width[i-1] = nowDepth;
                prev = width[i] = l.bounds.size.width;
            }else{
                width[i-1] = nowDepth;
                width[i] = prev;
            }
            
            for (int k=i+1; k<[detail count] && nowDepth <= [[detail objectAtIndex:k] intValue]; k=k+2) {
                if (nowDepth==[[detail objectAtIndex:k] intValue]) {
                    prev += width[k+1]+20;
                }
            }
        }
        
        // 管理クラス作成．
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<[detail count]; i++) {
            int depth = [[detail objectAtIndex:i] intValue];
            i++;
            UILabel *l = [detail objectAtIndex:i];
            
            DetailInArgument *d = [[DetailInArgument alloc] initWithLabel:l
                                                                  maxSize:width[i]
                                                                    depth:depth
                                                                     view:v.view];
            [array addObject:[NSString stringWithFormat:@"%d",depth]];
            [array addObject:d];
        }
        
        
        // 次のノードを指定．
        for (int i=0; i<[detail count]; i=i+2) {
            int depth = [[detail objectAtIndex:i] intValue];
            DetailInArgument *d = [array objectAtIndex:i+1];
            NSMutableArray *next = [NSMutableArray array];
            for (int j=i+2; j<[detail count] && depth<[[detail objectAtIndex:j] intValue]; j=j+2) {
                if (depth+1==[[detail objectAtIndex:j] intValue]) {
                    [next addObject:[array objectAtIndex:j+1]];
                }
            }
            [d setNextObjects:next];
        }
        
        // 位置を指定.
        DetailInArgument *d = [array objectAtIndex:1];
        UILabel *l = [detail objectAtIndex:1];
        [d setLabelPoint:CGPointMake(20+width[1]/2.0, l.bounds.size.height/2+20)];
        
        // 全体の高さを計算
        float height;
        for (int i=0; i<[detail count]; i++) {
            int depth = [[detail objectAtIndex:i] intValue];
            i++;
            UILabel *l = [detail objectAtIndex:i];
            if (height < depth*(l.bounds.size.height+20)+l.bounds.size.height/2+20) {
                height = depth*(l.bounds.size.height+20)+l.bounds.size.height/2+20;
            }
        }
        
        size.height = height+45;
        size.width = width[1]+40;
        
        
        CGAffineTransform t = CGAffineTransformMakeScale(1, 1);
        if (size.width > self.superview.bounds.size.width) {
            t = CGAffineTransformScale(t,self.superview.bounds.size.width/(size.width+60), self.superview.bounds.size.width/(size.width+60));
            size.height = size.height * self.superview.bounds.size.width/(size.width+60);
        }
        
        if (size.height > self.superview.bounds.size.height) {
            t = CGAffineTransformScale(t, self.superview.bounds.size.height/(size.height), self.superview.bounds.size.height/(size.height));
        }
        
        v.view.transform = t;
        
        v.preferredContentSize = size;
        
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:v];
        _popoverController.delegate = self;
        // Popoverを表示する
        [_popoverController presentPopoverFromRect:self.frame
                                            inView:self.superview
                          permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }else if ([sender state] == UIGestureRecognizerStateEnded){
        
    }
}

- (void)addAttackRelation:(NSString *)attackNum ref:(Node *)node
{
    [_attack setObject:node forKey:[attackNum stringByReplacingOccurrencesOfString:@" " withString:@""]];
}

- (void)addRecieveRelation:(NSString *)recieveNum ref:(Node *)node
{
    [_recieve setObject:node forKey:[recieveNum stringByReplacingOccurrencesOfString:@" " withString:@""]];
}


- (int)getRecieveNum
{
    return (int)[_recieve count];
}

- (int)getAttackNum
{
    return (int)[_attack count];
}

- (NSArray *)getAttackNode
{
    NSArray *a = [_attack allKeys];
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<[a count]; i++) {
        [array addObject:[_attack objectForKey:a[i]]];
    }
    return [array copy];
}

- (NSArray *)setBehavior:(UIDynamicAnimator *)animator view:(UIView *)view
{
    NSArray *attack = [_attack allKeys];
    NSArray *recieve = [_recieve allKeys];
    NSMutableArray *array = [NSMutableArray array];
    
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    //    CGFloat width = self.frame.size.width;
    //    CGFloat height = self.frame.size.height;
    float length = 30.0;
    
    
    for (int i=0; i<[attack count]; i++) {
        if ([recieve containsObject:attack[i]] && (num < [attack[i] intValue])) {
            Node *n = [_attack objectForKey:attack[i]];
            
            UIImage *img = [UIImage imageNamed:@"arrow4.png"];
            UIImageView *iv = [[UIImageView alloc] initWithImage:img];
            iv.frame = CGRectMake(0, 0, 30, 90);
            iv.center = CGPointMake((x+n.center.x)/2.0, (y+n.center.y)/2.0);
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:iv];
            [array addObject:iv];
            
            UIAttachmentBehavior *imgattatch = [[UIAttachmentBehavior alloc] initWithItem:self
                                                                         offsetFromCenter:UIOffsetMake(0, 0)
                                                                           attachedToItem:iv
                                                                         offsetFromCenter:UIOffsetMake(0, 45)];
            
            imgattatch.length=length;
            //            imgattatch.damping = 36.0;
            
            
            UIAttachmentBehavior *imgattatch2 = [[UIAttachmentBehavior alloc] initWithItem:iv
                                                                          offsetFromCenter:UIOffsetMake(0, -45)
                                                                            attachedToItem:n
                                                                          offsetFromCenter:UIOffsetMake(0, 0)];
            imgattatch2.length=length;
            //            imgattatch2.damping = 36.0;
            
            [animator addBehavior:imgattatch];
            [animator addBehavior:imgattatch2];
            
        }else if([recieve containsObject:attack[i]] && (num > [attack[i] intValue])){
            continue;
        }else{
            Node *n = [_attack objectForKey:attack[i]];
            
            UIImage *img = [UIImage imageNamed:@"arrow3.png"];
            UIImageView *iv = [[UIImageView alloc] initWithImage:img];
            iv.frame = CGRectMake(0, 0, 30, 90);
            iv.center = CGPointMake((x+n.center.x)/2.0, (y+n.center.y)/2.0);
            iv.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:iv];
            [array addObject:iv];
            
            UIAttachmentBehavior *imgattatch = [[UIAttachmentBehavior alloc] initWithItem:self
                                                                         offsetFromCenter:UIOffsetMake(0, 0)
                                                                           attachedToItem:iv
                                                                         offsetFromCenter:UIOffsetMake(0, 45)];
            
            imgattatch.length=length;
            //            imgattatch.damping = 36.0;
            
            UIAttachmentBehavior *imgattatch2 = [[UIAttachmentBehavior alloc] initWithItem:iv
                                                                          offsetFromCenter:UIOffsetMake(0, -45)
                                                                            attachedToItem:n
                                                                          offsetFromCenter:UIOffsetMake(0, 0)];
            imgattatch2.length=length;
            //            imgattatch2.damping = 36.0;
            
            [animator addBehavior:imgattatch];
            [animator addBehavior:imgattatch2];
        }
    }
    
    return [array copy];
}


- (void)setPoint:(int)parentNum list:(NSMutableArray *)list
{
    NSArray *attack = [_attack allKeys];
    NSArray *recieve = [_recieve allKeys];
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    NSMutableArray *all = [NSMutableArray arrayWithArray:attack];
    
    for (int i=0; i<[recieve count]; i++) {
        if (![all containsObject:[recieve objectAtIndex:i]]) {
            [all addObject:[recieve objectAtIndex:i]];
        }
    }
    
    [all removeObject:[NSString stringWithFormat:@"%d",parentNum]];
    
    for (int i=0; i<[all count]; i++) {
        Node *n = [_attack objectForKey:all[i]];
        if (n==Nil) {
            n = [_recieve objectForKey:all[i]];
        }
        if (![list containsObject:[NSString stringWithFormat:@"%d",n.num]]) {
            if ([all count]%2==1) {
                n.center = CGPointMake(x+(width+90)*(cos(2*M_PI*i/(double)[all count])),y+(height+90)*(sin(2*M_PI*i/(double)[all count])));
                if (n.center.x > self.superview.frame.size.width) {
                    n.center = CGPointMake(self.superview.frame.size.width - 50 , n.center.y+50);
                }
            }else{
                n.center = CGPointMake(x+(width+90)*(cos((2*M_PI*i/(double)[all count])+M_PI/8.0)),y+(height+90)*(sin((2*M_PI*i/(double)[all count])-M_PI/8.0)));
                if (n.center.x > self.superview.frame.size.width) {
                    n.center = CGPointMake(self.superview.frame.size.width - 50 , n.center.y+50);
                }
            }
            
            //        NSLog(@"%d:(%f,%f):%d:(%f,%f)",num,self.center.x,self.center.y,n.num,n.center.x,n.center.y);
            [list addObject:[NSString stringWithFormat:@"%d",n.num]];
            [n setPoint:num list:list];
        }
    }
}

- (void)changeBlueColor:(BOOL)b
{
    _blue = b;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    l.text = [NSString stringWithFormat:@"%d", num];
    [self addSubview:l];
    
    if (_blue) {
        [[UIColor blueColor] setFill];
    }else{
        [[UIColor greenColor] setFill];
    }
    UIRectFill(CGRectInset(self.bounds, 0, 0));
}

// 結果と根拠を分割.
- (NSMutableArray *)splitConclusionAndReasonTree:(NSString *)text
{
    NSMutableArray *result = [NSMutableArray array];
    NSRange range = NSMakeRange(1, text.length-2);
    text = [text substringWithRange:range];
    
    NSMutableArray *lines;
    // 結論の根拠が複数あり，true節が複数ある場合で場合分け
    if (([text rangeOfString:@"true,"].location != NSNotFound)) {
        lines = [NSMutableArray array];
        NSArray *k = [text componentsSeparatedByString:@"true,"];
        NSMutableArray *x = [k mutableCopy];
        
        // true がなくなるので補う
        for (int i=0; i<[k count]-1; i++) {
            NSString *s = k[i];
            s = [s stringByAppendingString:@"true"];
            [x replaceObjectAtIndex:i withObject:s];
        }
        
        // "],"で分割
        for (int i=0; i<[k count]; i++) {
            NSArray *l = [x[i] componentsSeparatedByString:@"],"];
            
            // ]がなくなるので補う
            for(int j=0; j<[l count]-1; j++){
                NSString *s = [l objectAtIndex:j];
                s = [s stringByAppendingString:@"]"];
                [lines addObject:s];
            }
            NSString *s = [l objectAtIndex:[l count]-1];
            [lines addObject:s];
        }
    }else{
        NSArray *l = [text componentsSeparatedByString:@"],"];
        lines = [l mutableCopy];
        
        for (int i=0; i<[lines count]-1; i++) {
            NSString *s = lines[i];
            s = [s stringByAppendingString:@"]"];
            [lines replaceObjectAtIndex:i withObject:s];
        }
    }
    
    int depth=0;
    // 分割されたそれぞれについて"<=="で分割
    for (int i=0; i<[lines count]; i++) {
        NSString *str = [lines objectAtIndex:i];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"<==not" withString:@"<==not "];
        NSArray *m = [str componentsSeparatedByString:@"<=="];
        
        BOOL contain = false;
        int t;
        // すでに同じ結論を含んでいるか判定
        for (t=1; t<[result count]; t=t+2) {
            UILabel *l= [result objectAtIndex:t];
            if ([l.text isEqualToString:[m[0] stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                if (t+2<[result count]) {
                    // 同じ結論が2回以上使われている場合，同じ結論に2回同じ根拠がつかないようにする
                    UILabel *l2= [result objectAtIndex:t+2];
                    //                    NSString *s = [m[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSString *s = m[1];
                    //                    s = [s stringByReplacingOccurrencesOfString:@"not" withString:@"not "];
                    if ([l2.text isEqualToString:s]) {
                        continue;
                    }
                }
                contain = true;
                break;
            }
        }
        
        if (contain) {
            NSString *n = [result objectAtIndex:t-1];
            int d = [n intValue];
            NSArray *a = [m[1] componentsSeparatedByString:@"&"];
            for (int k=0; k<[a count]; k++) {
                //                NSString *string = [[a objectAtIndex:k] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *string = [a objectAtIndex:k];
                UILabel *label = [self labelTemplet:string];
                //                UILabel *label = [self labelTemplet:[string stringByReplacingOccurrencesOfString:@"not" withString:@"not "]];
                [result insertObject:[NSString stringWithFormat:@"%d",d+1] atIndex:t+1];
                [result insertObject:label atIndex:t+2];
            }
        }else{
            //            UILabel *label = [self labelTemplet:[m[0] stringByReplacingOccurrencesOfString:@" " withString:@""]];
            UILabel *label = [self labelTemplet:m[0]];
            [result addObject:[NSString stringWithFormat:@"%d",depth]];
            [result addObject:label];
            depth++;
            NSArray *n = [m[1] componentsSeparatedByString:@"&"];
            
            for (int k=0; k<[n count]; k++) {
                //                NSString *string = [[n objectAtIndex:k] stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *string = [n objectAtIndex:k];
                UILabel *label = [self labelTemplet:string];
                //                UILabel *label = [self labelTemplet:[string stringByReplacingOccurrencesOfString:@"not" withString:@"not "]];
                [result addObject:[NSString stringWithFormat:@"%d",depth]];
                [result addObject:label];
            }
        }
        depth++;
    }
    return result;
}

// ラベルへの変換テンプレ
- (UILabel *)labelTemplet:(NSString *)str
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 60)];
    [[label layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[label layer] setBorderWidth:2.0];
    [label setFont:[UIFont systemFontOfSize:20]];
    label.numberOfLines = 0;
    label.text = str;
    label.backgroundColor = [UIColor whiteColor];
    [label sizeToFit];
    CGRect r = label.frame;
    label.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width+30, r.size.height+30);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
