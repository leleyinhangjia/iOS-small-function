//
//  SecondViewController.h
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OVConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecondViewController : UIViewController

@property (nonatomic, strong) OVLocationModel *locationModel;

@property (nonatomic, strong) RACSubject *subject;

@end

NS_ASSUME_NONNULL_END
