//
//  NetUtilManager.h
//  LightWightNetUtil
//
//  Created by 沛沛 on 2018/6/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#define BaseUrl @"http://localhost"

#import <Foundation/Foundation.h>
#import <Uikit/Uikit.h>

typedef void(^successBlock)(id response,NSHTTPURLResponse *httpResponse);
typedef void(^errorBlock)(NSError *error,NSHTTPURLResponse *httpResponse);

@interface NetUtilManager : NSObject
+(instancetype)manager;
-(void)getFromUrl:(NSString*)urlString para:(NSDictionary*)paraDic successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock;
-(void)postFromUrl:(NSString*)urlString para:(NSDictionary*)paraDict successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock;
@end
