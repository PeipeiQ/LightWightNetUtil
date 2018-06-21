//
//  NetUtilManager.m
//  LightWightNetUtil
//
//  Created by 沛沛 on 2018/6/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "NetUtilManager.h"
#import "NSObject+DictToModel.h"
@interface NetUtilManager()

@end

@implementation NetUtilManager
+(instancetype)manager{
    static NetUtilManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[NetUtilManager alloc]init];
    });
    return _instance;
}

-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}

-(void)getFromUrl:(NSString*)urlString para:(NSDictionary*)paraDic successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock{
    
    [self getFromUrl:urlString para:paraDic modelClass:nil mapDict:nil successResult:successBlock errorResult:errorBlock];
    
}

-(void)postFromUrl:(NSString*)urlString para:(NSDictionary*)paraDict successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock{
    
    [self postFromUrl:urlString para:paraDict modelClass:nil mapDict:nil successResult:successBlock errorResult:errorBlock];
    
}

-(void)getFromUrl:(NSString*)urlString para:(NSDictionary*)paraDic modelClass:(Class)ModelClass mapDict:(NSDictionary*)mapDict successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock{
    
    urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,urlString];
    if (paraDic.count>0) {
        NSArray *allKeys = [paraDic allKeys];
        NSMutableString *paraString = [NSMutableString new];
        [allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [paraString appendFormat:@"%@=%@&",obj,paraDic[obj]];
        }];
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,[paraString substringToIndex:paraString.length-1]];
    }
    NSLog(@"get请求url:%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request.HTTPMethod = @"Get";
    
    [self taskWithRequest:request method:@"GET" modelClass:ModelClass mapDict:mapDict successBlock:successBlock errorBlock:errorBlock];
}



-(void)postFromUrl:(NSString*)urlString para:(NSDictionary*)paraDict modelClass:(Class)ModelClass mapDict:(NSDictionary*)mapDict successResult:(successBlock)successBlock errorResult:(errorBlock)errorBlock{
    urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,urlString];
    NSLog(@"post请求url:%@", urlString);
    NSLog(@"post请求body:%@", paraDict);
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    request.HTTPMethod = @"POST";
    
    NSMutableString *paraStr = [[NSMutableString alloc]init];
    for (NSString *key in paraDict.allKeys) {
        [paraStr appendFormat:@"%@=%@&",key,paraDict[key]];
    }
    NSData *paraData = [[paraStr substringToIndex:paraStr.length-1] dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = paraData;
    
    [self taskWithRequest:request method:@"POST" modelClass:ModelClass mapDict:mapDict successBlock:successBlock errorBlock:errorBlock];
}


// mapDict:由外界通知内部，模型中成员变量名对应字典里面的哪个key
// eg:ID -> id
-(void)taskWithRequest:(NSMutableURLRequest*)request method:(NSString*)httpMethod modelClass:(Class)ModelClass mapDict:(NSDictionary*)mapDict successBlock:(successBlock)successBlock errorBlock:(errorBlock)errorBlock{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //模拟网络延时
        //[NSThread sleepForTimeInterval:1.0];
        
        //解析response
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSString *responseType = httpResponse.allHeaderFields[@"Content-Type"];
        if (error) {
            NSLog(@"%@", error);
            errorBlock(error,httpResponse);
            return ;
        }
        
        if (httpResponse.statusCode/100==2) {
            if ([responseType rangeOfString:@"json"].location !=NSNotFound) {
                //json转字典
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"status code:%ld",httpResponse.statusCode);
                NSLog(@"response json:%@",json);
                if (ModelClass) {
                    //字典转模型
                    id model = [ModelClass new];
                    model = [ModelClass objcWithDict:json mapDict:mapDict];
                    successBlock(model,httpResponse);
                }else{
                    successBlock(json,httpResponse);
                }
                return;
            }
            if ([responseType rangeOfString:@"image"].location !=NSNotFound) {
                UIImage *image = [UIImage imageWithData:data];
                NSLog(@"status code:%ld",httpResponse.statusCode);
                NSLog(@"image:%@",image);
                successBlock(image,httpResponse);
                return;
            }
            NSLog(@"status code:%ld",httpResponse.statusCode);
            NSLog(@"%@", httpResponse);
            successBlock(data,httpResponse);
            return;
        }
        NSLog(@"status code:%ld",httpResponse.statusCode);
        NSLog(@"response info:%@",httpResponse);
        successBlock(data,httpResponse);
    }];
    [task resume];
}





@end
