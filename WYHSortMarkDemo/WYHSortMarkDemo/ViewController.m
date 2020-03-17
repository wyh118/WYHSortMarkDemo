//
//  ViewController.m
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import "ViewController.h"
#import "WYHSortEditViewController.h"
#import "WYHSortDataCore.h"

@interface ViewController ()<WYHSortEditDelegate>

@property (nonatomic, strong) WYHSortDataCore *dataCore;


@end

@implementation ViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    _dataCore = [[WYHSortDataCore alloc] init];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)clickSortEditEvent:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.dataCore handleShowSort:^(NSArray * _Nonnull displayDatas, NSArray * _Nonnull noDisplayDatas) {
        __strong typeof(self) strongSelf = weakSelf;
        WYHSortEditViewController *editVC = [[WYHSortEditViewController alloc] initWithSorts:displayDatas noDisplaySorts:noDisplayDatas];
        editVC.delegate = strongSelf;
        editVC.moveAnimationOptions = WYHMoveAnimationTrail;
        editVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        editVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [strongSelf presentViewController:editVC animated:YES completion:^{

        }];
    } failed:^(NSString * _Nonnull failInfo) {
        
    } error:^(NSError * _Nonnull error) {
        
    }];
}


- (void)selectItemAtIndexPath:(nonnull NSIndexPath *)indexPath complete:(nonnull void (^)(NSArray * _Nonnull, NSArray * _Nonnull, NSInteger))complateBlock {
    [self.dataCore handleUpdateSortAtIndexPath:indexPath complete:^(NSArray * _Nonnull displayDatas, NSArray * _Nonnull noDisplayDatas, NSInteger row) {
        complateBlock(displayDatas,noDisplayDatas,row);
    }];
}


@end
