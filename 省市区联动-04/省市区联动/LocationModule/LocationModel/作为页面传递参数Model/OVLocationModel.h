//
//  OVLocationModel.h
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OVLocationModel : NSObject

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *areaName;

@end

NS_ASSUME_NONNULL_END
