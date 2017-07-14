//
//  JSBikeShowView.m
//  BothJiangSu
//
//  Created by 张小牛 on 2017/6/6.
//  Copyright © 2017年 BothJiangSu. All rights reserved.
//

#import "JSBikeShowView.h"


@implementation JSBikeShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label_address = [[UILabel alloc]init];
        self.label_address.text = @"南大苏富特科技创意园";
        self.label_address.font = [UIFont systemFontOfSize:14];
        self.label_address.textColor = blackkColor;
//        self.label_address.backgroundColor = ZXNRandom;
        [self addSubview:self.label_address];
        [self.label_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@16);
            make.top.equalTo(@16);
            make.right.equalTo(@-16);
            make.height.equalTo(@16);
        }];
        
        UIView *view_line = [[UIView alloc]init];
        view_line.backgroundColor = lightTextColor;
        [self addSubview:view_line];
        [view_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.label_address.mas_bottom).offset(16);
            make.right.equalTo(@0);
            make.height.equalTo(@1);
        }];

        //距离
        self.label_distance = [[UILabel alloc]init];
//        self.label_distance.backgroundColor = ZXNRandom;
        self.label_distance.text = @"48米";
        self.label_distance.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_distance];
        [self.label_distance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(view_line.mas_bottom).offset(10);
            make.right.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        UILabel *distance = [[UILabel alloc]init];
//        distance.backgroundColor = ZXNRandom;
        distance.text = @"距离起始位置";
        distance.textColor = textLightColor;
        distance.font = [UIFont systemFontOfSize:14];
        distance.textAlignment = NSTextAlignmentCenter;
        [self addSubview:distance];
        [distance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.label_distance.mas_bottom).offset(10);
            make.right.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        //时间
        self.label_minutes = [[UILabel alloc]init];
//        self.label_minutes.backgroundColor = ZXNRandom;
        self.label_minutes.text = @"1分钟";
        self.label_minutes.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_minutes];
        [self.label_minutes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(view_line.mas_bottom).offset(10);
            make.left.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        UILabel *minutes = [[UILabel alloc]init];
//        minutes.backgroundColor = ZXNRandom;
        minutes.text = @"距离起始位置";
        minutes.textColor = textLightColor;
        minutes.font = [UIFont systemFontOfSize:14];
        minutes.textAlignment = NSTextAlignmentCenter;
        [self addSubview:minutes];
        [minutes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(self.label_minutes.mas_bottom).offset(10);
            make.left.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];

        //导航
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = naviColor;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:@"导航" forState:0];
        [button addTarget:self action:@selector(gotoPlace) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-16);
            make.top.equalTo(minutes.mas_bottom).offset(10);
            make.left.equalTo(@16);
            make.height.equalTo(@40);
        }];
        
        //可借
        self.label_availTotal = [[UILabel alloc]init];
//        self.label_availTotal.backgroundColor = ZXNRandom;
        self.label_availTotal.text = @"20个";
        self.label_availTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_availTotal];
        [self.label_availTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(button.mas_bottom).offset(10);
            make.right.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        UILabel *availTotal = [[UILabel alloc]init];
//        availTotal.backgroundColor = ZXNRandom;
        availTotal.text = @"可借数量";
        availTotal.textColor = textLightColor;
        availTotal.font = [UIFont systemFontOfSize:14];
        availTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:availTotal];
        [availTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(self.label_availTotal.mas_bottom).offset(10);
            make.right.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        //可还
        self.label_emptyTotal = [[UILabel alloc]init];
//        self.label_emptyTotal.backgroundColor = ZXNRandom;
        self.label_emptyTotal.text = @"34个";
        self.label_emptyTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label_emptyTotal];
        [self.label_emptyTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(button.mas_bottom).offset(10);
            make.left.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
        
        UILabel *emptyTotal = [[UILabel alloc]init];
//        emptyTotal.backgroundColor = ZXNRandom;
        emptyTotal.text = @"可还数量";
        emptyTotal.textColor = textLightColor;
        emptyTotal.font = [UIFont systemFontOfSize:14];
        emptyTotal.textAlignment = NSTextAlignmentCenter;
        [self addSubview:emptyTotal];
        [emptyTotal mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.top.equalTo(self.label_emptyTotal.mas_bottom).offset(10);
            make.left.equalTo(self.mas_centerX);
            make.height.equalTo(@16);
        }];
    }
    return self;
}

- (void)gotoPlace{
    self.gotoOtherPlace();
}

@end
