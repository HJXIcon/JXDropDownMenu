//
//  JXDropDownCell.m
//  JXDropDownMenu
//
//  Created by yituiyun on 2017/10/23.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "JXDropDownCell.h"

@implementation JXDropDownModel


@end

@implementation JXDropDownCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imageView];
    
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.text = @"textLabel";
    [self.contentView addSubview:self.textLabel];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 0, 12, 12);
    CGPoint center = self.imageView.center;
    center.y = CGRectGetMidY(self.contentView.frame);
    self.imageView.center = center;

    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 10, 0, CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.imageView.frame) - 10, CGRectGetHeight(self.contentView.frame));
    
}

- (void)setModel:(JXDropDownModel *)model{
    _model = model;
    self.imageView.image = model.image;
    self.textLabel.text = model.text;
    if (model.isSelect) {
        self.textLabel.textColor = model.textSelectedColor;
        self.imageView.hidden = NO;
    }else{
        self.textLabel.textColor = model.textNormalColor;
        self.imageView.hidden = YES;
    }
    
    
}


@end
