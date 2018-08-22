//
//  DCSubStageModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 党员舞台模型 (朋友圈)

#import "DJDataBaseModel.h"
@class DCSubStageCommentsModel,LGPlayer;

typedef NS_ENUM(NSUInteger, StageModelType) {
    StageModelTypeDefault,/// 只有文字 --> 加载 MoreImg 的cell, imgs.count == 0
    StageModelTypeAudio,/// 音频 --> 按照 单图 横 的情况处理，图片上另外添加一个 播放按钮
    StageModelTypeVideo,/// 视频
    StageModelTypeAImg,/// 一张图 --> DCSubStageOneImgCell
    StageModelTypeMoreImg/// 多图 加载 DCSubStageThreeImgCell
};

typedef NS_ENUM(NSUInteger, StageModelTypeAImgType) {
    StageModelTypeAImgTypeVer,/// 竖图
    StageModelTypeAImgTypeHori,/// 横图
};
/** 单图，竖，高度 */
static const CGFloat aImgVerHeight = 177;
/** 单图，竖，宽度 */
static const CGFloat aImgVerWidth = 114;
/** 单图，横，高度 */
static const CGFloat aImgHoriHeight = 111;
/** 单图，横，宽度 */
static const CGFloat aImgHoriWidth = 177;
/** 评论单元格行高 */
static const CGFloat commentsCellHeight = 25;

@interface DCSubStageModel : DJDataBaseModel

//@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSArray *imgs;

@property (assign,nonatomic) CGFloat nineImgViewHeight;
/** 评论tbv的高度 */
@property (assign,nonatomic) CGFloat commentsTbvHeight;

/** 区分 cell的类型，分为 纯文字，一图，多图，音频，视频 */
@property (assign,nonatomic) StageModelType modelType;
/** 横图，竖图 类型 */
@property (assign,nonatomic) StageModelTypeAImgType aImgType;
/** 是否视频 */
@property (assign,nonatomic) BOOL isVideo;

@property (assign,nonatomic) CGFloat heightForContent;
//@property (strong,nonatomic) NSString *content;

@property (strong,nonatomic) UIImage *testIcon;
@property (strong,nonatomic) UIImage *aTestImg;

/** 评论数据 */
//@property (strong,nonatomic) NSArray<DCSubStageCommentsModel *> *comments;

/// -----------------------------
/** 朋友圈单图的图片宽高 */
@property (strong,nonatomic) NSString *widthheigth;
/** 单图宽度 */
@property (assign,nonatomic) CGFloat single_pic_width;
/** 单图高度 */
@property (assign,nonatomic) CGFloat single_pic_height;
@property (strong,nonatomic) NSString *fileurl;
/**
 1图片
 2视频
 3音频
 4文本
 */
@property (assign,nonatomic) NSInteger filetype;
/** 评论模型数组 */
@property (strong,nonatomic) NSArray<DCSubStageCommentsModel *> *frontComments;
/** 资源链接 */

/** 时间戳 */
//@property (strong,nonatomic) NSString *timestamp;
//@property (strong,nonatomic) NSString *createdtime;
/**
 1党员舞台
 2思想汇报
 3述职述廉
 */
@property (assign,nonatomic) NSInteger ugctype;
///** 点赞id */
//@property (assign,nonatomic) NSInteger praiseid;
///** 点赞数 */
//@property (assign,nonatomic) NSInteger praisecount;
///** 收藏id */
//@property (assign,nonatomic) NSInteger collectionid;
///** 收藏数 */
//@property (assign,nonatomic) NSInteger collectioncount;
/** 上传用户 */
@property (strong,nonatomic) NSString *uploader;

//    "creatorid":1,
//    "sort":0,
//    "title":"",
//    "auditstate":"1",
//    "mechanismid":"180607092010002",
//    "userid":"长孙无极",
//    "cover":"",
//    "seqid":1,
//    "status":1
/// 朋友圈列表音频cell需要使用的属性
@property (assign,nonatomic) NSInteger cTime;
@property (assign,nonatomic) NSInteger tTime;
@property (assign,nonatomic) CGFloat progress;
@property (assign,nonatomic) NSInteger playState;
@property (strong,nonatomic) LGPlayer *player;

@end
