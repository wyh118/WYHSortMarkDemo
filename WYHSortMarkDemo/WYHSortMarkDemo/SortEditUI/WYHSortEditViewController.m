//
//  WYHSortEditViewController.m
//  WYHSortMarkDemo
//
//  Created by 王云辉 on 2020/3/16.
//  Copyright © 2020 TJGD. All rights reserved.
//

#import "WYHSortEditViewController.h"
#import "WYHSortEditHeaderView.h"
#import "WYHSortEditViewCell.h"

#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//每行4列
static NSInteger const kColumnNumner = 4;
//每个Item的横向间距
static CGFloat const kItemMarginX = 15.0f;
//每个人Item的c纵向间距
static CGFloat const kItemMarginY = 15.0f;

@interface WYHSortEditViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
//当前选中的item
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
//已显示分类数据
@property (nonatomic, strong) NSMutableArray *displayArray;
//未显示分类数据
@property (nonatomic, strong) NSMutableArray *noDisplayArray;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@property (nonatomic, strong) UIView *showView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;



@end

@implementation WYHSortEditViewController

- (instancetype)initWithSorts:(NSArray *)displaySorts noDisplaySorts:(NSArray *)noDisplaySorts;
{
    if (self = [super init]) {
        self.systemRealizeWay = NO;
        self.displayArray = [NSMutableArray arrayWithArray:displaySorts];
        self.noDisplayArray = [NSMutableArray arrayWithArray:noDisplaySorts];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)IS_IPhoneX {
    
    if (@available(iOS 11.0, *)) {
        if (!UIEdgeInsetsEqualToEdgeInsets(self.view.safeAreaInsets, UIEdgeInsetsZero)) {
            return YES;
        }
    }
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [UIImage imageNamed:@"close"];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        [_closeBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - image.size.width - 15, ([self IS_IPhoneX]?44.0:20.0) + 10, image.size.width, image.size.height)];
        [_closeBtn addTarget:self action:@selector(closeEditVC:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_editBtn setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 60 - 15, CGRectGetMinX(_closeBtn.frame), 60, 25)];
        _editBtn.hidden = YES;
        [_editBtn addTarget:self action:@selector(handleEditEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (void)handleEditEvent:(id)event
{
    self.closeBtn.hidden = NO;
    self.editBtn.hidden = YES;
    [self.collectionView reloadData];
}

- (void)closeEditVC:(id)event
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)buildUI
{
    self.view.backgroundColor = COLOR(244, 245, 249, 1);
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.editBtn];
    UILabel *bigTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, ([self IS_IPhoneX]?44.0:20.0) +10, CGRectGetMinX(self.closeBtn.frame) - 15, 40)];
    [bigTitleLabel setTextColor:[UIColor blackColor]];
    [bigTitleLabel setText:@"全部频道"];
    [bigTitleLabel setFont:[UIFont boldSystemFontOfSize:24.0f]];
    [self.view addSubview:bigTitleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bigTitleLabel.frame) + 20, CGRectGetWidth(self.view.frame)-30, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:lineView];
    [self.closeBtn setCenter:CGPointMake(self.closeBtn.center.x, bigTitleLabel.center.y)];
    [self.editBtn setCenter:CGPointMake(self.editBtn.center.x, bigTitleLabel.center.y)];

    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (CGRectGetWidth(self.view.frame) - (kColumnNumner + 1)*kItemMarginX)/kColumnNumner;
    CGFloat cellHeight = cellWidth/2.0f;
    _flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight);
    _flowLayout.sectionInset = UIEdgeInsetsMake(kItemMarginY, kItemMarginX, kItemMarginY, kItemMarginX);
    _flowLayout.minimumLineSpacing = kItemMarginY;
    _flowLayout.minimumInteritemSpacing = kItemMarginX;
    _flowLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.view.frame), 60);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(lineView.frame)) collectionViewLayout:_flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"WYHSortEditViewCell" bundle:nil] forCellWithReuseIdentifier:@"WYHSortEditViewCell"];
    [self.collectionView registerClass:[WYHSortEditHeaderView class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WYHSortEditHeaderView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    _longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    _longGesture.delegate = self;
    [self.collectionView addGestureRecognizer:_longGesture];

    for (UIGestureRecognizer *gestureRecognizer in self.collectionView.gestureRecognizers) {
        if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gestureRecognizer requireGestureRecognizerToFail:_longGesture];
        }
    }
}

- (void)setSystemRealizeWay:(BOOL)systemRealizeWay
{
    _systemRealizeWay = systemRealizeWay;
}

- (void)reloadViewData
{
    __weak typeof(self) weakSelf = self;
    [self.collectionView performBatchUpdates:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [strongSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
    } completion:^(BOOL finished) {
    }];
}

- (UIImage *)getImageContext:(UICollectionViewCell*)cell
{
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0.0f);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.collectionView];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self dragItemBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragItemChanged:point];
            break;
        case UIGestureRecognizerStateCancelled:
            [self dragItemCancelled];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragItemEnd];
            break;
        default:
            break;
    }
}

//拖拽开始 找到被拖拽的item
- (void)dragItemBegin:(CGPoint)point
{
    NSIndexPath *currentIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    if (![self collectionView:self.collectionView canMoveItemAtIndexPath:currentIndexPath]) {
        return;
    }
    self.selectedIndexPath = currentIndexPath;
    if (self.editBtn.hidden == YES) {
        self.closeBtn.hidden = YES;
        self.editBtn.hidden = NO;
        [self reloadViewData];
    }
    if (self.systemRealizeWay) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:self.selectedIndexPath];
        }
    }
    else{
        WYHSortEditViewCell *viewcell = (WYHSortEditViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        self.showView = [[UIView alloc] initWithFrame:viewcell.frame];

        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self getImageContext:viewcell]];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.showView addSubview:imageView];
        [self.collectionView addSubview:self.showView];
        
        viewcell.isMoving = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.showView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
        } completion:^(BOOL finished) {

        }];
        [self.flowLayout invalidateLayout];
    }
}

//正在被拖拽
-(void)dragItemChanged:(CGPoint)point
{
    if (!self.selectedIndexPath) {
        return;
    }
    if (self.systemRealizeWay) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView updateInteractiveMovementTargetPosition:point];
        }
    }
    else{
        self.showView.center = point;
        //将要进入的位置
        NSIndexPath *newIndexPath = [self.collectionView indexPathForItemAtPoint:self.showView.center];
        //当前选中cell的位置
        NSIndexPath *previousIndexPath = self.selectedIndexPath;
        
        if (![self collectionView:_collectionView itemAtIndexPath:previousIndexPath canMoveToIndexPath:newIndexPath]) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(dragingItemChanged:canMoveToIndexPath:complete:)]) {
            __weak typeof(self) weakSelf = self;
            [self.delegate dragingItemChanged:previousIndexPath canMoveToIndexPath:newIndexPath complete:^(NSArray * _Nonnull displayDatas) {
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.displayArray setArray:displayDatas];
                [strongSelf.collectionView moveItemAtIndexPath:previousIndexPath toIndexPath:newIndexPath];
                strongSelf.selectedIndexPath = newIndexPath;
            }];
        }
    }
}

//拖拽取消
-(void)dragItemCancelled
{
    if (self.systemRealizeWay) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView cancelInteractiveMovement];
        }
    }
    else{
        
    }
}

//拖拽结束
-(void)dragItemEnd
{
    if (!self.selectedIndexPath) {
        return;
    }
    if (self.systemRealizeWay) {
        if (@available(iOS 9.0, *)) {
            [self.collectionView endInteractiveMovement];
        }
    }
    else{
        WYHSortEditViewCell *viewcell = (WYHSortEditViewCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
        CGRect endFrame = viewcell.frame;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.showView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.showView.frame = endFrame;
        }completion:^(BOOL finished) {
            [self.showView removeFromSuperview];
            self.showView = nil;
            viewcell.isMoving = NO;
            [self.flowLayout invalidateLayout];
        }];
    }
}

//自定义实现拖动使用，与targetIndexPathForMoveFromItemAtIndexPath方法功能相同
- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.section == 0) {
        if (toIndexPath.row == 0) {
            return NO;
        }
    }
    else if (toIndexPath.section == 1){
        return NO;
    }
    return YES;
}

- (void)handleMoveItemIndex:(NSIndexPath *)indexPath targetIndex:(NSIndexPath *)targetIndexPath
{
    switch (self.moveAnimationOptions) {
        case WYHMoveAnimationNone:
        {
            __weak typeof(self) weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
//                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            } completion:^(BOOL finished) {

            }];
        }
            break;
        case WYHMoveAnimationTrail:
        {
            WYHSortEditViewCell *cell = (WYHSortEditViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            [cell setEditMarkStyle:targetIndexPath.section == 0?EditReduceStyle:EditAddStyle];
            [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
        }
            break;
        case WYHMoveAnimationEaseIn:
        {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.5 animations:^{
                [self.collectionView performBatchUpdates:^{
                    __strong typeof(self) strongSelf = weakSelf;
                    [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    [strongSelf.collectionView insertItemsAtIndexPaths:@[targetIndexPath]];
                } completion:^(BOOL finished) {

                }];
            }];
        }
            break;
        case WYHMoveAnimationEaseOut:
        {
            __weak typeof(self) weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                __strong typeof(self) strongSelf = weakSelf;
                [strongSelf.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                [strongSelf.collectionView insertItemsAtIndexPaths:@[targetIndexPath]];
            } completion:^(BOOL finished) {

            }];
        }
            break;
        default:
            break;
    }
}


#pragma  mark - CollectionViewDelegate&DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.displayArray.count;
    }
    else if (section == 1){
        return self.noDisplayArray.count;
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        WYHSortEditHeaderView *header = (WYHSortEditHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WYHSortEditHeaderView" forIndexPath:indexPath];
        [header buildHeaderView:indexPath.section];
        return header;
    }
    return [[UICollectionReusableView alloc] init];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"WYHSortEditViewCell";
    WYHSortEditViewCell *itemCell = (WYHSortEditViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    [itemCell sizeToFit];
    if (indexPath.section == 0) {
        [itemCell bindViewModel:self.displayArray[indexPath.row] indexPath:indexPath];
    }
    else if (indexPath.section == 1){
        [itemCell bindViewModel:self.noDisplayArray[indexPath.row] indexPath:indexPath];
    }
    itemCell.markHiden = self.editBtn.hidden;
    
    return itemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.editBtn.hidden) {
            
        }
        else{
            //在编辑状态点击第一分组删除点击item
            if ([self.collectionView numberOfItemsInSection:0] == 1 || indexPath.row == 0) {
                //只剩一个的时候不可删除,第一个cell不可删除
                return;
            }
            if ([self.delegate respondsToSelector:@selector(selectItemAtIndexPath:complete:)]) {
                __weak typeof(self) weakSelf = self;
                [self.delegate selectItemAtIndexPath:indexPath complete:^(NSArray * _Nonnull displayDatas, NSArray * _Nonnull noDisplayDatas, NSInteger row) {
                    __strong typeof(self) strongSelf = weakSelf;
                    strongSelf.displayArray = (NSMutableArray *)displayDatas;
                    strongSelf.noDisplayArray = (NSMutableArray *)noDisplayDatas;
                    NSIndexPath * targetIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
                    [strongSelf handleMoveItemIndex:indexPath targetIndex:targetIndexPath];
                }];
            }
        }
    }
    else if (indexPath.section == 1){
        if (self.editBtn.hidden) {
            
        }
        else{
            if ([self.delegate respondsToSelector:@selector(selectItemAtIndexPath:complete:)]) {
                __weak typeof(self) weakSelf = self;
                [self.delegate selectItemAtIndexPath:indexPath complete:^(NSArray * _Nonnull displayDatas, NSArray * _Nonnull noDisplayDatas, NSInteger row) {
                    __strong typeof(self) strongSelf = weakSelf;
                    strongSelf.displayArray = (NSMutableArray *)displayDatas;
                    strongSelf.noDisplayArray = (NSMutableArray *)noDisplayDatas;
                    NSIndexPath * targetIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
                    [strongSelf handleMoveItemIndex:indexPath targetIndex:targetIndexPath];
                }];
            }
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    else if(indexPath.section == 1){
        if (self.editBtn.hidden == YES) {
            self.closeBtn.hidden = YES;
            self.editBtn.hidden = NO;
            [self reloadViewData];
        }
        return NO;
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    /**
     * sourceIndexPath 原始数据 indexpath
     * destinationIndexPath 移动到目标数据的 indexPath
    */
    NSInteger soureceIndex = sourceIndexPath.row;
    NSInteger destinaIndex = destinationIndexPath.row;
    NSString *item = [self.displayArray objectAtIndex:soureceIndex];
    [self.displayArray removeObjectAtIndex:soureceIndex];
    [self.displayArray insertObject:item atIndex:destinaIndex];
}

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath
{
    //此地处理cell滑动到Top分组第一个位置不移动，滑动到bottom分组任何位置不移动
    if (proposedIndexPath.section == 0) {
        if (proposedIndexPath.item == 0) {
            return originalIndexPath;
        }
    }
    else if (proposedIndexPath.section == 1){
        return originalIndexPath;
    }
    return proposedIndexPath;
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end
