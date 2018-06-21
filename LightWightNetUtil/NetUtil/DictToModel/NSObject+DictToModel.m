//
//  NSObject+DictToModel.m
//  LightWightNetUtil
//
//  Created by 沛沛 on 2018/6/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NSObject+DictToModel.h"
#import <objc/runtime.h>

@implementation NSObject (DictToModel)

+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict
{
    id objc = [[self alloc] init];
    
    // 遍历模型中成员变量
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self, &outCount);
    
    for (int i = 0 ; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        // 成员变量名称
        NSString *ivarName = @(ivar_getName(ivar));
        
        // 获取出来的是`_`开头的成员变量名，需要截取`_`之后的字符串
        ivarName = [ivarName substringFromIndex:1];
        
        id value = dict[ivarName];
        // 由外界通知内部，模型中成员变量名对应字典里面的哪个key
        // ID -> id
        if (value == nil) {
            if (mapDict) {
                NSString *keyName = mapDict[ivarName];
                value = dict[keyName];
            }
        }
        
        if(value) {
            [objc setValue:value forKeyPath:ivarName];
        }else{
            NSLog(@"%@实例变量在字典中找不到匹配的值",ivarName);
        }
    }
    return objc;
}

@end
