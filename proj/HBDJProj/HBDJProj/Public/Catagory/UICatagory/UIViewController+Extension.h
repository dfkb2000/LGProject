//
//  UIViewController+Extension.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

//- (NSArray *)callBackCommenHandleWithOffset:(NSInteger)offset tableView:(UITableView *)tableView keyvalueArray:(NSArray *)keyvalueArray dataArray:(NSArray *)dataArray modelClass:(NSString *)modelClass;

- (UIViewController *)lgInstantiateViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId;
- (void)lgPushViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId animated:(BOOL)animated;
- (void)lgPushViewControllerWithClassName:(NSString *)className;
@end
