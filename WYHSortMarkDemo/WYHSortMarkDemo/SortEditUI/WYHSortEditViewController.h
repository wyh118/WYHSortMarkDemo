//
//  WYHSortEditViewController.h
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,WYHMoveAnimationOptions) {
    WYHMoveAnimationNone = 0, //无动画
    WYHMoveAnimationTrail = 1,
    WYHMoveAnimationEaseIn = 2,
    WYHMoveAnimationEaseOut = 3
};

@protocol WYHSortEditDelegate <NSObject>

/// 点击item
/// @param indexPath item的位置indexPath
- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath complete:(void(^)(NSArray *displayDatas,NSArray *noDisplayDatas,NSInteger row))complateBlock;

/// 正在拖拽item
/// @param fromIndexPath 当前的位置的索引
/// @param toIndexPath 将要移动到位置的索引
- (void)dragingItemChanged:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath complete:(void(^)(NSArray *displayDatas))complateBlock;


@end

@interface WYHSortEditViewController : UIViewController

@property (nonatomic, weak) id<WYHSortEditDelegate> delegate;

@property (nonatomic, assign) WYHMoveAnimationOptions moveAnimationOptions;
//系统支持iOS9及以上
@property (nonatomic, assign) BOOL systemRealizeWay;

- (instancetype)initWithSorts:(NSArray *)displaySorts noDisplaySorts:(NSArray *)noDisplaySorts;

@end

NS_ASSUME_NONNULL_END
