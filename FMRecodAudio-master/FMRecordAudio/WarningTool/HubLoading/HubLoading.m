//
//  HubLoading.m
//  Project
//
//  Created by pipixia on 2017/9/13.
//  Copyright © 2017年 pipixia. All rights reserved.
//

#import "HubLoading.h"
#import "UIImage+GIF.h"

@implementation HubLoading

+ (HubLoading*)shareInstance
{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

+ (void)showLoading
{
    [[HubLoading shareInstance] showLoading];
}

- (void)showLoading
{
//    if (!showBgView) {
//        showBgView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
//        showBgView.backgroundColor = [UIColor clearColor];
//    }
//    showBgView.alpha = 1.f;
//    if (!loadingBgView) {
//        loadingBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        loadingBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
//        loadingBgView.center = showBgView.center;
//    }
//    if (loadingLabel) {
//        loadingBgView.backgroundColor = [UIColor blackColor];;
//        [loadingLabel removeFromSuperview];
//    }
//    [showBgView addSubview:loadingBgView];
    
    if (!loadingImg) {
        loadingImg = [UIImageView new];
        loadingImg.frame = CGRectMake((SCREEN_WIDTH-80)/2, (SCREEN_HEIGHT-80)/2, 80, 80);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loadingImg" ofType:@"gif"];
        NSData *data = [NSData dataWithContentsOfFile:path];
//        UIImage *image = [UIImage sd_animatedGIFWithData:data];
//        loadingImg.image = image;

        
//        UIImage *iconImg = [UIImage imageNamed:@"loading01"];
//        loadingImg.frame = CGRectMake(0, 0, iconImg.size.width*.6, iconImg.size.height*.6);
//        loadingImg.center = showBgView.center;
//        loadingImg.contentMode = UIViewContentModeScaleAspectFit;
//        loadingImg.animationImages = [NSArray arrayWithObjects:
//                                      [UIImage imageNamed:@"loading01"],
//                                      [UIImage imageNamed:@"loading02"],
//                                      [UIImage imageNamed:@"loading03"],
//                                      [UIImage imageNamed:@"loading04"],
//                                      [UIImage imageNamed:@"loading05"],
//                                      [UIImage imageNamed:@"loading06"],
//                                      [UIImage imageNamed:@"loading07"],
//                                      [UIImage imageNamed:@"loading08"],
//                                      [UIImage imageNamed:@"loading09"],
//                                      [UIImage imageNamed:@"loading10"],
//                                      [UIImage imageNamed:@"loading11"],
//                                      [UIImage imageNamed:@"loading12"],nil];
//        [loadingImg setAnimationDuration:.9f];
//        [loadingImg setAnimationRepeatCount:0];
    }
//    [loadingImg startAnimating];
//    [showBgView addSubview:loadingImg];
//    [[UIApplication sharedApplication].keyWindow addSubview:showBgView];
    [[UIApplication sharedApplication].keyWindow addSubview:loadingImg];
    
    [self performSelector:@selector(hiddenHub) withObject:nil afterDelay:200];
}

+ (void)showText:(NSString*)text
{
    [[HubLoading shareInstance] showText:text];
}

- (void)showText:(NSString *)text
{
    if (!tipLab) {
       
        tipLab = [[UILabel alloc]init];
        tipLab.text = HPString(@"%@",text);
        tipLab.font = FH(15.0f);
        tipLab.textAlignment = NSTextAlignmentCenter;
        tipLab.textColor = [UIColor whiteColor];
        tipLab.backgroundColor = [UIColor blackColor];
        tipLab.layer.cornerRadius = 5.f;
        tipLab.clipsToBounds = YES;
        [showBgView addSubview:tipLab];
    }
    tipLab.text = HPString(@"%@",text);
    CGSize tipSize = [tipLab sizeThatFits:CGSizeMake(SCREEN_WIDTH-20, 60)];
    tipLab.frame = CGRectMake(0, 0, tipSize.width+20, tipSize.height+20);
    CGPoint windowCenter = [UIApplication sharedApplication].keyWindow.center;
    tipLab.center = CGPointMake(windowCenter.x, windowCenter.y - 120);
    tipLab.alpha = 1.f;
    [[UIApplication sharedApplication].keyWindow addSubview:tipLab];
    [UIView animateWithDuration:3 animations:^{
        tipLab.alpha = .0f;
    } completion:^(BOOL finished) {
        [tipLab removeFromSuperview];
    }];
}

+ (void)hiddenLoading
{
    [[HubLoading shareInstance] hiddenHub];
}

- (void)hiddenHub
{
    [loadingImg removeFromSuperview];
    [showBgView removeFromSuperview];
    [loadingBgView removeFromSuperview];
}

@end
