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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    JXDropDownMenu *menu = [[JXDropDownMenu alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44)];
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
}


/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(JXDropDownMenu *)menu{
    return titles.count;
}

/**
 *  返回 menu 第column列有Items行
 */
- (NSInteger)menu:(JXDropDownMenu *)menu numberOfItemsInColumn:(NSInteger)column{
    NSArray *array = titles[column];
    return array.count;
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(JXDropDownMenu *)menu titleForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  titles[indexPath.section][indexPath.row];
}

/**
 *  每一列有多少列Item ， 默认1列
 */
- (NSInteger)menu:(JXDropDownMenu *)menu columnsInColumns:(NSInteger)column{
    
    if (column == titles.count - 1) {
        return 1;
    }
    return 2;
    
}


@end
