//
//  ECRHomeTitleView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LIGBaseView.h"

@class EDJHomeNav;

typedef NS_ENUM(NSUInteger, NavState) {
    NavStateDefault,/// 透明状态
    NavStateSolid,/// 不透明状态
};

@protocol EDJHomeNavDelelgate <NSObject>

@optional
/**
 开始搜索

 @param titleView self
 */
- (void)hnViewBeginSearch:(EDJHomeNav *)titleView;

/**
 点击 语音助手

 @param titlView self
 @param param 预留参数
 */

@end

@interface EDJHomeNav : LIGBaseView

@property (assign,nonatomic) NavState bgdsState;

@property (weak,nonatomic) id<EDJHomeNavDelelgate> delegate;

CGFloat navHeight(void);

@end