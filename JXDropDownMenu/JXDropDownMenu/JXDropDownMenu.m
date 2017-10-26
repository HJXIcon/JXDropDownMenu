//
//  JXDropDownMenu.m
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXDropDownMenu.h"
#import "JXDropDownCell.h"
#import "UIView+Extension.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define kCollectionViewCellHeight 43
#define kArrowImageViewSize CGSizeMake(12, 6)

#define kSeparatorColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1]
#define kTextSelectColor [UIColor colorWithRed:246/255.0 green:79/255.0 blue:0/255.0 alpha:1]



@interface JXDropDownMenu ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *colNumInCols;
@property (nonatomic, strong) NSMutableArray <CATextLayer *> *titles;
@property (nonatomic, strong) NSMutableArray <CALayer *> *bgLayers;
@property (nonatomic, strong) NSMutableArray <UIImageView *> *indicators;

@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;  // 当前选中列
@property (nonatomic, assign) BOOL show;
@property (nonatomic, strong) NSMutableArray <NSArray <JXDropDownModel *>*> *models;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*colShowSelectColors;

@end
@implementation JXDropDownMenu

#pragma mark - lazy load
- (NSMutableArray<NSNumber *> *)colNumInCols{
    if (_colNumInCols == nil) {
        _colNumInCols = [NSMutableArray array];
    }
    return _colNumInCols;
}
- (NSMutableArray<NSArray<JXDropDownModel *> *> *)models{
    if (_models == nil) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (UIView *)backgroundView{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), [UIScreen mainScreen].bounds.size.height)];
        _backgroundView.opaque = NO;
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backTap:)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (NSMutableArray<UIImageView *> *)indicators{
    if (_indicators == nil) {
        _indicators = [NSMutableArray array];
    }
    return _indicators;
}

- (NSMutableArray<CALayer *> *)bgLayers{
    if (_bgLayers == nil) {
        _bgLayers = [NSMutableArray array];
    }
    return _bgLayers;
}

- (UIView *)bottomLineView{
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
        _bottomLineView.backgroundColor = kSeparatorColor;
    }
    return _bottomLineView;
}
- (NSMutableArray<CATextLayer *> *)titles{
    if (_titles == nil) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[JXDropDownCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self initialize];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuTap:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}


- (void)setupUI{
    
    
    [self addSubview:self.bottomLineView];
}


- (void)initialize{
    _textNormalColor = [UIColor blackColor];
    _textSelectedColor = kTextSelectColor;
    _fontSize = 14;
    _separatorHeighPercent = 0.5;
    _showSeparator = YES;
    _separatorColor = kSeparatorColor;
    _colShowSelectColors = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
    _dropImage = [UIImage imageNamed:@"picture.bundle/outdoor_icon_arrow_down_grey"];
    _dorpImageSize = kArrowImageViewSize;
    _titleImageOffset = 10;
    _maxMenuContentHeight = 300;
    _selectImage = [UIImage imageNamed:@"picture.bundle/redxuanzhong"];
    
}


#pragma mark - 即将要添加到父控件
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    // 列
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    
    // 每一列的列数
    for (int i = 0; i < _numOfMenu; i ++) {
        NSInteger col = 1;
        if ([_dataSource respondsToSelector:@selector(menu:columnsInColumns:)]) {
            col = [_dataSource menu:self columnsInColumns:i];
        }
        [self.colNumInCols addObject:[NSNumber numberWithInteger:col]];
    }
    
    // items
    for (int i = 0; i < _numOfMenu; i  ++) {
        if ([_dataSource respondsToSelector:@selector(menu:numberOfItemsInColumn:)]) {
            NSInteger itmes = [_dataSource menu:self numberOfItemsInColumn:i];
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (int j = 0; j < itmes; j ++) {
                JXDropDownModel *model = [[JXDropDownModel alloc]init];
                model.image = _selectImage;
                model.isSelect = j == 0 ? YES : NO;
                model.textNormalColor = self.textNormalColor;
                model.textSelectedColor = self.textSelectedColor;
                model.text = [_dataSource menu:self titleForItemAtIndexPath:[JXDropDownIndexPath indexPathWithCol:i item:j]];
                [tmpArray addObject:model];
            }
            [self.models addObject:tmpArray];
        }
    }
    
    
    [self.titles makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.bgLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGFloat bgLayerW = CGRectGetWidth(self.frame) / _numOfMenu;
    
    for (int i = 0; i < self.numOfMenu; i ++) {
        //bgLayer
        CALayer *bgLayer = [CALayer layer];
        bgLayer.frame = CGRectMake(i*bgLayerW, 0, bgLayerW, self.frame.size.height - 1);
        bgLayer.backgroundColor = [UIColor whiteColor].CGColor;

        [self.layer addSublayer:bgLayer];
        [self.bgLayers addObject:bgLayer];
        
        //title
        NSString *titleString = self.models[i][0].text;
        CGSize size = [self calculateTitleSizeWithString:titleString];
        CATextLayer *titleLayer = [[CATextLayer alloc]init];
        CGFloat maxWidth = CGRectGetWidth(bgLayer.frame) - self.dorpImageSize.width - _titleImageOffset - 1;
        CGFloat sizeWidth = size.width < maxWidth ? size.width : maxWidth;
        titleLayer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
        titleLayer.string = titleString;
        titleLayer.fontSize = _fontSize;
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.truncationMode = kCATruncationEnd;
        titleLayer.foregroundColor = self.textNormalColor.CGColor;
        titleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        titleLayer.contentsScale = [[UIScreen mainScreen] scale];
        titleLayer.anchorPoint = CGPointZero;
        titleLayer.position = CGPointMake((CGRectGetWidth(bgLayer.frame) - _titleImageOffset - 1 - sizeWidth - self.dorpImageSize.width) * 0.5 ,(CGRectGetHeight(bgLayer.frame) - size.height) * 0.5);
        [bgLayer addSublayer:titleLayer];
        [self.titles addObject:titleLayer];
        
        //indicator
        CGFloat textMaxX = CGRectGetMaxX(titleLayer.frame) + _titleImageOffset;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(textMaxX, 0, self.dorpImageSize.width, self.dorpImageSize.height)];
        imageView.centerY = CGRectGetMidY(titleLayer.frame);//居中
        imageView.image = self.dropImage;
        imageView.tag = i;
        [bgLayer addSublayer:imageView.layer];
        [self.indicators addObject:imageView];
        
        //separator
        if (_showSeparator && i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake(CGRectGetWidth(bgLayer.frame)-1, self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:_separatorColor  andPosition:separatorPosition];
            [bgLayer addSublayer:separator];
        }
        
    }
    
}



#pragma mark - Actions
- (void)backTap:(UITapGestureRecognizer *)tap{
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:self.backgroundView collectionView:self.collectionView title:self.titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        self.show = NO;
    }];
}

- (void)menuTap:(UITapGestureRecognizer *)tap{
    
    if (_dataSource == nil) {
        return;
    }
    CGPoint touchPoint = [tap locationInView:self];
    //计算 index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:self.backgroundView collectionView:self.collectionView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            self.show = NO;
        }];
        
    } else {
        _currentSelectedMenudIndex = tapIndex;
        [self reloadData];
    
        [self animateIdicator:_indicators[tapIndex] background:self.backgroundView collectionView:self.collectionView title:_titles[tapIndex] forward:YES complecte:^{
            self.show = YES;
        }];
    }
    
}



#pragma mark - Private Method
- (void)reloadData{
    [self.collectionView reloadData];
}

- (void)hideMenu
{
    if (_show) {
        [self backTap:nil];
    }
}



// 计算高度
- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    //CGFloat fontSize = 14.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:_fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return CGSizeMake(ceilf(size.width), size.height);
}


/// 底线
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    CGFloat height = CGRectGetHeight(self.frame) * _separatorHeighPercent;
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, height)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}



#pragma mark - updatePosition
- (void)updateTextLayerAndIndicatorPosition:(NSInteger )index title:(NSString *)title  complete:(void(^)())complete {
    
    // title
    CATextLayer *textLayer = self.titles[index];
    textLayer.string = title;
    CGSize size = [self calculateTitleSizeWithString:title];
    // 最小过滤
    CGFloat sizeWidth = size.width;
    CGFloat maxWidth = CGRectGetWidth(self.bgLayers.firstObject.frame) - self.dorpImageSize.width - _titleImageOffset - 1;

    if (sizeWidth > maxWidth) {
        sizeWidth = maxWidth;
    }
    textLayer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    textLayer.anchorPoint = CGPointZero;
    
    CGFloat posX = (CGRectGetWidth(self.bgLayers.firstObject.frame) - sizeWidth - _titleImageOffset - 1 - self.dorpImageSize.width) * 0.5;
    CGFloat posY = (CGRectGetHeight(self.bgLayers.firstObject.frame) - size.height) * 0.5;
    textLayer.position = CGPointMake(posX,posY);
    
    [self.colShowSelectColors enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.titles[idx].foregroundColor = [obj boolValue] ? _textSelectedColor.CGColor : _textNormalColor.CGColor;
    }];
    
    
    // image
    UIImageView *imageView = self.indicators[index];
    imageView.x = CGRectGetMaxX(textLayer.frame) + _titleImageOffset;
    
    if (complete) {
        complete();
    }
}



#pragma mark animation method
- (void)animateIndicator:(id)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    
    [self animateIndicatorImageView:(UIImageView *)indicator Forward:forward complete:complete];
}

- (void)animateIndicatorImageView:(UIImageView *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    
    if (forward) {
        indicator.transform =  CGAffineTransformMakeRotation(M_PI);
    }else{
        indicator.transform = CGAffineTransformIdentity;
    }
    
    complete();
}



- (void)animateIdicator:(id)indicator background:(UIView *)background collectionView:(UICollectionView *)collectionView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    __block NSInteger selectItem;
    NSArray *modelArray = self.models[_currentSelectedMenudIndex];
    [modelArray enumerateObjectsUsingBlock:^(JXDropDownModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelect) {
            selectItem = idx;
        }
        
    }];
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateBackGroundView:background show:forward complete:^{
            [self animateCollectionView:collectionView show:forward complete:^{
            }];
        }];
        
    }];
    
    if (complete) {
        complete();
    }
    
    
}

- (void)animateCollectionView:(UICollectionView *)collectionView show:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
        
        self.collectionView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0);
        [self.superview addSubview:self.collectionView];
        
        // items个数
        NSInteger itemsCount = 0;
        if (_dataSource && [_dataSource respondsToSelector:@selector(menu:numberOfItemsInColumn:)]) {
            itemsCount = [_dataSource menu:self numberOfItemsInColumn:_currentSelectedMenudIndex];
        }
        
        // 总高度
        CGFloat contentHeight = itemsCount * kCollectionViewCellHeight;
        // 每一列中有多少列
        if (_dataSource && [_dataSource respondsToSelector:@selector(menu:columnsInColumns:)]) {
            CGFloat col = [_dataSource menu:self columnsInColumns:_currentSelectedMenudIndex];
            
            contentHeight = itemsCount/col * kCollectionViewCellHeight;
        }
        CGFloat CollectionViewHeight = contentHeight > _maxMenuContentHeight ? _maxMenuContentHeight : contentHeight;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.collectionView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CollectionViewHeight);
            
        }];
        
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.collectionView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0);
            
            
        } completion:^(BOOL finished) {
            
            [self.collectionView removeFromSuperview];
            
        }];
    }
    
    if (complete) {
        complete();
    }
    
}



- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    if (complete) {
       complete();
    }
    
}




#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.models[_currentSelectedMenudIndex].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JXDropDownCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.models[_currentSelectedMenudIndex][indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *models = self.models[_currentSelectedMenudIndex];
    [models enumerateObjectsUsingBlock:^(JXDropDownModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.isSelect = idx == indexPath.item;
        
        
        if (indexPath.item != 0) {
            _colShowSelectColors[_currentSelectedMenudIndex] = @(1);
        }else{
            _colShowSelectColors[_currentSelectedMenudIndex] = @(0);
        }
        
        if (obj.isSelect) {
            [self updateTextLayerAndIndicatorPosition:_currentSelectedMenudIndex title:obj.text complete:^{
                [self hideMenu];
            }];
        }
    }];
    
    // 刷新
    [self reloadData];
   
    if (_delegate && [_delegate respondsToSelector:@selector(menu:didSelectItemAtIndexPath:)]) {
        [_delegate menu:self didSelectItemAtIndexPath:[JXDropDownIndexPath indexPathWithCol:_currentSelectedMenudIndex item:indexPath.item]];
    }
}




#pragma mark - layout代理
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(CGRectGetWidth(self.frame)/[self.colNumInCols[_currentSelectedMenudIndex] integerValue], kCollectionViewCellHeight);
}

//设置垂直间距,默认的垂直和水平间距都是10
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return  0;
}


//设置水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// 四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}






@end
