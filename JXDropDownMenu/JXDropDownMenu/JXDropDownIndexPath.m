//
//  JXDropDownIndexPath.m
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/26.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXDropDownIndexPath.h"

@implementation JXDropDownIndexPath

- (instancetype)initWithColumn:(NSInteger)column item:(NSInteger)item{
    self = [super init];
    if (self) {
        _column = column;
        _item = item;
    }
    return self;
}
+ (instancetype)indexPathWithCol:(NSInteger)col item:(NSInteger)item{
    
    return [[self alloc]initWithColumn:col item:item];
    
}
@end
