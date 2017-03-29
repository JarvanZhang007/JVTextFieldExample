//
//  JVshowKeyboardManger.m
//  HD_Car
//
//  Created by xingso on 15/9/11.
//  Copyright (c) 2015年 HD_CyYihan. All rights reserved.
//

#import "JVshowKeyboardManger.h"

#define JVScreen_Width [UIScreen mainScreen].bounds.size.width

#define JVScreen_Height [UIScreen mainScreen].bounds.size.height

#define JVColor(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

static JVshowKeyboardManger *_sharedClass;

@interface JVshowKeyboardManger()
//为键盘添加一个完成按钮来关闭键盘
@property(strong,nonatomic)UIView* keyboardToolbar;
//moveView 在window中的 rect.origin.y
@property(assign,nonatomic) CGFloat viewY;
// 传递对象  for 遮挡键盘 处理
@property(nonatomic,weak)JVTextField* textFiled;

@end
@implementation JVshowKeyboardManger

-(UIView *)keyboardToolbar{
    if (!_keyboardToolbar) {
        _keyboardToolbar=[[UIView alloc]initWithFrame:CGRectMake(0, JVScreen_Height, JVScreen_Width, 40)];
        _keyboardToolbar.backgroundColor=JVColor(208, 213, 218, 1.0);
        UIButton* complateBtn=[[UIButton alloc]initWithFrame:CGRectMake(JVScreen_Width-35-10, 0, 35, 40)];
        [complateBtn setTitle:@"完成" forState:0];
        [complateBtn setTitleColor:[UIColor blueColor] forState:0];
        complateBtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
        [complateBtn addTarget:self action:@selector(closeTheKeyboard)forControlEvents:UIControlEventTouchUpInside];
        [_keyboardToolbar addSubview:complateBtn];
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:_keyboardToolbar];
                break;
            }
        }
        _keyboardToolbar.alpha=0;
    }
    return _keyboardToolbar;
}



+(instancetype)shareClass{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        _sharedClass = [[JVshowKeyboardManger alloc] init];
    });
    return _sharedClass;
}

//添加通知
+(void)addNotificationWithTextFiled:(JVTextField*)textFiled{
    JVshowKeyboardManger* thisObject=[JVshowKeyboardManger shareClass];
    thisObject.textFiled=textFiled;
    //计算 moveView 在window中的 rect.origin.y
    thisObject.viewY=[thisObject relativeFrameForScreenWithView:thisObject.textFiled].origin.y;
    [thisObject addKeyboardNotification];
}





//移除通知
+(void)removeNotificationWithTextFiled:(JVTextField*)textFiled{
    JVshowKeyboardManger* thisObject=[JVshowKeyboardManger shareClass];
    [thisObject removeNotification];
}


#pragma -mark添加通知
-(void)addKeyboardNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma -mark 移除通知
-(void)removeNotification{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark 键盘显示时
- (void)keyboardWillShow:(NSNotification *)notif {
    if (self.textFiled==nil||self.textFiled.moveView==nil) return;
    //得到鍵盤的高度
    CGSize kbSize = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height;
    
    CGFloat viewY=self.viewY;
    CGFloat viewMaxY=viewY+self.textFiled.frame.size.height;
    CGFloat moveY=viewMaxY+kbHeight-[UIScreen mainScreen].bounds.size.height+40;
    if (moveY>0) {
            self.textFiled.moveView.bounds=CGRectMake(0, moveY, self.textFiled.moveView.frame.size.width, self.textFiled.moveView.frame.size.height);
    }
    self.keyboardToolbar.alpha=1;
    self.keyboardToolbar.frame=CGRectMake(self.keyboardToolbar.frame.origin.x, JVScreen_Height-kbHeight-40, self.keyboardToolbar.frame.size.width, self.keyboardToolbar.frame.size.height);
}
#pragma -mark 键盘隐藏
- (void)keyboardWillHide:(NSNotification *)notif {
    
    self.keyboardToolbar.alpha=0;
    
    [UIView animateWithDuration:0.25 animations:^{
         self.textFiled.moveView.bounds=CGRectMake(0, 0, self.textFiled.moveView.frame.size.width, self.textFiled.moveView.frame.size.height);
        self.keyboardToolbar.frame=CGRectMake(self.keyboardToolbar.frame.origin.x, JVScreen_Height, self.keyboardToolbar.frame.size.width, self.keyboardToolbar.frame.size.height);
    }completion:^(BOOL finished) {
        
    }];
}



#pragma -mark 点击关闭键盘
-(void)closeTheKeyboard{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


#pragma -mark 计算moveview 在 window中的 rect
-(CGRect)relativeFrameForScreenWithView:(UIView *)v
{
    UIView *view = v;
    CGFloat x = .0;
    CGFloat y = .0;
    // root  uiwindow  superView ==nil
    while ([view superview])
    {
        x += view.frame.origin.x;
        y += view.frame.origin.y;
        view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            x -= ((UIScrollView *) view).contentOffset.x;
            y -= ((UIScrollView *) view).contentOffset.y;
        }
    }
    return CGRectMake(x, y, v.frame.size.width, v.frame.size.height);
}


@end
