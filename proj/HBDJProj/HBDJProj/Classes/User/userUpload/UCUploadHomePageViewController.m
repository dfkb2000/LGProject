//
//  UCUploadHomePageViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadHomePageViewController.h"
#import "UCPartyMemberStageController.h"
#import "UCPartyMemberStageModel.h"
#import "UCUploadTransitionView.h"
#import "UCMemberStageTransitionView.h"
#import "UCUploadViewController.h"
#import "LGBaseNavigationController.h"

@interface UCUploadHomePageViewController ()<
UCUploadTransitionViewDelegate,
UCMemberStageTransitionViewDelegate
>

@end

@implementation UCUploadHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    [super configUI];
    self.title = @"我的上传";
    
    /// 导航栏 右按钮

    /// nav item
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_icon_remove"] style:UIBarButtonItemStyleDone target:self action:@selector(navDeleteClick)];
    UIBarButtonItem *upload = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"uc_icon_nav_item_upload"] style:UIBarButtonItemStyleDone target:self action:@selector(navUploadClick)];
    self.navigationItem.rightBarButtonItems = @[upload,delete];
}

#pragma mark - UCUploadTransitionViewDelegate
- (void)utViewClose:(UCUploadTransitionView *)utView{
    [utView removeFromSuperview];
    utView = nil;
}
- (void)utView:(UCUploadTransitionView *)utView action:(UploadTransitionAction)action{
    [utView removeFromSuperview];
    utView = nil;
    switch (action) {
        case UploadTransitionActionMemeberStage:{
            UCMemberStageTransitionView *mstView = [UCMemberStageTransitionView memberStateTransitionView];
            mstView.delegate = self;
            CGFloat mstH = kScreenHeight + kStatusBarHeight;
            if (kScreenHeight == 812) {
                mstH += 34;
            }
            mstView.frame = CGRectMake(0, -kStatusBarHeight, kScreenWidth, mstH);
//            [self.view addSubview:mstView];
            /// TODO:添加到self.view上 无法遮挡导航栏，所以 暂时加到 keywindow上，不是最优解
            [[UIApplication sharedApplication].keyWindow addSubview:mstView];

        }
            break;
        case UploadTransitionActionMindReport:{
            [self editToUploadWithType:UploadTyleMindReport];
        }
            break;
        case UploadTransitionActionSpeakCheap:{
            [self editToUploadWithType:UploadTyleSpeakCheap];
        }
            break;
        
    }
}

#pragma mark - UCMemberStageTransitionViewDelegate
- (void)mstViewClose:(UCMemberStageTransitionView *)mstView{
    [mstView removeFromSuperview];
    mstView = nil;
}
- (void)mstView:(UCMemberStageTransitionView *)mstView action:(UCMemberStageTransitionViewAction)action{
    NSLog(@"action -- %ld",action);
    [mstView removeFromSuperview];
    mstView = nil;
    [self editToUploadWithType:UploadTyleMemberStage];
}

#pragma mark - target
- (void)navDeleteClick{
    
}
- (void)navUploadClick{
    UCUploadTransitionView *utv = [UCUploadTransitionView uploadTransitionView];
    utv.delegate = self;
    utv.frame = self.view.bounds;
    [self.view addSubview:utv];
}

- (void)viewSwitched:(NSInteger)index{
    NSLog(@"index -- %ld",index);
}

#pragma mark - getter
- (NSArray<NSDictionary *> *)segmentItems{
    return @[@{LGSegmentItemNameKey:@"党员舞台",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               },
             @{LGSegmentItemNameKey:@"思想汇报",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               },
             @{LGSegmentItemNameKey:@"述廉报告",
               LGSegmentItemViewControllerClassKey:@"UCPartyMemberStageController",
               LGSegmentItemViewControllerInitTypeKey:LGSegmentVcInitTypeStoryboard
               }];
}

#pragma mark - 私有方法
- (void)editToUploadWithType:(UploadTyle)uploadType{
    UCUploadViewController *upvc = [UCUploadViewController new];
    upvc.uploadType = uploadType;
    LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:upvc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
