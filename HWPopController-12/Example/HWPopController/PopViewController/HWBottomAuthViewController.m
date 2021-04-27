//
//  HWBottomAuthViewController.m
//  HWPopController_Example
//
//  Created by heath wang on 2019/5/23.
//  Copyright © 2019 wangcongling. All rights reserved.
//

#import "HWBottomAuthViewController.h"
#import <HWPopController/HWPop.h>
#import <Masonry/View+MASAdditions.h>

@interface HWBottomAuthViewController ()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation HWBottomAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    self.contentSizeInPop = CGSizeMake(CGRectGetWidth(screenFrame), CGRectGetHeight(screenFrame) * 0.9);
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.confirmButton];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(screenFrame) * 0.9 -30, 100, 30)];
    textField.placeholder = @"浪费大放送";
    [self.view addSubview:textField];

    [self setupViewConstraints];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)setupViewConstraints {
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.bottom.equalTo(@-15);
        make.height.mas_equalTo(60);
    }];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.equalTo(@5);
        make.top.equalTo(@5);
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@5);
        //make.right.equalTo(@-15);
        make.centerX.equalTo(self.view);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"btn_close_black"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.590 blue:1.000 alpha:1.00]];
        _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:30];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 6;
        [_confirmButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"Allow App to use you Camera.";
        _tipLabel.font = [UIFont boldSystemFontOfSize:24];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}


@end
