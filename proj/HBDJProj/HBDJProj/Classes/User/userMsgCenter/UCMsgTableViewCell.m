//
//  UCMsgTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMsgTableViewCell.h"
#import "UCMsgModel.h"

static NSString * const showAll_keyPath = @"showAll";
static NSString * const isread_key = @"isread";

@interface UCMsgTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyReadIcon;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;


@end

@implementation UCMsgTableViewCell

- (IBAction)showAll:(UIButton *)sender {
    self.model.showAll = !self.model.showAll;
    if ([self.delegate respondsToSelector:@selector(ucmsgCellShowAllWithIndexPath:)]) {
        [self.delegate ucmsgCellShowAllWithIndexPath:self.model.indexPath];
    }
}

+ (NSString *)cellReuseIdWithModel:(UCMsgModel *)model{
    if (model.isEdit) {
        return msgEditCell;
    }else{
        return msgCell;
    }
}

- (void)setModel:(UCMsgModel *)model{
    _model = model;
    _content.text = model.content;
    if (model.noticetype == UCMsgModelResourceTypeCustom) {
        _content.text = model.title;
    }
    
    _showAllButton.selected = model.showAll;
    if (model.createdtime.length > length_timeString_1) {
        _time.text = [model.createdtime substringToIndex:length_timeString_1];
    }
    if (model.showAll) {
        _content.numberOfLines = 0;
    }else{
        _content.numberOfLines = 2;
    }
    /// 已读，不显示小红点
    /// 未读，显示小红点
    _alreadyReadIcon.hidden = model.isread;
    
    [model addObserver:self forKeyPath:isread_key options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:isread_key] && object == self.model) {
        _alreadyReadIcon.hidden = self.model.isread;
    }
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:isread_key];
}

@end
