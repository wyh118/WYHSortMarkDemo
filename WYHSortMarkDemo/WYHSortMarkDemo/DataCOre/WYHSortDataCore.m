//
//  WYHSortDataCore.m
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import "WYHSortDataCore.h"
#import  <UIKit/UIKit.h>

#define StringNotEmpty(str) (str && ![str isKindOfClass:[NSNull class]] && (((NSString *)str).length > 0))

@interface WYHSortDataCore()

//沙盒目录下存储分类文件的文件夹地址
@property (nonatomic, strong) NSString *directoryPath;
//沙盒目录下存储全部分类的地址
@property (nonatomic, strong) NSString *allPlistPath;
//沙盒目录下存储可显示分类的地址
@property (nonatomic, strong) NSString *displayPlistPath;
//减少的分类数组
@property (nonatomic, strong) NSMutableArray *reduceObjects;
//添加的分类数组
@property (nonatomic, strong) NSMutableArray *addObjects;
//已显示分类数据
@property (nonatomic, strong) NSMutableArray *displayArray;
//未显示分类数据
@property (nonatomic, strong) NSMutableArray *noDisplayArray;
//全部分类数据
@property (nonatomic, strong) NSMutableArray *allSortArray;

@end

@implementation WYHSortDataCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        //需要添加元素
        _addObjects = [[NSMutableArray alloc] init];
        //需要减少元素
        _reduceObjects = [[NSMutableArray alloc] init];
        //内存存储已显示分类
        _displayArray = [[NSMutableArray alloc] init];
        //内存存储未显示分类
        _noDisplayArray = [[NSMutableArray alloc] init];
        //内存存储全部分类
        _allSortArray = [[NSMutableArray alloc] init];
    }
    return self;
}

/// 获取plist文件储存的分类数据
/// @param path allPlistPath：全部分类；displayPlistPath：可显示的分类;
- (NSArray *)getSortPlistData:(NSString *)path
{
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    return array;
}

/// 判断本地数据与服务端数据是否相同
/// @param locals 本地数据
/// @param remotes 服务器返回数据
- (BOOL)equalLocal:(NSArray *)locals remote:(NSArray *)remotes
{
    //查询到在locals中，不在数组remotes中的数据
    NSPredicate *localFilterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",remotes];
    NSArray *localFilter = [locals filteredArrayUsingPredicate:localFilterPredicate];
    [self.reduceObjects addObjectsFromArray:localFilter];
    
    //查询到在remotes中，不在数组locals中的数据
    NSPredicate *remoteFilterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",locals];
    NSArray *remoteFilter = [remotes filteredArrayUsingPredicate:remoteFilterPredicate];
    [self.addObjects addObjectsFromArray:remoteFilter];
    
    //拼接数组,所有变化的数据，若array内容为空，则数组未改变
    NSMutableArray *array = [NSMutableArray arrayWithArray:localFilter];
    [array addObjectsFromArray:remoteFilter];
    
    if (array.count>0) {
        return YES;
    }
    return NO;
}

/// 创建沙盒文件
- (BOOL)createSortFilePath
{
    //Document创建目录
    NSString *documnetPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sortFilePath = [documnetPath stringByAppendingPathComponent:@"wisetvSort"];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:sortFilePath isDirectory:&isDirectory]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:sortFilePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!error) {
            [self createRelatedPlistPath:sortFilePath];
            return YES;
        }
    }
    else{
       [self createRelatedPlistPath:sortFilePath];
        return YES;
    }
    return NO;
}

- (void)createRelatedPlistPath:(NSString *)sortFilePath
{
    self.directoryPath = sortFilePath;
    self.allPlistPath = [self createAllPlistFile:sortFilePath];
    self.displayPlistPath = [self createDisplayPlistFile:sortFilePath];
}

//创建全部分类数据plist
- (NSString *)createAllPlistFile:(NSString *)path
{
    NSString *sortPlistPath = [path stringByAppendingPathComponent:@"allSort.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:sortPlistPath]) {
        BOOL res = [[NSFileManager defaultManager] createFileAtPath:sortPlistPath contents:nil attributes:nil];
        if (res) {
            return sortPlistPath;
        }
    }
    else{
        return sortPlistPath;
    }
    return nil;
}

//创建已显示数据plist
- (NSString *)createDisplayPlistFile:(NSString *)path
{
    NSString *displayPlistPath = [path stringByAppendingPathComponent:@"displaySort.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:displayPlistPath]) {
        BOOL res = [[NSFileManager defaultManager] createFileAtPath:displayPlistPath contents:nil attributes:nil];
        if (res) {
            return displayPlistPath;
        }
    }
    else{
        return displayPlistPath;
    }
    return nil;
}

//保存数据到沙盒目录
- (BOOL)saveSortData:(NSArray *)datas plistPath:(NSString *)path;
{
    if ([self createSortFilePath]) {
       if (StringNotEmpty(path)) {
           BOOL result = [datas writeToFile:path atomically:YES];
           return result;
       }
    }
    return NO;
}

- (NSString *)allPlistPath
{
    if (!_allPlistPath) {
        [self createSortFilePath];
    }
    return _allPlistPath;
}

- (NSString *)displayPlistPath
{
    if (!_displayPlistPath) {
        [self createSortFilePath];
    }
    return _displayPlistPath;
}

/// 获取未显示数据
- (NSArray *)getNoDisplayArray
{
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.displayArray];
    NSArray *resultArray = [self.allSortArray filteredArrayUsingPredicate:filterPredicate];
    return resultArray;
}

/// 获取显示在主页的分类
/// @param complateBlock 成功回调
/// @param faileBlock 失败回调
/// @param errorBlock 错误回调
- (void)handleShowSort:(void(^)(NSArray *displayDatas,NSArray *noDisplayDatas))complateBlock failed:(void(^)(NSString *failInfo))faileBlock error:(void(^)(NSError *error))errorBlock
{
    //读取沙盒中存储的需要显示分类数据
    NSMutableArray *displaySortCashs = [NSMutableArray arrayWithArray:[self getSortPlistData:self.displayPlistPath]];
    //读取沙盒中存储的需要所有分类数据
    NSArray *sortAllCashs = [self getSortPlistData:self.allPlistPath];

    if(displaySortCashs.count > 0){
        //如果沙盒中存储显示的分类数据，则立即显示本地储存的分类数据
        self.displayArray = displaySortCashs;
        [self.allSortArray setArray:sortAllCashs];
        [self.noDisplayArray setArray:[self getNoDisplayArray]];
        complateBlock(self.displayArray,self.noDisplayArray);
    }
    //无论沙盒中是否存有需要显示的分类数据，都要向服务端请求新数据
    //如果新数据有变化（增、删），需要更新本地存储的全部分类数据（下次启动App显示变化项）
    //如果数据没有变化，则不需要更新本地存储的全部分类数据
    /***************************************/
    //如果自己有服务端数据需要再这个地方进行h网络请求，数据返回后再做相应处理
    __weak typeof(self) weakSelf = self;
    [self requestAllCategory:^(NSArray *results) {
        __strong typeof(self) strongSelf = weakSelf;
        //中间桥接数组
        NSMutableArray *bridglist = [[NSMutableArray alloc] init];
        //存储到沙盒plist的全部分类数据
        NSMutableArray *saveAllList = [[NSMutableArray alloc] init];
        if (sortAllCashs) {
            [bridglist setArray:sortAllCashs];
        }
        if (sortAllCashs.count > 0) {
            if ([strongSelf equalLocal:sortAllCashs remote:results]) {
                if (strongSelf.addObjects.count > 0) {
                    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, strongSelf.addObjects.count)];
                    [bridglist insertObjects:strongSelf.addObjects atIndexes:indexSet];
                }
                if (strongSelf.reduceObjects.count > 0) {
                    [bridglist removeObjectsInArray:strongSelf.reduceObjects];
                }
                saveAllList = bridglist;
                NSMutableArray *saveNoDisplaylist = [[NSMutableArray alloc] initWithArray:saveAllList];
                [saveNoDisplaylist removeObjectsInArray:displaySortCashs];
                [strongSelf saveSortData:saveAllList plistPath:strongSelf.allPlistPath];
            }
        }
        else{
            //第一次启动存储到本地数据库
            [saveAllList setArray:results];
            //暂时处理：取所有数据的第一位
            NSIndexSet *firstIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)];
            NSArray *firstSorts = [saveAllList objectsAtIndexes:firstIndexSet];

            [strongSelf.displayArray setArray:firstSorts];
            strongSelf.allSortArray = saveAllList;
            [strongSelf.noDisplayArray setArray:[strongSelf getNoDisplayArray]];
            complateBlock(strongSelf.displayArray,strongSelf.noDisplayArray);
            [strongSelf saveSortData:saveAllList plistPath:strongSelf.allPlistPath];
            [strongSelf saveSortData:firstSorts plistPath:strongSelf.displayPlistPath];
        }
    } failed:^(NSString *failInfo) {
        faileBlock(failInfo);
    } error:^(NSError *error) {
        errorBlock(error);
    }];
    
}

//获取全部分类
- (void)requestAllCategory:(void(^)(NSArray *results))complateBlock failed:(void(^)(NSString *failInfo))faileBlock error:(void(^)(NSError *error))errorBlock
{
    //测试数据
    NSArray *array = @[@"精选",@"要闻",@"河北",@"财经",@"娱乐",@"体育",@"社会",@"NBA",@"视频",@"汽车",@"图片",@"科技",@"军事",@"国际",@"数码",@"星座",@"电影",@"时尚",@"文化",@"游戏",@"教育",@"动漫",@"政务",@"纪录片",@"房产",@"佛学",@"股票",@"理财",@"小说",@"NBA",@"战疫",@"陈情令"];
    complateBlock(array);
}

/**
 处理分类更新数据变化
 @param indexPath indexPath description
 @param complateBlock complateBlock description
*/
- (void)handleUpdateSortAtIndexPath:(NSIndexPath *)indexPath complete:(void(^)(NSArray *displayDatas,NSArray *noDisplayDatas,NSInteger row))complateBlock
{
    NSInteger row = 0;
    if (indexPath.section == 0) {
        id obj = [self.displayArray objectAtIndex:indexPath.row];
        [self.displayArray removeObject:obj];
        [self.noDisplayArray setArray:[self getNoDisplayArray]];
        row = [self.noDisplayArray indexOfObject:obj];
    }
    else if (indexPath.section == 1){
        id obj = [self.noDisplayArray objectAtIndex:indexPath.row];
        [self.displayArray addObject:obj];
        [self.noDisplayArray setArray:[self getNoDisplayArray]];
        row = self.displayArray.count - 1;
    }
    [self saveSortData:self.displayArray plistPath:self.displayPlistPath];
    complateBlock(self.displayArray,self.noDisplayArray,row);
}

/**
 正在拖拽item
 @param fromIndexPath 当前的位置的索引
 @param toIndexPath 将要移动到位置的索引
*/
- (void)handleDragingItemChanged:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath complete:(void(^)(NSArray *displayDatas))complateBlock
{
    id obj = [self.displayArray objectAtIndex:fromIndexPath.row];
    [self.displayArray removeObject:obj];
    [self.displayArray insertObject:obj atIndex:toIndexPath.row];
    complateBlock(self.displayArray);
}

@end
