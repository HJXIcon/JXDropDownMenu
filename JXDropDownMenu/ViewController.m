//
//  ViewController.m
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "JXDropDownMenu.h"

#define titles @[@[@"所有类别",@"地锅",@"牙刷",@"餐具",@"男表",@"笔记本",@"单肩斜挎包",@"美容养颜",@"毛呢大衣",@"增强免疫"],@[@"所有品牌",@"belle Maison",@"Bioglan",@"Boon",@"Aptamil",@"Betsey Johnson",@"Black&Decker",@"Calvin Klein",@"Frye",@"Kate Spade New York",@"KIRKLAND SIGNATURE",@"Okamoto",@"Timex"],@[@"综合排序",@"价格由高到底",@"价格由低到高"]]
@interface ViewController ()<JXDropDownMenuDataSource,JXDropDownMenuDelegate>

@property (nonatomic, weak) JXDropDownMenu *menu;

@property (nonatomic, strong) NSArray *menuTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    JXDropDownMenu *menu = [[JXDropDownMenu alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44)];
    _menu = menu;
    menu.dataSource = self;
    menu.delegate = self;
//    menu.showSeparator = NO;
    menu.textSelectedColor = [UIColor redColor];
//    menu.dorpImageSize = CGSizeMake(24, 12);
//    menu.titleImageOffset = 30;
//    menu.maxMenuContentHeight = 400;
    menu.fontSize = 17;
//    menu.separatorHeighPercent = 0.8;
//    menu.separatorColor = [UIColor redColor];
//    menu.selectImage = [UIImage imageNamed:@"桌面4.jpg"];
    [self.view addSubview:menu];
    
    
    /// 模拟网络加载
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.menuTitles = titles;
        [_menu reloadData];
    });
}


/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(JXDropDownMenu *)menu{
    return self.menuTitles.count;
}

/**
 *  返回 menu 第column列有Items行
 */
- (NSInteger)menu:(JXDropDownMenu *)menu numberOfItemsInColumn:(NSInteger)column{
    NSArray *array = self.menuTitles[column];
    return array.count;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(JXDropDownMenu *)menu titleForItemAtIndexPath:(JXDropDownIndexPath *)indexPath{
    
    return  self.menuTitles[indexPath.column][indexPath.item];
}

/**
 *  每一列有多少列Item ， 默认1列
 */
- (NSInteger)menu:(JXDropDownMenu *)menu columnsInColumns:(NSInteger)column{
    
    if (column == self.menuTitles.count - 1) {
        return 1;
    }
    return 2;
    
}


- (void)menu:(JXDropDownMenu *)menu didSelectItemAtIndexPath:(JXDropDownIndexPath *)indexPath{
    
    NSLog(@"col == %ld, item == %ld",indexPath.column,indexPath.item);
}

@end
