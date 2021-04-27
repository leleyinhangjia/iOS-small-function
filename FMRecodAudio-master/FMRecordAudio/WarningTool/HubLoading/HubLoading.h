//
//  HubLoading.h
//  Project
//
//  Created by pipixia on 2017/9/13.
//  Copyright © 2017年 pipixia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HubLoading : UIView
{
    UIView *showBgView;
    UIView *loadingBgView;
    UIImageView *loadingImg;
    UILabel *loadingLabel;
    UILabel *tipLab;
}

+ (void)showLoading;

+ (void)showText:(NSString*)text;

+ (void)hiddenLoading;

@end
