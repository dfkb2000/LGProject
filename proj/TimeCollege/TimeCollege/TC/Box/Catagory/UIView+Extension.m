//
//  UIView+Extension.m
//  LGProject
//
//  Created by Peanut Lee on 2017/12/28.
//  Copyright © 2017年 LG. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

/**
 设置指定方向边框

 @param hasTopBorder 上
 @param hasLeftBorder 左
 @param hasBottomBorder 下
 @param hasRightBorder 右
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setDirectionBorderWithTop:(BOOL)hasTopBorder left:(BOOL)hasLeftBorder bottom:(BOOL)hasBottomBorder right:(BOOL)hasRightBorder borderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth{
    float height = self.height;
    
    float width = self.width;
    
    CALayer *topBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0, 0, width, borderWidth);
    
    topBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *leftBorder = [CALayer layer];
    
    leftBorder.frame = CGRectMake(0, 0, 1, height);
    
    leftBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0, height, width, borderWidth);
    
    bottomBorder.backgroundColor = borderColor.CGColor;
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(width, 0, borderWidth, height);
    
    rightBorder.backgroundColor = borderColor.CGColor;
    
    
    if (hasTopBorder) {
        [self.layer addSublayer:topBorder];
    }
    if (hasLeftBorder) {
        [self.layer addSublayer:leftBorder];
    }
    if (hasBottomBorder) {
        [self.layer addSublayer:bottomBorder];
    }
    if (hasRightBorder) {
        [self.layer addSublayer:rightBorder];
    }
}

/// MARK: 设置阴影
- (void)setShadowWithShadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowRadius:(float)shadowRadius{
    // 颜色
    self.layer.shadowColor = shadowColor.CGColor;
    // offset
    self.layer.shadowOffset = shadowOffset;
    // 透明度
    self.layer.shadowOpacity = shadowOpacity;
    // 阴影渐变
    self.layer.shadowRadius = shadowRadius;
    self.layer.masksToBounds = NO;
}

/// MARK: 设置border & 圆角
- (void)cutBorderWithBorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius{
    self.layer.borderWidth = width;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}
/// MARK: 切圆形
- (void)cutToCycle{
    self.layer.cornerRadius = self.height * 0.5;
    self.layer.masksToBounds = YES;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setSize:(CGSize)size{
    CGRect freme = self.frame;
    freme.size = size;
    self.frame = freme;
}
- (CGSize)size{
    return self.frame.size;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
- (CGFloat)centerY{
    return self.center.y;
}

@end
