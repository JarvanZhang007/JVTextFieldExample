//
//  JVshowKeyboardManger.h
//  HD_Car
//
//  Created by xingso on 15/9/11.
//  Copyright (c) 2015年 HD_CyYihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JVTextField.h"
@interface JVshowKeyboardManger : NSObject

+(instancetype)shareClass;

/**添加通知*/
+(void)addNotificationWithTextFiled:(JVTextField*)textFiled;

/**移除通知*/
+(void)removeNotificationWithTextFiled:(JVTextField*)textFiled;

@end
