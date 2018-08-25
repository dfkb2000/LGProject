//
//  DJUserNetworkManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUserNetworkManager.h"
#import "DJUser.h"

@interface DJUserNetworkManager ()


@end

@implementation DJUserNetworkManager

- (void)frontUserinfo_selectSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [self sendPOSTRequestWithiName:@"frontUserinfo/select" param:@{} success:success failure:failure];
}
- (void)userUpdatePwdWithOld:(NSString *)oldPwd newPwd:(NSString *)newPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"newpassword":newPwd,
                            @"password":oldPwd};
    [self sendTableWithiName:@"frontUserinfo/updatePwd" param:param needUserid:YES success:success failure:failure];
}

- (void)userForgetChangePwdWithPhone:(NSString *)phone newPwd:(NSString *)newPwd oldPwd:(NSString *)oldPwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":phone,
                            @"newpassword":newPwd,
                            @"password":oldPwd
                            };
    [self sendTableWithiName:@"frontUserinfo/forgetPwd" param:param needUserid:NO success:success failure:failure];
}

- (void)userVerrifiCodeWithPhone:(NSString *)phone code:(NSString *)code success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":phone,
                            @"verifi":code
                            };
    [self sendTableWithiName:@"frontUserinfo/checkVerifi" param:param needUserid:NO success:success failure:failure];
    
}
- (void)userSendMsgWithPhone:(NSString *)phone success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":phone};
    [self sendTableWithiName:@"frontUserinfo/sendMsg" param:param needUserid:NO success:success failure:failure];
}

- (void)userLogoutSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{};
    [self sendTableWithiName:@"/frontUserinfo/logout" param:param needUserid:YES success:success failure:failure];
}
- (void)userLoginWithTel:(NSString *)tel pwd_md5:(NSString *)pwd_md5 success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    /**
     type
     0: token登陆
     1: 密码登陆
     token登录应该去掉，因为token是登陆成功服务器返回的，所以，这里的接口设计是错误的
     */
    
    NSDictionary *param = @{@"phone":tel
                            ,@"password":pwd_md5
                            };
    [self sendTableWithiName:@"/frontUserinfo/login" param:param needUserid:NO success:success failure:failure];
}
- (void)userActivationWithTel:(NSString *)tel oldPwd:(NSString *)oldPwd pwd:(NSString *)pwd success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    NSDictionary *param = @{@"phone":tel,
                            @"oldpassword":oldPwd,
                            @"password":pwd
                            };
    [self sendTableWithiName:@"/frontUserinfo/activation" param:param needUserid:NO success:success failure:failure];
}

- (void)sendTableWithiName:(NSString *)iName param:(id)param needUserid:(BOOL)needUserid success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendTableWithiName:iName param:param needUserid:needUserid success:success failure:failure];
}

/// MARK: 发送请求数据的统一方法
- (void)sendPOSTRequestWithiName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    [[DJNetworkManager sharedInstance] sendPOSTRequestWithiName:iName param:[self unitAddMemIdWithParam:param] success:success failure:failure];
}
- (void)commenPOSTWithOffset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort iName:(NSString *)iName param:(id)param success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
    [[DJNetworkManager sharedInstance] commenPOSTWithOffset:offset length:length sort:sort iName:iName param:[self unitAddMemIdWithParam:param] success:success failure:failure];
}
- (NSDictionary *)unitAddMemIdWithParam:(id)param{
    NSMutableDictionary *argu = [NSMutableDictionary dictionaryWithDictionary:param];
    argu[@"mechanismid"] = [DJUser sharedInstance].mechanismid;
    argu[@"userid"] = [DJUser sharedInstance].userid;
    return argu;
}

CM_SINGLETON_IMPLEMENTION
@end
