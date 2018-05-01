//
//  LGThreeRightButtonView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const TRConfigTitleKey = @"TRConfigTitleKey";
static NSString * const TRConfigImgNameKey = @"TRConfigImgNameKey";
static NSString * const TRConfigSelectedImgNameKey = @"TRConfigSelectedImgNameKey";

@interface LGThreeRightButtonView : UIView

@property (weak,nonatomic) NSArray<NSDictionary *> *btnConfigs;

@end