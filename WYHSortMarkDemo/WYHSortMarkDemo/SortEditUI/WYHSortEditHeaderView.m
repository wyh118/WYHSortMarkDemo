//
//  WYHSortEditHeaderView.m
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import "WYHSortEditHeaderView.h"

@interface WYHSortEditHeaderView()

@property (nonatomic, strong)UILabel *lblTitle;

@end

@implementation WYHSortEditHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
   CGFloat marginX = 15.0f;
   CGFloat labelWidth = (self.bounds.size.width - 2*marginX)/2.0f;
   _lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelWidth, self.bounds.size.height)];
   self.lblTitle.textColor = [UIColor blackColor];
   [self addSubview:self.lblTitle];
}

- (void)buildHeaderView:(NSInteger)section
{
    if (section == 0) {
        [_lblTitle setFrame:CGRectMake(CGRectGetMinX(_lblTitle.frame), 30, CGRectGetWidth(_lblTitle.frame), self.bounds.size.height-30)];
        self.title = @"我的频道";
    }
    else if (section == 1){
        self.title = @"其他频道";
    }
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.lblTitle.text = title;
}

@end
