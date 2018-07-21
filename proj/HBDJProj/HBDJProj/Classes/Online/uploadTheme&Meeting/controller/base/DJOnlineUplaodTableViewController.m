//
//  DJOnlineUplaodTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUplaodTableViewController.h"

#import "DJOnlineUploadTableModel.h"
#import "DJSelectPeopleModel.h"

#import "DJOnlineUplaodBaseCell.h"
#import "DJOnlineUploadCell.h"
#import "DJOnlineUploadAddPeopleCell.h"
#import "DJOnlineUploadAddCoverCell.h"
#import "DJOnlineUploadAddImgCell.h"
#import "DJOnlineUploadSelectMeetingTag.h"

#import "DJSelectDateViewController.h"
#import "DJSelectPeopleViewController.h"
#import "DJSelectMeetingTagViewController.h"
#import "DJInputContentViewController.h"

#import "LGSelectImgManager.h"
#import "HXPhotoPicker.h"
#import "DJOnlineNetorkManager.h"

@interface DJOnlineUplaodTableViewController ()<
DJSelectDateViewControllerDelegate,
DJSelectPeopleViewControllerDelegate,
DJOnlineUploadAddCoverCellDelegate,
DJSelectMeetingTagViewControllerDelegate,
DJOnlineUploadCellDelegate,
DJInputContentViewControllerDelegate>

/** 选择图片管理者 */
@property (strong,nonatomic) LGSelectImgManager *simgr;

@property (strong,nonatomic) HXPhotoManager *coverSelectMgr;
@property (strong,nonatomic) NSURL *coverFileUrl;

@property (strong,nonatomic) HXPhotoView *cellSelectedImageView;

@property (strong,nonatomic) NSArray *allPeople;
/** 出席人员 */
@property (strong,nonatomic) NSMutableArray *peoplePresent;
@property (strong,nonatomic) NSMutableArray *peoplePresentNames;
/** 缺席人员 */
@property (strong,nonatomic) NSMutableArray *peopleAbsent;
@property (strong,nonatomic) NSMutableArray *peopleAbsentNames;
/** 主持人 */
@property (strong,nonatomic) NSMutableArray *peopleHost;

@end

@implementation DJOnlineUplaodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DJOnlineUploadCell class] forCellReuseIdentifier:inputTextCell];
    [self.tableView registerClass:[DJOnlineUploadAddPeopleCell class] forCellReuseIdentifier:addPeopleCell];
    [self.tableView registerClass:[DJOnlineUploadAddCoverCell class] forCellReuseIdentifier:addCoverCell];
    [self.tableView registerClass:[DJOnlineUploadAddImgCell class] forCellReuseIdentifier:addImgCell];
    [self.tableView registerClass:[DJOnlineUploadSelectMeetingTag class] forCellReuseIdentifier:selectMeetingTagCell];
    self.tableView.estimatedRowHeight = 1.0;
    
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(uploadData)];
    self.navigationItem.rightBarButtonItem = send;
    
    _cellSelectedImageView = [[HXPhotoView alloc] initWithManager:self.simgr.hxPhotoManager];
    _cellSelectedImageView.delegate = self.simgr;
    
    NSMutableArray *arrMutable = NSMutableArray.new;
    [DJOnlineNetorkManager.sharedInstance frontUserinfoSuccess:^(id responseObj) {
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            /// 人员为空
            
        }else{
            for (NSInteger i = 0; i < array.count; i++) {
                DJSelectPeopleModel *model = [DJSelectPeopleModel mj_objectWithKeyValues:array[i]];
                
                /// 默认全员出席
                model.attend = DJMemeberAttendTypePresent;
                model.select_present = YES;
                
                [arrMutable addObject:model];
            }
            _allPeople = arrMutable.copy;
        }
    } failure:^(id failureObj) {
        /// 请求失败
        
    }];
}

#pragma mark - 上传数据
- (void)uploadData{
    /// TODO: 上传数据前的判空校验
//    if (!_coverFileUrl) {
//        NSLog(@"请选择封面: ");
//        return;
//    }
    
    /// MARK: 上传内容图片
    /// 如何保证正确的图片顺序？
    __block NSInteger successCount = 0;
    __block NSInteger failureCount = 0;
    
    /** 上传图片完成block */
    NSMutableArray *imageUrls = [NSMutableArray arrayWithArray:self.simgr.tempImageUrls.copy];
    void (^uploadImageCompleteBlock)(NSDictionary *urls) = ^(NSDictionary *urls){
        for (NSInteger i = 0; i < imageUrls.count; i++) {
            imageUrls[i] = urls[[NSString stringWithFormat:@"%ld",i]];
        }
        [self setImagesFormDataWithArray:imageUrls.copy];
        
        /// MARK: 发送上传数据请求
        [self requestUploadSuccess:^(id responseObj) {
            NSLog(@"上传成功: %@",responseObj);
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(id failureObj) {
            NSLog(@"上传失败: %@",failureObj);
        }];

    };
    
    NSMutableDictionary *urlDict = NSMutableDictionary.new;
    for (NSInteger i = 0; i < self.simgr.tempImageUrls.count; i++) {
        NSURL *localUrl = self.simgr.tempImageUrls[i];
        
        [self uploadImageWithLocalFileUrl:localUrl uploadProgress:^(NSProgress *uploadProgress) {
            NSLog(@"%zd: %f",i,(CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSString *imgUrl_sub) {
            [urlDict setValue:imgUrl_sub forKey:[NSString stringWithFormat:@"%zd",i]];
            successCount++;
            if ((successCount + failureCount) == self.simgr.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        } failure:^(id uploadFailure) {
            [urlDict setValue:[NSString stringWithFormat:@"第%zd张图上传失败",i] forKey:[NSString stringWithFormat:@"%ld",i]];
            failureCount++;
            
            if ((successCount + failureCount) == self.simgr.tempImageUrls.count) {
                uploadImageCompleteBlock(urlDict.copy);
            }
            
        }];
    }
        
}

/// MARK: DJOnlineUploadAddCoverCell 添加封面 代理方法
- (void)addCoverClick:(DJOnlineUploadAddCoverCell *)cell{
    
    [self hx_presentAlbumListViewControllerWithManager:self.coverSelectMgr done:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL original, HXAlbumListViewController *viewController) {
        
        [HXPhotoTools selectListWriteToTempPath:photoList requestList:^(NSArray *imageRequestIds, NSArray *videoSessions) {
        } completion:^(NSArray<NSURL *> *allUrl, NSArray<NSURL *> *imageUrls, NSArray<NSURL *> *videoUrls) {
            /// 选择完成之后需要做  件事
            /// 1.更新UI
            /// 2.保存封面图片的本地临时路径
            if (imageUrls.count) {
                _coverFileUrl = imageUrls[0];
                
                /// MARK: 上传封面
                [self uploadImageWithLocalFileUrl:_coverFileUrl uploadProgress:^(NSProgress *uploadProgress) {
                    NSLog(@"上传封面: %f",
                          (CGFloat)uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                } success:^(NSString *imgUrl_sub) {
                    NSLog(@"上传封面成功: %@",imgUrl_sub);
                    /// 主题党日 index == 7，三会一课 index == 8
                    /// 子类分别实现
                    [self setCoverFormDataWithUrl:imgUrl_sub];
                } failure:^(id uploadFailure) {
                    NSLog(@"上传封面失败: %@",uploadFailure);
                }];
                
                cell.model.coverBackUrl = _coverFileUrl;
                [self.tableView reloadData];
            }
        } error:^{
            NSLog(@"selectPhotoError");
        }];
        
    } cancel:^(HXAlbumListViewController *viewController) {
        
    }];
}

/// MARK: DJOnlineUploadCellDelegate 弹出文本输入框
- (void)userWantBeginInputWithModel:(DJOnlineUploadTableModel *)model cell:(DJOnlineUploadCell *)cell{
    [self presentViewController:[DJInputContentViewController modalInputvcWithModel:model delegate:self] animated:YES completion:nil];
}
/// MARK: DJInputContentViewControllerDelegate 输入文本代理回调
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model{
    [self.formDataDict setValue:model.content forKey:model.uploadJsonKey];
    [self.tableView reloadData];
}

#pragma mark -  setter
/// MARK: 暴露给cell，改变表单的值
- (void)setFormDataDictValue:(nonnull id)value indexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    NSString *key = model.uploadJsonKey;
    [self.formDataDict setValue:value forKey:key];
}

#pragma mark - delegate
/// MARK: tableview datasource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    
    DJOnlineUplaodBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJOnlineUplaodBaseCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.vc = self;
    cell.model = model;
    if ([cell isMemberOfClass:[DJOnlineUploadAddImgCell class]]) {
        DJOnlineUploadAddImgCell *addImageCell = (DJOnlineUploadAddImgCell *)cell;
        addImageCell.photoView = _cellSelectedImageView;
    }
    if ([cell isMemberOfClass:[DJOnlineUploadAddCoverCell class]]) {
        DJOnlineUploadAddCoverCell *addCoverCell = (DJOnlineUploadAddCoverCell *)cell;
        addCoverCell.delegate = self;
    }
    if ([cell isMemberOfClass:[DJOnlineUploadCell class]]) {
        DJOnlineUploadCell *textInputCell = (DJOnlineUploadCell *)cell;
        textInputCell.delegate = self;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *model = self.dataArray[indexPath.row];
    switch (model.itemClass) {
        case OLUploadTableModelClassSelectTime:{
            DJSelectDateViewController *selectTime = DJSelectDateViewController.new;
            selectTime.delegate = self;
            selectTime.cellIndex = indexPath;
            selectTime.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:selectTime animated:YES completion:nil];
        }
            break;
        case OLUploadTableModelClassSelectPeopleNotCome:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeAbsent model:model];
        }
            break;
        case OLUploadTableModelClassSelectPeople:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypePresent model:model];
        }
            break;
        case OLUploadTableModelClassSelectCover:NSLog(@"封面: ");
            break;
        case OLUploadTableModelClassSelectImage:NSLog(@"会议图片: ");
            break;
        case OLUploadTableModelClassSelectMeetingTag:{
            /// 选择会议标签
            DJSelectMeetingTagViewController *selectMeetingTag = DJSelectMeetingTagViewController.new;
            selectMeetingTag.delegate = self;
            selectMeetingTag.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:selectMeetingTag animated:YES completion:nil];
        }
        case OLUploadTableModelClassSelectHost:{
            [self selectPeopleVcWithSpType:DJSelectPeopleTypeHost model:model];
        }
        default:
            break;
    }
}

/// MARK: DJSelectDateViewController 选择日期回调
- (void)selectDate:(DJSelectDateViewController *)vc dateString:(NSString *)dateString cellIndex:(NSIndexPath *)cellIndex{
    DJOnlineUploadTableModel *model = self.dataArray[cellIndex.row];
    model.content = dateString;
    [self setFormDataDictValue:dateString indexPath:cellIndex];
    
}
/// MARK: DJSelectPeopleViewControllerDelegate 选人回调
- (void)selectPeopleDone:(DJSelectPeopleViewController *)vc model:(DJOnlineUploadTableModel *)model spType:(DJSelectPeopleType)spType{
    
    [self.peoplePresent removeAllObjects];
    [self.peoplePresentNames removeAllObjects];
    [self.peopleAbsent removeAllObjects];
    [self.peopleAbsentNames removeAllObjects];
    
    for (int i = 0; i < self.allPeople.count; i++) {
        DJSelectPeopleModel *model = self.allPeople[i];
        if (model.select_present) {
            /// 出席人员
            [self.peoplePresent addObject:@(model.seqid)];
            [self.peoplePresentNames addObject:model.name];
        }
        if (model.select_absent) {
            /// 缺席人员
            [self.peopleAbsent addObject:@(model.seqid)];
            [self.peopleAbsentNames addObject:model.name];
        }
    }
    NSString *peoples;
    NSString *peopleNames;
    switch (spType) {
        case DJSelectPeopleTypePresent:{
            peoples = [self.peoplePresent componentsJoinedByString:@","];
            peopleNames = [self.peoplePresentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeAbsent:{
            peoples = [self.peopleAbsent componentsJoinedByString:@","];
            peopleNames = [self.peopleAbsentNames componentsJoinedByString:@"、"];
        }
            break;
        case DJSelectPeopleTypeHost:{
            peoples = [NSString stringWithFormat:@"%zd",model.seqid];
            peopleNames = model.content;
        }
            break;
    }
    [self.formDataDict setValue:peoples forKey:model.uploadJsonKey]; /// 提交给后台的数据 人的id
    model.content = peopleNames;/// 显示在页面上的数据 name
    /// 更新cell中的数据
    [self.tableView reloadData];
}


#pragma mark - 私有方法
- (void)selectPeopleVcWithSpType:(DJSelectPeopleType)spType model:(DJOnlineUploadTableModel *)model{
    switch (spType) {
        case DJSelectPeopleTypePresent:
            [self.peoplePresent removeAllObjects];
            break;
        case DJSelectPeopleTypeAbsent:
            [self.peopleAbsent removeAllObjects];
            break;
        case DJSelectPeopleTypeHost:
            
            break;
    }
    /// MARK: 创建并弹出选人控制器
    DJSelectPeopleViewController *selectPeople = DJSelectPeopleViewController.new;
    selectPeople.model = model;
    selectPeople.spType = spType;
    selectPeople.delegate = self;
    selectPeople.allPeople = self.allPeople;
    selectPeople.pushWay = LGBaseViewControllerPushWayModal;
    selectPeople.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:selectPeople animated:YES completion:nil];
    
}

- (void)uploadImageWithLocalFileUrl:(NSURL *)localFileUrl uploadProgress:(LGUploadImageProgressBlock)progress success:(LGUploadImageSuccess)success failure:(LGUploadImageFailure)failure{
    [[DJOnlineNetorkManager sharedInstance] uploadImageWithLocalFileUrl:localFileUrl uploadProgress:progress success:success failure:failure];
}

#pragma mark - lazy load & getter
- (LGSelectImgManager *)simgr{
    if (!_simgr) {
        _simgr = LGSelectImgManager.new;
    }
    return _simgr;
}
- (NSMutableDictionary *)formDataDict{
    if (!_formDataDict) {
        _formDataDict = NSMutableDictionary.new;
    }
    return _formDataDict;
}
- (HXPhotoManager *)coverSelectMgr {
    if (!_coverSelectMgr) {
        _coverSelectMgr = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _coverSelectMgr.configuration.singleSelected = YES;
        _coverSelectMgr.configuration.albumListTableView = ^(UITableView *tableView) {
        };
        _coverSelectMgr.configuration.singleJumpEdit = YES;
        _coverSelectMgr.configuration.movableCropBox = YES;
        _coverSelectMgr.configuration.movableCropBoxEditSize = YES;
    }
    return _coverSelectMgr;
}
- (NSMutableArray *)peoplePresent{
    if (!_peoplePresent) {
        _peoplePresent = NSMutableArray.new;
    }
    return _peoplePresent;
}
- (NSMutableArray *)peoplePresentNames{
    if (!_peoplePresentNames) {
        _peoplePresentNames = NSMutableArray.new;
    }
    return _peoplePresentNames;
}
- (NSMutableArray *)peopleAbsent{
    if (!_peopleAbsent) {
        _peopleAbsent = NSMutableArray.new;
    }
    return _peopleAbsent;
}
- (NSMutableArray *)peopleAbsentNames{
    if (!_peopleAbsentNames) {
        _peopleAbsentNames = NSMutableArray.new;
    }
    return _peopleAbsentNames;
}
- (NSMutableArray *)peopleHost{
    if (!_peopleHost) {
        _peopleHost = NSMutableArray.new;
    }
    return _peopleHost;
}

/// MARK: DJSelectMeetingTagViewControllerDelegate 选择会议标签回调
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
    /// 父类不处理
}

/// 给子类实现
- (void)requestUploadSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure{
    
}
- (void)setCoverFormDataWithUrl:(NSString *)url{
    
}
- (void)setImagesFormDataWithArray:(NSArray *)imgUrls{
    
}

@end