//
//  JXDropDownIndexPath.h
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/26.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXDropDownIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger item;

- (instancetype)initWithColumn:(NSInteger)column item:(NSInteger)item;
+ (instancetype)indexPathWithCol:(NSInteger)col item:(NSInteger)item;
@end
