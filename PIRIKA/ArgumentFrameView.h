//
//  ArgumentFrameView.h
//  PIRIKA
//
//  Created by katsura on 2013/11/29.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArgumentFrameView : UIView
- (id)initWithFrame:(CGRect)frame Node:(NSMutableArray *)array;
- (void)changeColor:(NSArray *)array;
- (void)resetColor;
@end
