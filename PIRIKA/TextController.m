//
//  TextController.m
//  PIRIKA
//
//  Created by katsura on 2013/08/23.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import "TextController.h"

@implementation TextController

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch");
}


@end
