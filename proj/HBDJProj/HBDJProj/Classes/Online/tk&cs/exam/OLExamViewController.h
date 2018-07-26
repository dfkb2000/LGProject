//
//  OLExamViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class OLTkcsModel;

@interface OLExamViewController : LGBaseViewController
@property (strong,nonatomic) NSString *portName;
@property (strong,nonatomic) OLTkcsModel *model;

/** 是否是回看状态 */
@property (assign,nonatomic) BOOL backLook;

@end
