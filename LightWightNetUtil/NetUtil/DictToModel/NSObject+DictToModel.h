//
//  NSObject+DictToModel.h
//  LightWightNetUtil
//
//  Created by 沛沛 on 2018/6/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DictToModel)
+ (instancetype)objcWithDict:(NSDictionary *)dict mapDict:(NSDictionary *)mapDict;
@end
