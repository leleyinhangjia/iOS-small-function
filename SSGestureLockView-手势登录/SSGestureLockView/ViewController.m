//
//  ViewController.m
//  SSGestureLockView
//
//  Created by ThisRhythm on 2018/10/10.
//  Copyright © 2018 ThisRhythm. All rights reserved.
//

#import "ViewController.h"
#import "SSGestureLockView.h"

@interface ViewController ()<SSGestureLockViewDelegate>
{
    NSString *password;
    NSString *password1;
    NSString *password2;
    SSGestureLockView *gestureLockView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    password = @"";
    gestureLockView = [[SSGestureLockView alloc]initWithFrame:CGRectZero];
    gestureLockView.delegate = self;
    gestureLockView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-240)/2, (CGRectGetHeight(self.view.frame)-240)/2, 240, 240);
    [self.view addSubview:gestureLockView];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didSelectedGestureLockView:(SSGestureLockView *)gestureLockView keyNumStr:(NSString *)keyNumStr{
    NSLog(@"%@",keyNumStr);
    if (password.length == 0) {
        if (password1.length==0) {
            password1 = keyNumStr;
             gestureLockView.showErrorStatus = YES;
             NSLog(@"第一次输入");
        }else{
            password2 = keyNumStr;
            if (![password2 isEqualToString:password1]) {
                gestureLockView.showErrorStatus = YES;
                 NSLog(@"第一次和第二次不一致");
            }else{
                password = password2;
                NSLog(@"密码设置成功");
            }
                
        }
    }else {
        if (![keyNumStr isEqualToString:password]) {
            gestureLockView.showErrorStatus = YES;
        }else{
            NSLog(@"密码正确");
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
