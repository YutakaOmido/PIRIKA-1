//
//  DrawRect.m
//  PIRIKA
//
//  Created by katsura on 2013/06/14.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "DrawRect.h"

@implementation DrawRect
{
    BOOL _blue;
    BOOL _green;
    BOOL _longTap;
    DrawRect *_rectCopy;
    UIImageView *_imgCopy;
    UIImageView *_selfImg;
    CGFloat _ratio;
    CGFloat _space;
    CGRect _frame;
    CGFloat _move;
    UIImageView *_balloonImage;
    UIImageView *_arrowImage;
    UIImageView *_arrowCopy;
    CGAffineTransform _arrowTrans;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame color:(BOOL)color image:(UIImageView *)img arrowImage:(UIImageView *)arrow
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor; //背景を透明に
        // タッチイベントを許可.
        self.userInteractionEnabled = YES;
        _blue = color;
        _ratio = 5.0;
        _space = 0;
        _frame = frame;
        _move = 100;
        _selfImg = img;
        _arrowImage = arrow;
        _arrowTrans = _arrowImage.transform;
        _green = false;
        _longTap = false;
        
        UILongPressGestureRecognizer *longPressGesture =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(view_LongPres:)];
        
//        // 長押しが認識される時間を設定
//        longPressGesture.minimumPressDuration = 2.0;
        
        //　ジェスチャーを追加
        [self addGestureRecognizer:longPressGesture];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //　塗りつぶす色を青色に設定。
    if (_green){
        [[UIColor greenColor] setFill];
    }else if (_blue) {
        [[UIColor blueColor] setFill];
    }else{
        [[UIColor redColor] setFill];
    }
	UIRectFill(CGRectInset(self.bounds, 0, 0));
}


/**
 * タッチされたとき
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_longTap) {
        // デリゲート先がメソッドを持っているか?
        if ([self.delegate respondsToSelector:@selector(touchEvent)]) {
            [self.delegate touchEvent];
        }else{
            NSLog(@"NO!");
        }
    }
}

/**
 * ビューが長押しされたとき
 */
- (void)view_LongPres:(UILongPressGestureRecognizer *)sender
{
    if ([sender state]==UIGestureRecognizerStateBegan) {
        _longTap=true;
        // デリゲート先がメソッドを持っているか?
        if ([self.delegate respondsToSelector:@selector(touchEventLongPress)]) {
            [self.delegate touchEventLongPress];
        }else{
            NSLog(@"持ってないよ!");
        }
    }else if ([sender state] == UIGestureRecognizerStateEnded){
        _longTap = false;
    }
}

- (void)moveRect:(UILabel *)tv mainView:(UIView *)view space:(int)space
{
    CGRect r = view.bounds;
    CGFloat w = r.size.width;
//    CGFloat h = r.size.height;
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGAffineTransform trans;
    trans = CGAffineTransformMakeTranslation(-x+x/_ratio-_space,-y+y/_ratio-_space);
    trans = CGAffineTransformScale(trans,1.0/_ratio, 1.0/_ratio);
//    trans = CGAffineTransformMakeScale(1.0/_ratio, 1.0/_ratio);
//    trans = CGAffineTransformTranslate(trans,-x+x/_ratio-_space,-y+y/_ratio-_space);
    
    tv.frame = CGRectMake(w/2+10, y, w/2-80, self.frame.size.height);
    
    _imgCopy = [[UIImageView alloc] initWithFrame:_selfImg.frame];
    _imgCopy.image = _selfImg.image;
    _rectCopy = [[DrawRect alloc] initWithFrame:self.frame color:_blue image:_imgCopy arrowImage:_arrowImage];
    _rectCopy.delegate = self.delegate;
    _arrowCopy = [[UIImageView alloc] initWithFrame:_arrowImage.bounds];
    _arrowCopy.center = _arrowImage.center;
    _arrowCopy.transform = _arrowTrans;
    _arrowCopy.image = _arrowImage.image;
    
    [view addSubview:_rectCopy];
    [view addSubview:_imgCopy];
    [view addSubview:_arrowCopy];
    // UIImageViewの初期化
    CGRect balloon = CGRectMake(w/2-40, y, w/2-20, self.frame.size.height);
    _balloonImage = [[UIImageView alloc]initWithFrame:balloon];
    // 画像の読み込み
    if (_blue) {
        _balloonImage.image = [UIImage imageNamed:@"balloonBlue.png"];
    }else{
        _balloonImage.image = [UIImage imageNamed:@"balloonRed.png"];
    }
    
//    CGAffineTransform arrowTrans = _arrowImage.transform;
//    arrowTrans = CGAffineTransformConcat(arrowTrans,trans);
    
    [UIView animateWithDuration:1.5f
                     animations:^{
                         self.transform = trans;
                         _selfImg.transform = trans;
                         _arrowImage.transform = CGAffineTransformMakeScale(0, 0);
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:1.5f
                                          animations:^{     
                                              _rectCopy.transform
                                              = CGAffineTransformMakeTranslation((w/2.0-_rectCopy.frame.origin.x-_rectCopy.frame.size.width/2-_move),0);
                                              _imgCopy.transform = CGAffineTransformMakeTranslation((w/2.0-_imgCopy.frame.origin.x-_imgCopy.frame.size.width/2-_move),0);
                                              CGAffineTransform t = CGAffineTransformMakeTranslation((w/2.0-_arrowCopy.frame.origin.x-_arrowCopy.frame.size.width/2-_move),0);
                                              t = CGAffineTransformScale(t, 1, space/_arrowCopy.bounds.size.height);
                                              _arrowCopy.transform = t;
                                          } completion:^(BOOL finished) {
                                              [view addSubview:_balloonImage];
                                              [view addSubview:tv];
                                              _green = true;
                                              [self setNeedsDisplay];
//                                              tv.transform = CGAffineTransformMakeTranslation((w/2.0-tv.frame.origin.x-tv.frame.size.width/2),y);
                                          }];
                     }];
}


- (void)moveRect
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGAffineTransform trans;
    
    trans = CGAffineTransformMakeTranslation(-x+x/_ratio-_space,-y+y/_ratio-_space);
    trans = CGAffineTransformScale(trans,1.0/_ratio, 1.0/_ratio);
    
//    trans = CGAffineTransformMakeScale(1.0/_ratio, 1.0/_ratio);
//    trans = CGAffineTransformTranslate(trans,-x+x/_ratio-_space,-y+y/_ratio-_space);
    
//    CGAffineTransform arrowTrans = _arrowImage.transform;
//    arrowTrans = CGAffineTransformConcat(arrowTrans,trans);
    
    [UIView animateWithDuration:1.5f
                     animations:^{
                         self.transform = trans;
                         _selfImg.transform = trans;
                         _arrowImage.transform = CGAffineTransformMakeScale(0, 0);
                     } completion:^(BOOL finished){
                     }];
}


- (void)undoRect
{
    [UIView animateWithDuration:1.5f
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         _selfImg.transform = CGAffineTransformIdentity;
                         _arrowImage.transform = _arrowTrans;
                     } completion:^(BOOL finished){
                     }];
}

- (void)undoRect:(UILabel *)tv
{
    CGRect r = [[UIScreen mainScreen] bounds];
    CGFloat w = r.size.width;
    CGFloat y = self.frame.origin.y;
    CGAffineTransform trans;
    trans = CGAffineTransformMakeTranslation(-w/2,-y);
    trans = CGAffineTransformScale(trans,1.0/_ratio, 1.0/_ratio);
    [tv removeFromSuperview];
    [_rectCopy removeFromSuperview];
    [_imgCopy removeFromSuperview];
    [_balloonImage removeFromSuperview];
    [_arrowCopy removeFromSuperview];
    [UIView animateWithDuration:1.5f
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         _selfImg.transform = CGAffineTransformIdentity;
                         _arrowImage.transform = _arrowTrans;
//                         tv.transform = trans;
                     } completion:^(BOOL finished){
                         _green = false;
                         [self setNeedsDisplay];
                     }];
}

- (void)createRectWithTextView:(UILabel *)tv mainView:(UIView *)view space:(int)space
{
    CGRect r = view.bounds;
    CGFloat w = r.size.width;
//    CGFloat h = r.size.height;
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGAffineTransform trans;
    
    _imgCopy = [[UIImageView alloc] initWithFrame:_selfImg.frame];
    _imgCopy.image = _selfImg.image;
    _rectCopy = [[DrawRect alloc] initWithFrame:self.frame color:_blue image:_selfImg arrowImage:_arrowImage];
    _rectCopy.delegate = self.delegate;
    _arrowCopy = [[UIImageView alloc] initWithImage:_arrowImage.image];
//    _arrowCopy.center = _arrowImage.center;
//    _arrowCopy.transform = CGAffineTransformMakeScale(0, 0);
    
    trans = CGAffineTransformMakeTranslation(w/2-x-_move, _frame.origin.y-y+_frame.size.height/2-_ratio-2);
    trans = CGAffineTransformScale(trans,_ratio, _ratio);
    tv.frame = CGRectMake(w/2+10, _frame.origin.y, w/2-80, _frame.size.height);

    [view addSubview:_rectCopy];
    [view addSubview:_imgCopy];
    
    CGRect balloon = CGRectMake(w/2-40, _frame.origin.y, w/2-20, _frame.size.height);
    _balloonImage = [[UIImageView alloc]initWithFrame:balloon];
    if (_blue) {
        _balloonImage.image = [UIImage imageNamed:@"balloonBlue.png"];
    }else{
        _balloonImage.image = [UIImage imageNamed:@"balloonRed.png"];
    }
    
    _green = true;
    [self setNeedsDisplay];
    [UIView animateWithDuration:1.5f
                     animations:^{
                         _rectCopy.transform = trans;
                         _imgCopy.transform = trans;
//                         _rectCopy.transform = CGAffineTransformInvert(self.transform);
                     } completion:^(BOOL finished){
                         [view addSubview:_balloonImage];
                         _arrowCopy.frame = CGRectMake(w/2-40-_rectCopy.frame.size.width/2, _frame.origin.y-space+3, 2, space);
                         [view addSubview:tv];
                         [view addSubview:_arrowCopy];
                     }];
}

- (void)removeRectAndTextView:(UILabel *)tv
{
    [tv removeFromSuperview];
    [_balloonImage removeFromSuperview];
    [_rectCopy removeFromSuperview];
    [_imgCopy removeFromSuperview];
    [_arrowCopy removeFromSuperview];
    _green = false;
    [self setNeedsDisplay];
}

- (void)removeRectAndTextAndImage:(UILabel *)tv
{
    [tv removeFromSuperview];
    [_balloonImage removeFromSuperview];
    [_rectCopy removeFromSuperview];
    [_selfImg removeFromSuperview];
    [_imgCopy removeFromSuperview];
    [_arrowCopy removeFromSuperview];
    [_arrowImage removeFromSuperview];
    [self removeFromSuperview];
}
@end
