//
//  UCPartyMemberStageCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 该cell位于 storyboard中

#import "LGBaseTableViewCell.h"
@class UCPartyMemberStageModel;

@interface UCPartyMemberStageCell : LGBaseTableViewCell
@property (strong,nonatomic) UCPartyMemberStageModel *model;

@end
