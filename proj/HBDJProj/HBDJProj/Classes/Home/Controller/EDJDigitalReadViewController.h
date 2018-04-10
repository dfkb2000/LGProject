//
//  EDJDigitalReadViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGObject.h"
@class LIGCollectionViewFlowLayout;

@interface EDJDigitalReadViewController : LIGObject<
UICollectionViewDataSource
>

@property (strong,nonatomic) LIGCollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *digitalModels;

@end