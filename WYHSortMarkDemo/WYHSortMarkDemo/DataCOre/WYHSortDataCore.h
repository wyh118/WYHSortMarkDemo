//
//  WYHSortDataCore.h
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYHSortDataCore : NSObject

/**
 获取显示在主页的分类
 @param complateBlock 成功回调
 @param faileBlock 失败回调
 @param errorBlock 错误回调
*/
- (void)handleShowSort:(void(^)(NSArray *displayDatas,NSArray *noDisplayDatas))complateBlock failed:(void(^)(NSString *failInfo))faileBlock error:(void(^)(NSError *error))errorBlock;
/**
 处理分类更新数据变化
 @param indexPath indexPath description
 @param complateBlock complateBlock description
*/
- (void)handleUpdateSortAtIndexPath:(NSIndexPath *)indexPath complete:(void(^)(NSArray *displayDatas,NSArray *noDisplayDatas,NSInteger row))complateBlock;
/**
 正在拖拽item
 @param fromIndexPath 当前的位置的索引
 @param toIndexPath 将要移动到位置的索引
*/
- (void)handleDragingItemChanged:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath complete:(void(^)(NSArray *displayDatas))complateBlock;

@end

NS_ASSUME_NONNULL_END
