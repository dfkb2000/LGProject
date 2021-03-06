//
//  DJHomeSearchAlbumCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "DJHomeSearchAlbumCell.h"
#import "EDJMicroLessionAlbumModel.h"

@interface DJHomeSearchAlbumCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;


@end

@implementation DJHomeSearchAlbumCell

- (void)setModel:(EDJMicroLessionAlbumModel *)model{
    _model = model;
    _title.text = model.classname;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

@end
