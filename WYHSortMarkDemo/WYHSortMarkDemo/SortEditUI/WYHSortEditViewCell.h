//
//  WYHSortEditViewCell.h
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,EditStyle){
    EditReduceNone = 0,
    EditReduceStyle = 1,
    EditAddStyle = 2,
};

@interface WYHSortEditViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL markHiden;

@property (nonatomic, assign) BOOL isMoving;

- (void)bindViewModel:(id)item indexPath:(NSIndexPath *)indexPath;

- (void)setEditMarkStyle:(EditStyle)editStyle;

@end

NS_ASSUME_NONNULL_END
