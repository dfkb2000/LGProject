//
//  EDJLeverInfoHeaderView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJLeverInfoHeaderView.h"

@interface EDJLeverInfoHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *torayScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *todayScoreArrow;

@property (weak, nonatomic) IBOutlet UIImageView *levelInfoArrow;
@property (weak, nonatomic) IBOutlet UILabel *levelInfoLabel;

@end

@implementation EDJLeverInfoHeaderView

- (IBAction)todayScore:(UIButton *)sender {
    /// MARK: 今日加分
    if ([self.delegate respondsToSelector:@selector(levelInfoHeaderCLick:itemTag:)]) {
        [self.delegate levelInfoHeaderCLick:self itemTag:sender.tag];
    }
}

- (IBAction)levelInfoClick:(UIButton *)sender {
    /// MARK: 点击等级介绍
    if ([self.delegate respondsToSelector:@selector(levelInfoHeaderCLick:itemTag:)]) {
        [self.delegate levelInfoHeaderCLick:self itemTag:sender.tag];
    }
}

+ (instancetype)levelInfoHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"EDJLeverInfoHeader" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self customConfig];
}

- (void)customConfig{
    _levelInfoArrow.transform = CGAffineTransformMakeRotation(M_PI);
    _todayScoreArrow.transform = CGAffineTransformMakeRotation(M_PI);
}

@end
