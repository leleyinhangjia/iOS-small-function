//
//  WarningTool.h
//  Project
//
//  Created by pipixia on 2017/9/13.
//  Copyright © 2017年 pipixia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WarningTool : NSObject
+ (void)showToastHintWithText:(NSString *)message;
+ (void)showToastNetError;
@end
