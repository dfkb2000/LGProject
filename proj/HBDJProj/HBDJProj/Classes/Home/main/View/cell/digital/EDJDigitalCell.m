//
//  EDJDigitalCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDigitalCell.h"
#import "EDJDigitalModel.h"

@interface EDJDigitalCell ()
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation EDJDigitalCell

- (void)setModel:(EDJDigitalModel *)model{
    _model = model;
    [_cover sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:DJDigitalBookPImage];
    _title.text = model.ebookname;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_cover cutBorderWithBorderWidth:0.5 borderColor:UIColor.blackColor cornerRadius:0];
}

@end
