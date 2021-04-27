//
//  ViewController.m
//  FMRecordAudio
//
//  Created by 范明 on 2019/8/2.
//  Copyright © 2019 范明. All rights reserved.
//

#import "ViewController.h"
#import "FMAudioMicViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(100, 200, 100, 30);
    Btn.backgroundColor = [UIColor redColor];
    [Btn setTitle:@"录音跳转" forState:0];
    [Btn setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:Btn];
    [Btn addTarget:self action:@selector(BtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)BtnAction{
    NSLog(@"点击了跳转");
    
    FMAudioMicViewController *vc = [FMAudioMicViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
