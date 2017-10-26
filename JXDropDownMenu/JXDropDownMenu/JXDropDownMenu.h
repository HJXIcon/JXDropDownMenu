//
//  JXDropDownMenu.h
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JXDropDownMenu;

@protocol JXDropDownMenuDataSource <NSObject>

@required

/**
 *  返回 menu 第column列有Items
 */
- (NSInteger)menu:(JXDropDownMenu *)menu numberOfItemsInColumn:(NSInteger)column;

/**
 *  返回 menu 第column列 每个Items的title
 */
- (NSString *)menu:(JXDropDownMenu *)menu titleForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(JXDropDownMenu *)menu;

/**
 *  每一列有多少列Item ， 默认1列
 */
- (NSInteger)menu:(JXDropDownMenu *)menu columnsInColumns:(NSInteger)column;
@end

#pragma mark - delegate
@protocol JXDropDownMenuDelegate <NSObject>
@optional
/**
 *  点击代理，点击了第column 第Item 或者Item项，如果 Item >=0
 */
- (void)menu:(JXDropDownMenu *)menu didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

/** 新增
 *  return nil if you don't want to user select specified indexpath
 *  optional
 */
- (NSIndexPath *)menu:(JXDropDownMenu *)menu willSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JXDropDownMenu : UIView
/*! 下拉箭头 */
@property (nonatomic, strong) UIImage *dropImage;
// 默认是 CGSizeMake(12, 6)
@property (nonatomic, assign) CGSize dorpImageSize;
// 图文间距
@property (nonatomic, assign) CGFloat titleImageOffset;

// 选中图片
@property (nonatomic, strong) UIImage *selectImage;

@property (nonatomic, assign) CGFloat maxMenuContentHeight; // 最大高度
@property (nonatomic, strong) UIColor *textNormalColor;     // 文字title颜色
@property (nonatomic, strong) UIColor *textSelectedColor;   // 文字title选中颜色
@property (nonatomic, assign) CGFloat fontSize;             // 字体大小

/// --->>> 中间分割线
@property (nonatomic, assign) BOOL   showSeparator;         // 是否有分割线
@property (nonatomic, strong) UIColor *separatorColor;      // 分割线颜色
@property (nonatomic, assign) CGFloat separatorHeighPercent;// 分割线高度占比，默认 50%，值范围为 0-1 (在设置dataSource之前调用才会生效)


@property (nonatomic, weak) id<JXDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id<JXDropDownMenuDelegate> delegate;

@end






