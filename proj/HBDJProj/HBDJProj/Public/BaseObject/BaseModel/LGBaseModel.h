//
//  LIGBaseModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface LGBaseModel : NSObject

+ (NSArray *)loadLocalPlist;
+ (NSArray *)loadLocalPlistWithPlistName:(NSString *)plistName;

@end
