//
//  DetailInArgument.h
//  PIRIKA
//
//  Created by katsura on 2013/08/26.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInArgument : UIView
- (id)initWithLabel:(UILabel *)label maxSize:(float)size depth:(int)depth view:(UIView *)view;
- (void)setNextObjects:(NSMutableArray *)next;
- (void)setLabelPoint:(CGPoint)center;
@end
