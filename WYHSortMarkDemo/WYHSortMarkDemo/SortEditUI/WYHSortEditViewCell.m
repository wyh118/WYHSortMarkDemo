//
//  WYHSortEditViewCell.m
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import "WYHSortEditViewCell.h"

@interface WYHSortEditViewCell()

@property (nonatomic, weak) IBOutlet UILabel *lblTitle;

@property (nonatomic, weak) IBOutlet UILabel *lblMark;

@property (nonatomic, assign) EditStyle editStyle;

@end

@implementation WYHSortEditViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblMark.hidden = YES;
    [self.lblTitle setTextColor:[UIColor blackColor]];
}

- (void)bindViewModel:(id)item indexPath:(nonnull NSIndexPath *)indexPath
{
    if ([item isKindOfClass:[NSString class]]) {
        [self.lblTitle setText:item];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setEditMarkStyle:EditReduceNone];
            [self.lblTitle setTextColor:[UIColor lightGrayColor]];
        }
        else{
            [self setEditMarkStyle:EditReduceStyle];
            [self.lblTitle setTextColor:[UIColor blackColor]];
        }
    }
    else if (indexPath.section == 1){
        [self setEditMarkStyle:EditAddStyle];
        [self.lblTitle setTextColor:[UIColor blackColor]];
    }
}

- (void)setMarkHiden:(BOOL)markHiden
{
    _markHiden = markHiden;
    if (markHiden) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lblMark.alpha = 0;
        } completion:^(BOOL finished) {
            self.lblMark.hidden = self.markHiden;
        }];
    }
    else{
        self.lblMark.hidden = self.markHiden;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lblMark.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)setEditMarkStyle:(EditStyle)editStyle
{
    self.editStyle = editStyle;
    switch (self.editStyle) {
        case EditReduceNone:
            self.lblMark.text = @"";
            break;
        case EditReduceStyle:
            self.lblMark.text = @"-";
            [self.lblMark setTextColor:[UIColor lightGrayColor]];
            [self.lblMark setFont:[UIFont systemFontOfSize:26.0f]];
            break;
        case EditAddStyle:
            self.lblMark.text = @"+";
            [self.lblMark setTextColor:[UIColor blueColor]];
            [self.lblMark setFont:[UIFont systemFontOfSize:18.0f]];
            break;
        default:
            break;
    }
}

- (void)setIsMoving:(BOOL)isMoving
{
    _isMoving = isMoving;
    if (_isMoving) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
}

@end
