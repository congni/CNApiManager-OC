//
//  ResultModel.h
//  Pods
//
//  Created by 汪君 on 16/6/14.
//
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSObject *result;

@end