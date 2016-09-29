//
//  ErrorHandleManager.h
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNApiManager.h"


@interface ErrorHandleManager : NSObject<CNNetworkErrorDelegate> {
    NSDictionary *_errorMsgDictionary;
}

@end
