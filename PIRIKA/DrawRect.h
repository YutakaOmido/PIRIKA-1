//
//  DrawRect.h
//  PIRIKA
//
//  Created by katsura on 2013/06/14.
//  Copyright (c) 2013年 katsura. All rights reserved.
//

#import <UIKit/UIKit.h>

// デリゲートを定義
@protocol DrawRectDelegate <NSObject>

// デリゲートメソッドを宣言
// （宣言だけしておいて，実装はデリゲート先でしてもらう）
- (void)touchEvent;
- (void)touchEventLongPress;
@end

@interface DrawRect : UIView

// デリゲート先で参照できるようにするためプロパティを定義しておく
@property (nonatomic, assign) id<DrawRectDelegate> delegate;

- (id)initWithFrame:(CGRect)frame color:(BOOL)color image:(UIImageView *)img arrowImage:(UIImageView *)arrow;
- (void)moveRect:(UILabel *)tv mainView:(UIView *)view space:(int)space;
- (void)moveRect;
- (void)undoRect;
- (void)undoRect:(UILabel *)tv;
- (void)removeRectAndTextView:(UILabel *)tv;
- (void)removeRectAndTextAndImage:(UILabel *)tv;
- (void)createRectWithTextView:(UILabel *)tv mainView:(UIView *)view space:(int)space;
@end
