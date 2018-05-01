//
//  EDJMicroPartyLessonSubCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessonSubCell.h"
#import "EDJMicroPartyLessionSubModel.h"

@interface EDJMicroPartyLessonSubCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIImageView *img;


@end

@implementation EDJMicroPartyLessonSubCell
- (void)setModel:(EDJMicroPartyLessionSubModel *)model{
    _model = model;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end