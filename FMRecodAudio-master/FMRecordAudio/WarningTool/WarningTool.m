//
//  WarningTool.m
//  Project
//
//  Created by pipixia on 2017/9/13.
//  Copyright © 2017年 pipixia. All rights reserved.
//

#import "WarningTool.h"
#import "HubLoading.h"

@implementation WarningTool

+ (void)showToastHintWithText:(NSString *)message
{
    if (message.length >0)
    {
//        TKAlertCenter *alert = [TKAlertCenter defaultCenter];
//        [alert postAlertWithMessage:message];
        [HubLoading showText:message];
    }
}

+ (void)showToastNetError
{
//    TKAlertCenter *alert = [TKAlertCenter defaultCenter];
//    [alert postAlertWithMessage:@"网络异常请稍后再试"];
    [HubLoading showText:@"网络异常请稍后再试"];
}

@end
