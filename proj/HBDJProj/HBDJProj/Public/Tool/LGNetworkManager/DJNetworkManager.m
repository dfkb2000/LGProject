//
//  DJNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJNetworkManager.h"
#import "LGNetworkCache.h"

@interface DJNetworkManager ()
@property (strong,nonatomic) NSString *baseUrl;
@property (strong,nonatomic) NSString *pakageName;

@end

@implementation DJNetworkManager

- (void)uploadFileWithLocalFileUrl:(NSURL *)localFileUrl mimeType:(NSString *)mimeType uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadFileSuccess)success failure:(LGUploadImageFailure)failure{
    
    NSString *url = [self urlStringWithiName:@"frontUserinfo/uploadFile"];
    NSDictionary *param = @{userid_key:[DJUser sharedInstance].userid,@"pic":@"",@"filename":@""};
    
    [[LGNetworkManager sharedInstance] lg_uploadFileWithUrl:url param:param localFileUrl:localFileUrl fieldName:@"pic" fileName:@"" mimeType:mimeType uploadProgress:progress success:success failure:failure];
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    
    NSString *url = [self urlStringWithiName:@"frontUserinfo/uploadFile"];
    NSDictionary *param = @{userid_key:[DJUser sharedInstance].userid,@"pic":@"",@"filename":@""};
    
    [[LGNetworkManager sharedInstance] uploadImageWithUrl:url param:param localFileUrl:localFileUrl fieldName:@"pic" fileName:@"" uploadProgress:progress success:success failure:failure];
}

- (NSURLSessionTask *)taskForPOSTRequestWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    /// TODO: 目前暂未 想好 该方法如何与 sendPOSTRequestWithiName 合并为一个
    
    /// 添加统一参数
    NSMutableDictionary *paramMutable = [self unitParamDictWithDict:param];
    if (!needUserid) {
        [paramMutable removeObjectForKey:userid_key];
    }
    
    /// 拼接请求链接
    NSString *url = [self urlStringWithiName:iName];
    
    /// 获取最终参数
    NSMutableDictionary *argum = [self terParamWithUnitParam:paramMutable.copy];
    
    NSLog(@"arguments -- %@",argum);
    NSLog(@"requesturl: %@",url);
    
    return [[LGNetworkManager sharedInstance] taskForPOSTRequestWithUrl:url param:argum completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"POST_task_res_obj: %@",responseObject);
        /// 如果请求失败，执行失败回调
        if (error) {
            if (failure) failure(error);
        }else{
            /// 否则，解析数据
            /// 1.获取 result
            NSInteger result = [responseObject[@"result"] integerValue];
            
            /// 2.获取msg，请求成功或者失败的文本信息
            
            /// if result == 0,请求成功, if result == 1 请求失败
            NSString *msg = responseObject[@"msg"];
            if (result == 0) {/// 请求成功
                /// 3.获取 returnJson，它是数据的json串
                id jsonString = responseObject[@"returnJson"];
                
                if ([jsonString isKindOfClass:[NSNull class]]) {
                    /// 3.1 如果 json串为空, 应该执行 失败回调，并说明 json串为空
                    [[UIApplication sharedApplication].keyWindow presentFailureTips:@"网络请求异常"];
                    if (failure) failure(@"JSON为空");
                }else{
                    /// 3.2 json串有值，则将json 进行反序列化操作，转为 字典 或 数组 类型的数据
                    NSData *data = [responseObject[@"returnJson"] dataUsingEncoding:NSUTF8StringEncoding];
                    id returnJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    if (success) success([self returnJsonHandle:returnJson]);
                }
                
            }else{/// 请求失败
                NSDictionary *errorDict = @{@"msg":msg,
                                            @"result":@(result)
                                            };
                if (failure) failure(errorDict);
            }
        }
    }];
}

/**
 MARK: 上传表单数据的统一方法
 @param iName 接口名
 @param param 参数
 @param needUserid 是否需要用户id，传NO表示不需要
 @param success 成功回调
 @param failure 失败回调
 */
- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [self taskForPOSTRequestWithiName:iName param:param needUserid:needUserid success:success failure:failure];
}

/// MARK: 分页接口统一调用此方法
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSString *offset_string = [NSString stringWithFormat:@"%ld",offset];
    NSString *length_string = [NSString stringWithFormat:@"%ld",length];
    NSString *sort_string = [NSString stringWithFormat:@"%ld",sort];
    NSMutableDictionary *paramMutable = [NSMutableDictionary dictionaryWithDictionary:param];
    paramMutable[@"offset"] = offset_string;
    paramMutable[@"length"] = length_string;
    paramMutable[@"sort"] = sort_string;
    [self sendPOSTRequestWithiName:iName param:paramMutable success:success failure:failure];
}
/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    /// 添加统一参数
    NSMutableDictionary *paramMutable = [self unitParamDictWithDict:param];
    
    /// 拼接请求链接
    NSString *url = [self urlStringWithiName:iName];
    
    /// 获取最终参数
    NSMutableDictionary *argum = [self terParamWithUnitParam:paramMutable.copy];

    NSLog(@"%@: arguments -- %@",iName,argum);
//    NSLog(@"%@: requesturl: %@",iName,url);
    
    [[LGNetworkManager sharedInstance] sendPOSTRequestWithUrl:url param:argum completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) { 
        NSLog(@"%@_responseObject: %@",iName,responseObject);
        
        if (error) {
            NSLog(@"error: %@",error);
            /// MARK: 回调缓存数据
            [self callBackCacheJsonObjWithiName:iName argum:argum success:success failure:failure];

        }else{
            NSInteger result = [responseObject[@"result"] integerValue];
//            NSString *msg = responseObject[@"msg"];
            
            id jsonString = responseObject[@"returnJson"];
            if ([jsonString isKindOfClass:[NSNull class]]) {
                NSLog(@"returnJson为空");
                [self callBackCacheJsonObjWithiName:iName argum:argum success:success failure:failure];
            }else{
                NSData *data = [responseObject[@"returnJson"] dataUsingEncoding:NSUTF8StringEncoding];
                id returnJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"jsonstring -- %@",jsonString);
                
                /// MARK: 写入缓存数据
                [LGNetworkCache lg_save_asyncJsonToCacheFile:[self returnJsonHandle:returnJson] URLString:iName params:argum];
                
                if (result == 0) {/// 成功
                    if (success) success([self returnJsonHandle:returnJson]);
                }else{
                    /// MARK: 回调缓存数据
                    [self callBackCacheJsonObjWithiName:iName argum:argum success:success failure:failure];
                }
            }
        }
    }];
}
/// MARK: 获取缓存数据
- (void)callBackCacheJsonObjWithiName:(NSString *)iName argum:(id)argum success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    id cacheJson = [LGNetworkCache lg_cache_jsonWithURLString:iName params:argum];
    if (cacheJson) {
        [[UIApplication sharedApplication].keyWindow presentFailureTips:@"网络异常"];
        if (success) success(cacheJson);
    }else{
        if (failure) failure(@"网络异常且本地没有缓存数据");
    }
}

/// 处理 responseObj 为数组，且只有一个元素的情况
- (id)returnJsonHandle:(id)responseObj{
//    if ([responseObj isKindOfClass:[NSArray class]]) {
//        NSArray *array = responseObj;
//        if (array.count == 1) {
//            /// 回调字典 array[0]
//            return array[0];
//        }
//    }
    return responseObj;
}

/// MARK: 拼接请求链接
- (NSString *)urlStringWithiName:(NSString *)iName{
    if (![iName hasPrefix:@"/"]) {
        iName = [NSString stringWithFormat:@"/%@",iName];
    }
    return [NSString stringWithFormat:@"%@%@%@",self.baseUrl,self.pakageName,iName];
}

/** 添加统一的参数 */
- (NSMutableDictionary *)unitParamDictWithDict:(NSDictionary *)param{
    if (param == nil) {
        param = @{};
    }
    NSMutableDictionary *paramMutable = [NSMutableDictionary dictionaryWithDictionary:param];
    paramMutable[@"imei"] = @"imei";
    paramMutable[@"imsi"] = @"imsi";
    /// 如果没有userid这个键，添加userid，以便测试时，其他接口指定userid
    if (![paramMutable.allKeys containsObject:userid_key]) {
        paramMutable[userid_key] = [DJUser sharedInstance].userid;
    }
    return paramMutable;
}
/** 返回最终的请求参数 */
- (NSMutableDictionary *)terParamWithUnitParam:(NSDictionary *)unitParam{
    NSMutableDictionary *argum = [NSMutableDictionary dictionaryWithCapacity:10];
    argum[@"params"] = unitParam;
    
    /// 计算param 的 MD5
    argum[@"md5"] = [[unitParam dictToString] md5String];
    return argum;
}

/// MARK: URL
- (NSString *)baseUrl{
    if (!_baseUrl) {
//        _baseUrl = @"http://123.59.199.170:8081/";
//        _baseUrl = @"http://47.96.165.218:8081/";
        _baseUrl = @"http://dy.cjszyun.cn/";// @"http://47.96.165.218:8081/";// 长江传媒

    }
    return _baseUrl;
}
- (NSString *)host{
    if (!_host) {
        NSURL *url = [NSURL URLWithString:self.baseUrl];
        _host = url.host;
    }
    return _host;
}
- (NSNumber *)port{
    if (!_port) {
        NSURL *url = [NSURL URLWithString:self.baseUrl];
        _port = url.port;
    }
    return _port;
}
- (NSString *)pakageName{
    if (!_pakageName) {
        _pakageName = @"APMKAFService";
    }
    return _pakageName;
}

- (NSString *)tableURLPath{
    if (!_tableURLPath) {
        _tableURLPath = @"/APMKAFService/report/report.html";
    }
    return _tableURLPath;
}
- (NSURLComponents *)tableURLComponents{
    if (!_tableURLComponents) {
        _tableURLComponents = NSURLComponents.new;
        _tableURLComponents.scheme = @"http";
        _tableURLComponents.host = DJNetworkManager.sharedInstance.host;
        _tableURLComponents.port = DJNetworkManager.sharedInstance.port;
        _tableURLComponents.path = DJNetworkManager.sharedInstance.tableURLPath;
        NSURLQueryItem *queryItem0 = [NSURLQueryItem queryItemWithName:mechanismid_key value:DJUser.sharedInstance.mechanismid];
        _tableURLComponents.queryItems = @[queryItem0];
    }
    return _tableURLComponents;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// testcode
//        [[LGNetworkManager sharedInstance] checkNetworkStatus];
    }
    return self;
}

@end
