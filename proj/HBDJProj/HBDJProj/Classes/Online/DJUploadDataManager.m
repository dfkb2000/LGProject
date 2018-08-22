//
//  DJUploadDataManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadDataManager.h"
#import "HXPhotoPicker.h"
#import "DJOnlineNetorkManager.h"
#import "DJOnlineUploadTableModel.h"

@interface DJUploadDataManager ()
/** 要上传的表单数据 */
@property (strong,nonatomic) NSMutableDictionary *formData;

@end

@implementation DJUploadDataManager

/// 朋友圈 上传单图、音频、视频
- (void)ugc_uploadFileWithMimeType:(NSString *)mimeType success:(DJUploadImageComplete)completeBlock singleFileComplete:(DJUploadFileComplete)singleFileComplete{
    if (_tempImageUrls.count == 1) {
        
        NSURL *localUrl = self.tempImageUrls[0];
        
        [self uploadFileWithLocalFileUrl:localUrl mimeType:mimeType uploadProgress:^(NSProgress *uploadProgress) {
            NSLog(@"ugc上传进度: %f",(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(id dict) {
            if (singleFileComplete) singleFileComplete(dict);
            
        } failure:^(id uploadFailure) {
            if (singleFileComplete) singleFileComplete(nil);
        }];
        
    }else{
        [self uploadFileWithSuccess:completeBlock];
    }
}

/// MARK: 上传内容图片
- (void)uploadContentImageWithSuccess:(DJUploadImageComplete)completeBlock{
    /**
     /// 如何保证正确的图片顺序？
     
     1.一个数组 -- 基于 tempImageUrls 的可变数组
     2.一个字典 -- value是图片上传成功后的链接，key是图片在 tempImageUrls 中的索引
     3.一个block 上传完成block
     4.两个count 失败计数 和 成功计数，上传成功或者失败时各自+1，当失败计数+成功计数与tempImageUrls.count相等时，就执行上传完成block
     
     */
    [self uploadFileWithSuccess:completeBlock];
}

- (void)uploadFileWithSuccess:(DJUploadImageComplete)completeBlock{
    if (_tempImageUrls == nil) {
        /// 表示用户没有选择图片，直接回调
        if (completeBlock) completeBlock(nil,_formData);
    }
    
    __block NSInteger successCount = 0;
    __block NSInteger failureCount = 0;
    
    /** 上传图片完成block */
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:self.tempImageUrls.copy];
    void (^uploadImageCompleteBlock)(NSDictionary *urls) = ^(NSDictionary *urls){
        for (NSInteger i = 0; i < imageUrls.count; i++) {
            imageUrls[i] = urls[[NSString stringWithFormat:@"%ld",(long)i]];
        }
        if (completeBlock) completeBlock(imageUrls.copy,_formData);
    };
    
    NSMutableDictionary *urlDict = NSMutableDictionary.new;
    for (NSInteger i = 0; i < self.tempImageUrls.count; i++) {
        NSURL *localUrl = self.tempImageUrls[i];
        
        [self uploadImageWithLocalFileUrl:localUrl uploadProgress:^(NSProgress *uploadProgress) {
            NSLog(@"%ld: %f",(long)i,(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSString *imgUrl_sub) {
            [urlDict setValue:imgUrl_sub forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            successCount++;
            if ((successCount + failureCount) == self.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        } failure:^(id uploadFailure) {
            [urlDict setValue:[NSString stringWithFormat:@"第%ld张图上传失败",(long)i] forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            failureCount++;
            
            if ((successCount + failureCount) == self.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        }];
    }
}

- (void)presentAlbunListViewControllerWithViewController:(UIViewController *)vc manager:(HXPhotoManager *)manager selectSuccess:(DJSelectCoverSuccess)selectSuccess uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure {
    
    [vc hx_presentAlbumListViewControllerWithManager:manager done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            /// 2.保存封面图片的本地临时路径
            if (imageUrls.count) {
                NSURL *coverLocalUrl = imageUrls[0];
                /// MARK: 上传封面
                [self uploadImageWithLocalFileUrl:coverLocalUrl uploadProgress:progress success:success failure:failure];
                
                /// MARK: 将成功/失败的状态和数据 回调给控制器
                if (selectSuccess) selectSuccess(coverLocalUrl);
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
    }];
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJOnlineNetorkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
}
- (void)uploadFileWithLocalFileUrl:(NSURL *)localFileUrl mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure{
    [DJOnlineNetorkManager.sharedInstance uploadFileWithLocalFileUrl:localFileUrl mimeType:mimeType uploadProgress:progress success:success failure:failure];
}


/// MARK: HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    
    NSArray *array;
    if (photos.count == 0) {
        array = videos;
    }else{
        array = photos;
    }
    
    [HXPhotoTools selectListWriteToTempPath:array requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
    } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
        _tempImageUrls = allUrl.copy;
        
    } error:^{
        NSLog(@"selectPhotoError");
    }];
    
}

- (NSString *)msgByFormdataVerifyWithTableModels:(NSArray *)array{
    NSString *msg;
    for (NSInteger i = 0; i < array.count; i++) {
        DJOnlineUploadTableModel *model = array[i];
        if (model.necess) {
            if ([model.content isEqualToString:@""] || model.content == nil) {
                msg = model.itemName;
                break;
            }
        }
    }
    return msg;
}

- (void)setUploadValue:(id)value key:(NSString *)key{
    NSAssert(value != nil, @"value 不能为空");
    [_formData setValue:value forKey:key];
    NSLog(@"表单数据_formData: %@",_formData);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _formData = NSMutableDictionary.new;
    }
    return self;
}

@end
