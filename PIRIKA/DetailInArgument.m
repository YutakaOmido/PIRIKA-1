//
//  DetailInArgument.m
//  PIRIKA
//
//  Created by katsura on 2013/08/26.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "DetailInArgument.h"
#import <QuartzCore/QuartzCore.h>

@implementation DetailInArgument
{
    UILabel *_label;
    NSString *_text;
    DetailInArgument *_prev;
    NSMutableArray *_next;
    int _depth;
    UIView *_view;
    float _maxSize;
    UIImage *_arrow;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrameAndText:(CGRect)frame text:(NSString *)str
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 60)];
        [[_label layer] setBorderColor:[[UIColor blackColor] CGColor]];
        [[_label layer] setBorderWidth:2.0];
        [_label setFont:[UIFont systemFontOfSize:20]];
        _label.text = _text =str;
        _label.numberOfLines = 0;
        [_label sizeToFit];
        CGRect r = _label.frame;
        _label.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width+30, r.size.height+30);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (id)initWithLabel:(UILabel *)label maxSize:(float)size depth:(int)depth view:(UIView *)view
{
    self = [super init];
    _label = label;
    _maxSize = size;
    _depth = depth;
    _view = view;
    _arrow = [UIImage imageNamed:@"line.png"];
    return self;
}

- (void)setNextObjects:(NSMutableArray *)next
{
    _next = next;
}

- (float)getMaxSize
{
    return _maxSize;
}

- (void)setLabelPoint:(CGPoint)center
{
    _label.center = center;
    [_view addSubview:_label];
    float prev = _label.center.x-_maxSize/2.0;
    for (int i=0; i<[_next count]; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:_arrow];
        
        DetailInArgument *d = [_next objectAtIndex:i];
        float m = [d getMaxSize];
        if ([_next count]==1) {
            CGPoint next = CGPointMake(center.x, (_depth+1)*(_label.bounds.size.height+20)+_label.bounds.size.height/2+20);
            
            CGPoint now = _label.center;
            
            imgView.frame = CGRectMake(now.x , now.y + _label.bounds.size.height/2.0 , 2, 20);
            
            [_view addSubview:imgView];
            [d setLabelPoint:next];
        }else{
            CGPoint next = CGPointMake(prev + m/2, (_depth+1)*(_label.bounds.size.height+20)+_label.bounds.size.height/2+20);
            
            CGPoint now = _label.center;
            
            CGFloat arrowX = now.x - next.x;
            CGFloat arrowY = (next.y-_label.bounds.size.height/2.0)-(now.y+_label.bounds.size.height/2.0);
            double angle = atan2(arrowX, arrowY);
            double height = sqrt((arrowY*arrowY)+(arrowX*arrowX));
            imgView.frame = CGRectMake(0 ,0, 2, height);
            
            [imgView setCenter:CGPointMake((now.x+next.x)/2.0, now.y+_label.bounds.size.height/2.0+10)];
            imgView.transform = CGAffineTransformMakeRotation(angle);
            [_view addSubview:imgView];
            [d setLabelPoint:next];
            
            prev += m+20;
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)outPut
{
    NSLog(@"%d,%@",_depth,_label.text);
    for (int i=0; i<[_next count]; i++) {
        DetailInArgument *d = [_next objectAtIndex:i];
        [d outPut];
    }
}

- (void)outText
{
    NSLog(@"%d,%@",_depth,_label.text);
}
@end
