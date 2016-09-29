//
//  ViewController.m
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/5/31.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import "ViewController.h"
#import "CNApiManager.h"
#import "ErrorHandleManager.h"
#import "URLProfileManager.h"
#import "AdverApiManager.h"


@interface ViewController ()<ApiLoadCallBackProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ViewController networkingSetting];
    
    CNBaseApiManager *apiManager = [[CNBaseApiManager alloc] init];
    apiManager.requestURL = [URLProfileManager dataMapURL];
    apiManager.apiCallBackDelegate = self;
    apiManager.httpMethod = GET;
    apiManager.apiName = @"kApiManagerNameDataMap";
    [apiManager loadApiDataByParam:nil];
    
    AdverApiManager *advervicesApiManager = [[AdverApiManager alloc] init];
    advervicesApiManager.apiCallBackDelegate = self;
    [advervicesApiManager request];
}

#pragma mark 网络层设置
+ (void)networkingSetting {
    NSString *udid = @"jdahdhfjaidaihddhdhdhdhdhdhdhdhdhdhd";
    NSString *deviceType = @"5";
    
    NSDictionary *headerDictionary = @{@"DeviceId": udid,
                                       @"DeviceType": deviceType};
    
    [NetworkRequestTools afHTTPRequestSettingWithRequestHeader:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]];
    [NetworkRequestTools afHttpRequestHandleDataSetting:[[ErrorHandleManager alloc] init]];
    [NetworkRequestTools afHttpRequestDataNeedLog:NO];
    
    [NetworkRequestTools afHttpRequestBaseParamsSetting:@{@"test": @"test"}];
}

#pragma mark - ApiLoadCallBackProtocol
- (void)apiLoadSuccessByApiManager:(CNBaseApiManager *)apiManager {
    if ([apiManager.apiName isEqualToString:@"kApiManagerNameDataMap"]) {
//        NSLog(@"apiManager  %@", apiManager.rawData);
    } else {
//        AdverApiManager *ad = (AdverApiManager *)apiManager;
        
    }
}

- (void)apiLoadFailByApiManager:(CNBaseApiManager *)apiManager {
    NSLog(@"apiLoadFailByApiManager   %@", apiManager.apiError.domain);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
