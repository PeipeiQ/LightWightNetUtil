//
//  ViewController.m
//  LightWightNetUtil
//
//  Created by 沛沛 on 2018/6/21.
//  Copyright © 2018年 沛沛. All rights reserved.
//

#import "ViewController.h"
#import "NetUtilManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetUtilManager *manager = [NetUtilManager manager];
    [manager getFromUrl:@"/content" para:nil successResult:^(id response, NSHTTPURLResponse *httpResponse) {
        
    } errorResult:^( NSError *error, NSHTTPURLResponse *httpResponse) {
        
    }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
