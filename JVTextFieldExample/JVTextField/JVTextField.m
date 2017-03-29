//
//  JVTextField.m
//  UIViewConvertRect
//
//  Created by xingso on 15/7/17.
//  Copyright (c) 2015年 HD_CyYihan. All rights reserved.
//

#import "JVTextField.h"
#import "JVshowKeyboardManger.h"
@interface JVTextField()
@end

@implementation JVTextField

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    [self Initialize];
    return self;
}
-(instancetype)init{
    self=[super init];
    [self Initialize];
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self Initialize];
}


#pragma -mark 初始化
-(void)Initialize{
    [self addTarget:self action:@selector(addKeyboardNotification) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(removeKeyboardNotification) forControlEvents:UIControlEventEditingDidEnd];
}
#pragma -mark添加通知
-(void)addKeyboardNotification{
  [JVshowKeyboardManger addNotificationWithTextFiled:self];
}

#pragma -mark 移除通知
-(void)removeKeyboardNotification{
    [JVshowKeyboardManger removeNotificationWithTextFiled:self];
}
@end
