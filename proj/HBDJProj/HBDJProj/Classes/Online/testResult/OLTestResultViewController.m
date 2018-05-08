//
//  OLTestResultViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTestResultViewController.h"
#import "OLExamViewController.h"

@interface OLTestResultViewController ()
/** 正确率 */
@property (weak, nonatomic) IBOutlet UILabel *rate;
/** 总题数 */
@property (weak, nonatomic) IBOutlet UIButton *totalCount;
/** 正确数 */
@property (weak, nonatomic) IBOutlet UIButton *rightCount;
/** 错误数 */
@property (weak, nonatomic) IBOutlet UIButton *wrongCount;
/** 耗时 */
@property (weak, nonatomic) IBOutlet UIButton *timeConsume;
/** 回看按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backLook;


@end

@implementation OLTestResultViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_backLook cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_backLook.height / 2];
    [_totalCount cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_totalCount.height / 2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    [_totalCount setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.3]];
}

- (IBAction)close:(id)sender {
    /// MARK: 关闭
    [self lg_dismissViewController];
}

- (IBAction)backLookClick:(UIButton *)sender {
    /// 试题回看
    /// 获取刚才试题的 id 重新打开
    OLExamViewController *backLookExamVc = [OLExamViewController new];
    backLookExamVc.backLook = YES;
//    backLookExamVc.pushWay = self.pushWay;/// 如果打开此行代码，则关闭试题回看页面时，连同成绩页面一起关闭
    [self.navigationController pushViewController:backLookExamVc animated:YES];
}


@end