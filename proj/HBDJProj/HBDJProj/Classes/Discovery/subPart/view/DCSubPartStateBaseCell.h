//
//  DCSubPartStateBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 发现  支部动态 单元格

#import "LGBaseTableViewCell.h"
@class DCSubPartStateModel,LGThreeRightButtonView;

static NSString * const withoutImgCell = @"DCSubPartStateWithoutImgCell";
static NSString * const oneImgCell = @"DCSubPartStateOneImgCell";
static NSString * const threeImgCell = @"DCSubPartStateThreeImgCell";

@interface DCSubPartStateBaseCell : LGBaseTableViewCell
@property (strong,nonatomic) DCSubPartStateModel *model;

/** 显示时间 */
@property (strong,nonatomic) UILabel *timeLabel;
/** 点赞，收藏，评论view */
@property (strong, nonatomic) LGThreeRightButtonView *boInterView;

@end
