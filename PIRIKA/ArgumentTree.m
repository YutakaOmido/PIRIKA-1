//
//  ArgumentTree.m
//  PIRIKA
//
//  Created by katsura on 2013/06/13.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "ArgumentTree.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailInArgument.h"

@implementation ArgumentTree
{
    int _maxSize; // このノードを頂点としたときの木の最大幅
    int _depth; // このノードのどのくらいの深さにあるか
    int _space; // ノード同士の幅
    ArgumentTree *_prev; // 前のノード
    ArgumentTree *_rootNode; // 木の頂点
    NSMutableArray *_next; // 次のノード
    UILabel *_tv; // このノードの論証
    NSString *_text; // このノードの論証
    DrawRect *_dr; // 四角
    CGRect _r;
    CGFloat _w;
    CGFloat _h;
    BOOL _move;
    UIView *_mainView;
    NSString *_name;
    UIImageView *_self;
    UIImage *_arrow;
    UIPopoverController *_popoverController;
    DetailInArgument *_root;
}

NSDate static *_startDate;

- (id)initWithTree:(id)prev next:(NSMutableArray*)next depth:(int)depth maxsize:(int)maxsize text:(NSString*)text space:(int)space mainViewBounds:(CGRect)bounds
{
    _prev = prev;
    _next = next;
    _depth = depth;
    _maxSize = maxsize;
    _text = text;
    _space = space;
    _move = false;
    _r = bounds;
    _w = _r.size.width;
    _h = _r.size.height;
    _arrow = [UIImage imageNamed:@"line.png"];
    _startDate = [NSDate date];
    return self;
}

- (id)initWithTree:(id)prev next:(NSMutableArray*)next depth:(int)depth maxsize:(int)maxsize text:(NSString*)text space:(int)space mainViewBounds:(CGRect)bounds name:(NSString *)name
{
    _prev = prev;
    _next = next;
    _depth = depth;
    _maxSize = maxsize;
    _text = text;
    _space = space;
    _move = false;
    _r = bounds;
    _w = _r.size.width;
    _h = _r.size.height;
    _name = name;
    NSString* a_home_dir = NSHomeDirectory();
    NSString* a_doc_dir = [a_home_dir stringByAppendingPathComponent:@"Documents"];
    NSMutableString *str = [NSMutableString string];
    [str appendString:_name];
    [str appendString:@".jpg"];
    NSString *filePath=[a_doc_dir stringByAppendingPathComponent:str];
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    _self = [[UIImageView alloc] initWithImage:img];
    _arrow = [UIImage imageNamed:@"line.png"];
    _startDate = [NSDate date];
    return self;
}

- (void)setNextTree:(NSMutableArray *)next
{
    _next = next;
}

- (void)setPrevTree:(id)prev
{
    _prev = prev;
}

- (NSString*)getText
{
    return _tv.text;
}

- (void)setRootNode:(ArgumentTree *)root
{
    _rootNode = root;
}

- (void)outputText
{
    NSLog(@"%@",_text);
    for (int i=0; i<[_next count]; i++) {
        [[_next objectAtIndex:i] outputText];
    }
}

// 木構造を描画.
- (void)drawTree:(CGRect)rect mainView:(UIView*)view arrowImage:(UIImageView *)arrow
{
//    _arrowImage.frame = CGRectMake(rect.origin.x+rect.size.width/2.0-width/2.0, rect.origin.y+rect.size.height,
//                                   width, height);
    _mainView = view;
    if (_depth%2 == 0) {
        _dr = [[DrawRect alloc] initWithFrame:rect color:true image:_self arrowImage:arrow];
        _dr.delegate = self;
        CGRect r = rect;
        _self.frame = CGRectMake(r.origin.x+10, r.origin.y+10, r.size.width-20, r.size.height-20);
        [view addSubview:_dr];
        [view addSubview:_self];
    }else{
        _dr = [[DrawRect alloc] initWithFrame:rect color:false image:_self arrowImage:arrow];
        _dr.delegate = self;
        CGRect r = rect;
        _self.frame = CGRectMake(r.origin.x+10, r.origin.y+10, r.size.width-20, r.size.height-20);
        [view addSubview:_dr];
        [view addSubview:_self];
    }
    
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat buf=0;
    x = x- ((_space+rect.size.width)*((_maxSize-1)/(CGFloat)2.0));
    for (int i=0; i<[_next count]; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:_arrow];
        buf = ((_space+rect.size.width)*([[_next objectAtIndex:i] maxSize]-1)/(CGFloat)2.0);
        x = x + buf;
        CGRect next = CGRectMake(x,y+rect.size.height+_space,rect.size.width,rect.size.height);
        
        CGFloat arrowX = rect.origin.x-next.origin.x;
        CGFloat arrowY = (next.origin.y)-(rect.origin.y+rect.size.height);
        double angle = atan2(arrowX, arrowY);
        double height = sqrt((arrowY*arrowY)+(arrowX*arrowX));
        imgView.frame = CGRectMake(0 ,0, 2, height);
        [view addSubview:imgView];
        
        [imgView setCenter:CGPointMake((rect.origin.x+next.origin.x)/2.0+rect.size.width/2.0, next.origin.y-_space/2.0)];
        imgView.transform = CGAffineTransformMakeRotation(angle);
        
        [[_next objectAtIndex:i] drawTree:next
                                 mainView:view
                               arrowImage:imgView];
        if ([[_next objectAtIndex:i] maxSize]==1) {
            x = x + _space +rect.size.width;
        }else{
            x = x + buf + rect.size.width + _space;
        }
//        sleep(1);
    }
}

// 勝利対話木を計算.
- (NSMutableArray *)createWinDialogueTreeRoot
{
    NSMutableArray *tree = [NSMutableArray array];
    NSMutableArray *rootTree = [NSMutableArray array];
    [rootTree addObject:[NSString stringWithFormat:@"%d",_depth]];
    [rootTree addObject:_text];
    [tree addObject:rootTree];
    for (int i=0; i<[_next count]; i++) {
        NSMutableArray *subTree = [[_next objectAtIndex:i] createWinDialogueTree];
        if ([subTree count]>0) {
            if ([tree count]==1 && [subTree count]==1) {
                [[tree objectAtIndex:0] addObjectsFromArray:[subTree objectAtIndex:0]];
            }else{
                int max = (int)([tree count]*[subTree count]-[tree count]);
                for (int j=0; j<max; j++) {
                    [tree addObject:[[tree objectAtIndex:(j%[tree count])] mutableCopy]];
                }
                for (int j=0; j<[tree count]; j++) {
                    [[tree objectAtIndex:j] addObjectsFromArray:[subTree objectAtIndex:j%[subTree count]]];
                }
            }
        }else{
            return nil;
        }
    }
    return tree;
}


- (NSMutableArray *)createWinDialogueTree
{
    NSMutableArray *tree = [NSMutableArray array];
    if ([_next count]==0) {

        if (_depth%2==1) {
            return nil;
        }
        NSMutableArray *subTree = [NSMutableArray array];
        [subTree addObject:[NSString stringWithFormat:@"%d",_depth]];
        [subTree addObject:_text];
        [tree addObject:subTree];
    }else{
        for (int i=0; i<[_next count]; i++) {
            NSMutableArray *subTree = [[_next objectAtIndex:i] createWinDialogueTree];
            
            for (int j=0; j<[subTree count]; j++) {
                [[subTree objectAtIndex:j] insertObject:_text atIndex:0];
                [[subTree objectAtIndex:j] insertObject:[NSString stringWithFormat:@"%d",_depth]
                                                atIndex:0];
                [tree addObject:[subTree objectAtIndex:j]];
            }
        }
    }
    return tree;
}

// 勝利対話木を計算.
- (NSMutableArray *)createRoomWinDialogueTreeRoot
{
    NSMutableArray *tree = [NSMutableArray array];
    NSMutableArray *rootTree = [NSMutableArray array];
    [rootTree addObject:[NSString stringWithFormat:@"%d",_depth]];
    [rootTree addObject:_name];
    [rootTree addObject:_text];
    [tree addObject:rootTree];
    for (int i=0; i<[_next count]; i++) {
        NSMutableArray *subTree = [[_next objectAtIndex:i] createRoomWinDialogueTree];
        if ([subTree count]>0) {
            if ([tree count]==1 && [subTree count]==1) {
                [[tree objectAtIndex:0] addObjectsFromArray:[subTree objectAtIndex:0]];
            }else{
                int max = (int)([tree count]*[subTree count]-[tree count]);
                for (int j=0; j<max; j++) {
                    [tree addObject:[[tree objectAtIndex:(j%[tree count])] mutableCopy]];
                }
                for (int j=0; j<[tree count]; j++) {
                    [[tree objectAtIndex:j] addObjectsFromArray:[subTree objectAtIndex:j%[subTree count]]];
                }
            }
        }else{
            return nil;
        }
    }
    return tree;
}


- (NSMutableArray *)createRoomWinDialogueTree
{
    NSMutableArray *tree = [NSMutableArray array];
    if ([_next count]==0) {
        
        if (_depth%2==1) {
            return nil;
        }
        NSMutableArray *subTree = [NSMutableArray array];
        [subTree addObject:[NSString stringWithFormat:@"%d",_depth]];
        [subTree addObject:_name];
        [subTree addObject:_text];
        [tree addObject:subTree];
    }else{
        for (int i=0; i<[_next count]; i++) {
            NSMutableArray *subTree = [[_next objectAtIndex:i] createRoomWinDialogueTree];
            
            for (int j=0; j<[subTree count]; j++) {
                [[subTree objectAtIndex:j] insertObject:_text atIndex:0];
                [[subTree objectAtIndex:j] insertObject:_name atIndex:0];
                [[subTree objectAtIndex:j] insertObject:[NSString stringWithFormat:@"%d",_depth]
                                                atIndex:0];
                [tree addObject:[subTree objectAtIndex:j]];
            }
        }
    }
    return tree;
}

// 最大幅を返す.
- (int)maxSize
{
    return _maxSize;
}

/**
 * デリゲートメソッド
 */
- (void)touchEvent
{
    NSLog(@"EventDelegate!");
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_startDate];
    
    if (interval>1.8) {
        _startDate = [NSDate date];
        if(_move){
            [self removeRectAndTextViewRoot];
            [self createRectAndTextView];
        }else{
            [self moveObjectAndTextView];
        }
    }
}

// 長押し判定がDrawRectから送られてくる.(Delegate先)
- (void)touchEventLongPress
{
    UIViewController *v = [[UIViewController alloc] init];
    UIImage *img = [UIImage imageNamed:@"ami4.png"];
    v.view.backgroundColor=[UIColor colorWithPatternImage:img];
//    v.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    v.view.contentMode = UIViewContentModeCenter;
    
    NSMutableArray *detail = [self splitConclusionAndReasonTree:_text];

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
    if (size.width > _mainView.bounds.size.width) {
        t = CGAffineTransformScale(t,_mainView.bounds.size.width/(size.width+60), _mainView.bounds.size.width/(size.width+60));
        size.height = size.height * _mainView.bounds.size.width/(size.width+60);
    }
    
    if (size.height > _mainView.bounds.size.height) {
        t = CGAffineTransformScale(t, _mainView.bounds.size.height/(size.height), _mainView.bounds.size.height/(size.height));
    }
    
    v.view.transform = t;
    
    v.preferredContentSize = size;
    
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:v];
    _popoverController.delegate = self;
    // Popoverを表示する
    [_popoverController presentPopoverFromRect:_dr.frame
                                        inView:_mainView
                      permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)createRectAndTextView
{
    _tv = [self createLabel];
    [_dr createRectWithTextView:_tv mainView:_mainView space:_space];
    if (_prev!=NULL) {
        [_prev createRectAndTextView];
    }
}

- (void)removeRectAndTextViewRoot
{
    [_rootNode removeRectAndTextView];
}

- (void)removeRectAndTextView
{
    if(_tv!=NULL){
        [_dr removeRectAndTextView:_tv];
        for (int i=0; i<[_next count]; i++) {
            [[_next objectAtIndex:i] removeRectAndTextView];
        }
    }
}

- (void)removeRectAndTextAndImage
{
    [_dr removeRectAndTextAndImage:_tv];
    for (int i=0; i<[_next count]; i++) {
        [[_next objectAtIndex:i] removeRectAndTextAndImage];
    }
}

- (void)moveObjectAndTextView
{
    _move = true;
    _tv = [self createLabel];
    [_dr moveRect:_tv mainView:_mainView space:_space];
    if(_prev!=NULL){
        [_prev moveObjectAndTextView];
    }
    for (int i=0; i<[_next count]; i++) {
        [[_next objectAtIndex:i] moveObject];
    }
}

- (void)moveObject
{
    if (_move==false) {
        _move = true;
        [_dr moveRect];
        if(_prev!=NULL){
            [_prev moveObject];
        }
        for (int i=0; i<[_next count]; i++) {
            [[_next objectAtIndex:i] moveObject];
        }
    }
    
}

- (void)undoObject
{
    if (_move == true) {
        if (_tv==NULL) {
            [_dr undoRect];
        }else{
            [_dr undoRect:_tv];
        }
        
        for (int i=0; i<[_next count]; i++) {
            [[_next objectAtIndex:i] undoObject];
        }
        _move =false;
    }
}

- (UILabel *)createLabel
{
    UILabel *tv = [[UILabel alloc] init];
    tv.backgroundColor = [UIColor clearColor];
    NSMutableArray *array = [self createTextArray:_text];
    
    NSArray *l = [[array objectAtIndex:0] componentsSeparatedByString:@"<=="];
    tv.text = l[0];
    
    // UIScrollViewの最大拡大率が5倍なのでかなり大きくセット
    tv.font = [UIFont systemFontOfSize:200];
    [tv setAdjustsFontSizeToFitWidth: YES];
//    tv.minimumFontSize = 70;
//    [tv setMinimumScaleFactor:10.0];
    
    // 1/5に縮小して5倍までの拡大であれば綺麗に表示
    tv.transform = CGAffineTransformMakeScale(0.2, 0.2);
    return tv;
}

// 正直必要ない
- (NSMutableArray *)createTextArray:(NSString *)text
{
    NSArray *lines;
    NSMutableArray *result = [NSMutableArray array];
    NSRange range = NSMakeRange(1, text.length-2);
    text = [text substringWithRange:range];
    lines = [text componentsSeparatedByString:@"],"];
    if ([lines count]==1) {
        result = [lines mutableCopy];
    }else{
        NSString *str;
        for (int i=0; i<[lines count]-1; i++) {
            str = [lines objectAtIndex:i];
            str = [str stringByAppendingString:@"]"];
            [result addObject:str];
        }
        str = [lines objectAtIndex:[lines count]-1];
        [result addObject:str];
    }
    return result;
}

// もっと簡潔に書けるはず．正直すまんかった．
// 論証を分割．
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
    NSMutableArray *buf = [NSMutableArray array];
    // 分割されたそれぞれについて"<=="で分割
    for (int i=0; i<[lines count]; i++) {
        NSString *str = [lines objectAtIndex:i];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"<==not" withString:@"<==not "];
        NSArray *m = [str componentsSeparatedByString:@"<=="];
        
        // 注釈を分離
        NSString *conclusion = [m[0] componentsSeparatedByString:@"::"][0];
        NSArray *reason = [m[1] componentsSeparatedByString:@"&"];
        
        if ([buf containsObject:conclusion]) {
            for(int j=1;j<[buf count];j=j+2){
                if ([[buf objectAtIndex:j] isEqualToString:conclusion]) {
                    int position = j+1;
                    int dep = [[buf objectAtIndex:j-1] intValue];
                    UILabel *l = [result objectAtIndex:j];
                    
                    if (j+2<[buf count] && [[[result objectAtIndex:j+2] text] isEqualToString:reason[0]]) {
                        continue;
                    }
                    
                    if (![l.text isEqualToString:m[0]]) {
//                        [buf insertObject:[NSString stringWithFormat:@"%d",dep+1]
//                                  atIndex:position];
//                        [buf insertObject:conclusion
//                                  atIndex:position+1];
//                        [result insertObject:[NSString stringWithFormat:@"%d",dep+1]
//                                     atIndex:position];
//                        [result insertObject:[self labelTemplet:m[0]]
//                                     atIndex:position+1];
//                        position = position+2;
//                        dep = dep+1;
                    }
                    
                    dep = dep+1;
                    for (int k=0; k<[reason count]; k++) {
                        [buf insertObject:[NSString stringWithFormat:@"%d",dep]
                                  atIndex:position];
                        [buf insertObject:[[reason objectAtIndex:k]componentsSeparatedByString:@"::"][0]
                                  atIndex:position+1];
                        [result insertObject:[NSString stringWithFormat:@"%d",dep]
                                  atIndex:position];
                        [result insertObject:[self labelTemplet:[reason objectAtIndex:k]]
                                  atIndex:position+1];
                    }
                    break;
                }
            }
        }else{
            [buf addObject:[NSString stringWithFormat:@"%d",depth]];
            [buf addObject:conclusion];
            [result addObject:[NSString stringWithFormat:@"%d",depth]];
            [result addObject:[self labelTemplet:m[0]]];
            for (int j=0; j<[reason count]; j++) {
                [buf addObject:[NSString stringWithFormat:@"%d",depth+1]];
                [buf addObject:[[reason objectAtIndex:j]componentsSeparatedByString:@"::"][0]];
                [result addObject:[NSString stringWithFormat:@"%d",depth+1]];
                NSString *s = [reason objectAtIndex:j];
//                if (![s isEqualToString:@"true"]) {
                    [result addObject:[self labelTemplet:s]];
//                }
                
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
