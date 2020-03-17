//
//  WYHSortEditHeaderView.h
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYHSortEditHeaderView : UICollectionReusableView

@property (nonatomic, copy) NSString *title;

- (void)buildHeaderView:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
