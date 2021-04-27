//
//  HWNavViewController.m
//  HWPopController_Example
//
//  Created by heath wang on 2019/6/10.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWNavViewController.h"
#import <HWPopController/HWPop.h>
#import "HWCatViewController.h"

@interface HWNavViewController ()

@end

@implementation HWNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.contentSizeInPop = CGSizeMake(screenSize.width, screenSize.height *0.9);
    //self.contentSizeInPopWhenLandscape = CGSizeMake(screenSize.height, screenSize.width * 0.9);
    
    self.navigationBar.translucent = NO;
}

@end
