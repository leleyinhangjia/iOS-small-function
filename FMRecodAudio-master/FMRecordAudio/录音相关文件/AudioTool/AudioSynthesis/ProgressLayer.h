//
//  ArcToCircleLayer.h
//  qh-ios
//
//  Created by 皮皮虾 on 2019/4/25.
//  Copyright © 2019 皮皮虾. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface ProgressLayer : CALayer

@property (nonatomic) CGFloat progress;


/**
 显示加载进度
 @return 返回
 */
+ (ProgressLayer *)showProgress;


/**
 隐藏加载
 */
- (void)hiddenProgress;

@end
