//
//  DJOnlineNetorkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DJOnlineUGCType) {
    DJOnlineUGCTypeStage = 1,/// 党员舞台
    DJOnlineUGCTypeMindReport,/// 思想汇报
    DJOnlineUGCTypeComponce,/// 述职述廉
};

@interface DJOnlineNetorkManager : NSObject

/** 确认投票接口 */
- (void)frontVotes_addWithVoteid:(NSInteger)voteid votedetailid:(NSArray *)votedetailid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 投票详情,标题，选项等 */
- (void)frontVotes_selectDetailWithVoteid:(NSInteger)voteid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 在线投票列表 */
- (void)frontVotes_selectWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 获取党员舞台、思想汇报、述职述廉 列表数据

 @param ugcType 类型：1党员舞台 2思想汇报 3述职述廉
 */
- (void)frontUgcWithType:(DJOnlineUGCType)ugcType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 获取三会一课列表数据 */
- (void)frontSessionsWithSessiontype:(NSInteger)sessionType offset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/** 获取主题党日列表数据 */
- (void)frontThemesWithOffset:(NSInteger)offset length:(NSInteger)length success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 上传三会一课 */
- (void)addSessionsWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
上传主题党日

 @param formDict 封装好的表单数据
 @param success 成功
 @param failure 失败
 */
- (void)addThemeWithFormdict:(NSMutableDictionary *)formDict success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 机构人员列表 */
- (void)frontUserinfoSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/** 上传图片 */
- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure;

- (void)onlineHomeConfigSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

CM_SINGLETON_INTERFACE
@end