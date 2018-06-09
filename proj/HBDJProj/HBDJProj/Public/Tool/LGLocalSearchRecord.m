//
//  LGLocalSearchRecord.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGLocalSearchRecord.h"

@interface LGLocalSearchRecord ()
@property (strong,nonatomic) NSString *rootDirectory;
@property (strong,nonatomic) NSString *filePath;
@property (strong,nonatomic) NSString *directoryPath;
@property (strong,nonatomic) NSFileManager *manager;

@property (strong,nonatomic) NSString *userid;
@property (assign,nonatomic) SearchRecordExePart currentExePart;

@end

@implementation LGLocalSearchRecord

+ (NSArray *)getLocalRecordWithUserid:(NSString *)userid part:(SearchRecordExePart)part{
    return [[self sharedInstance] getLocalRecordWithUserid:userid part:part];
}
- (NSArray *)getLocalRecordWithUserid:(NSString *)userid part:(SearchRecordExePart)part{
    _currentExePart = part;
    _userid = userid;
    
    NSDictionary *record = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    NSLog(@"userid: %@,:%@,lg_record: %@",userid,[self currentExePartWith:part],record.allValues);
    
    return record.allValues;
}
/**
 添加新的历史记录（向本地文件中）

 @param content 用户输入的内容
 @param part 当前模块，首页：home
 */
+ (void)addNewRecordWithContent:(NSString *)content part:(SearchRecordExePart)part userid:(NSString *)userid{
    [[self sharedInstance] addNewRecordWithContent:content part:part userid:userid];
}
- (void)addNewRecordWithContent:(NSString *)content part:(SearchRecordExePart)part userid:(NSString *)userid{
    _currentExePart = part;
    _userid = userid;
    
    /// 1.判断、创建目录 --> 判断、创建 文件
    [self createDirectoryPath];
    
    /// 2.写入数据
    /// 获取本地文件
    NSDictionary *record = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
    NSLog(@"写入之前record -- %@",record);
    /// 建立新的字典
    NSMutableDictionary *recordMutable = [NSMutableDictionary dictionaryWithDictionary:record];
    /// 获取新内容的index
    NSInteger index = record.allKeys.count;
    /// 拼接新内容的key
    NSString *key = [self recordKeyWithUserid:userid part:part index:index];
    /// 赋值
    recordMutable[key] = content;
    /// 写入
    BOOL write = [recordMutable writeToFile:self.filePath atomically:YES];
    if (write) {
        NSDictionary *record = [NSDictionary dictionaryWithContentsOfFile:self.filePath];
        NSLog(@"写入成功 -- %d: %@",write,record);
    }
}

- (void)createDirectoryPath{
    /// 先创建目录，再创建文件
    BOOL isDirectory;
    BOOL directoryExist = [self.manager fileExistsAtPath:self.directoryPath isDirectory:&isDirectory];
    /// 判断目录是否存在，如果存在，直接创建文件
    
    if (directoryExist) {
        [self createFilePath];
    }else{
        /// 否则 先创建目录，再创建文件
        NSError *error;
        BOOL createDirectory = [self.manager createDirectoryAtPath:self.directoryPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (createDirectory) {
            NSLog(@"创建路径成功: %@",self.directoryPath);
            [self createFilePath];
        }else{
            NSLog(@"创建路径失败: %@",error);
        }
    }
}
- (void)createFilePath{
    if (![self isExist:self.filePath]) {
        BOOL createPath = [self.manager createFileAtPath:self.filePath contents:nil attributes:nil];
        NSLog(@"创建本地搜索记录文件，1成功，0失败-- %d",createPath);
    }else{
        NSLog(@"本地搜索记录文件已存在，路径为 -- %@",self.filePath);
    }
}

-(NSString *)rootDirectory{
    if (!_rootDirectory) {
        _rootDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _rootDirectory;
}
/// directoryPath 和 filePath 可能会变化，所以不能懒加载，而是每次都生成新的值
- (NSString *)directoryPath{
    return [self.rootDirectory stringByAppendingString:[NSString stringWithFormat:@"/lg_search_record/%@",self.userid]];
}
- (NSString *)filePath{
    /// 路径为：library/record/"userid"/home.plist 或者 library/record/"userid"/discovery.plist
    return [self.directoryPath stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",[self currentExePartWith:_currentExePart]]];
}
- (NSFileManager *)manager{
    if (!_manager) {
        _manager = [NSFileManager defaultManager];
    }
    return _manager;
}

- (NSString *)currentExePartWith:(SearchRecordExePart)part{
    switch (part) {
        case SearchRecordExePartHome:
            return @"home";
            break;
        case SearchRecordExePartDiscovery:
            return @"discovery";
            break;
    }
    
}

/**
 搜索记录的key
 /// userid,模块_index
 /// 例如: userid == 123, 模块为首页,index == 0 key: userid_123,home_1;
 

 @param userid 当前用户id
 @param part 搜索模块，首页，发现等
 @param index 此条记录的索引
 @return 返回目标key值
 */
- (NSString *)recordKeyWithUserid:(NSString *)userid part:(SearchRecordExePart)part index:(NSInteger)index{
    return [NSString stringWithFormat:@"userid_%@,%@_%ld",userid,[self currentExePartWith:part],index];
}
- (BOOL)isExist:(NSString *)path{
    return [self.manager fileExistsAtPath:path];
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
