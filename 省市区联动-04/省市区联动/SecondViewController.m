//
//  SecondViewController.m
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "SecondViewController.h"

#import "OVLocationPickerView.h"

#import "ToolBar.h"

@interface SecondViewController () <ToolBarDelegate>

@property (nonatomic, weak) UITextField *tF;

@end

@implementation SecondViewController

- (RACSubject *)subject
{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

- (void)toolBarDone:(ToolBar *)toolBar
{
    [self.view endEditing:YES];
    
    if (_locationModel == nil) {
        _locationModel = [[OVLocationModel alloc] init];
        _locationModel.provinceName = @"北京市";
        _locationModel.cityName = @"北京市";
        _locationModel.areaName = @"东城区";
    }
    
    _tF.text = [_locationModel.provinceName stringByAppendingString:[_locationModel.cityName stringByAppendingString:_locationModel.areaName]];
}

- (void)toolBarCancel
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self)
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    
    UITextField *tF = [[UITextField alloc] init];
    tF.frame = CGRectMake(30.0,200.0,200.0,50.0);
    tF.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15.0];
    tF.tintColor = [UIColor clearColor];
    tF.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:tF];
    _tF = tF;
    
    if (_locationModel != nil) {
        _tF.text = [_locationModel.provinceName stringByAppendingString:[_locationModel.cityName stringByAppendingString:_locationModel.areaName]];
    }
    
    OVLocationPickerView *locationPickerView = [[OVLocationPickerView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200.0)];
    locationPickerView.locationModel = _locationModel;
    [locationPickerView.subject subscribeNext:^(OVLocationModel *locationModel) {
        @strongify(self)
        self.locationModel = locationModel;
    }];
    
    ToolBar *toolBar = [ToolBar makeToolBar];
    toolBar.keyBoardDelegate = self;
    
    tF.inputView = locationPickerView;
    tF.inputAccessoryView = toolBar;
    
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(60.0,280.0,200.0,50.0);
    [btn setTitle:@"返回" forState:0];
    [self.view addSubview:btn];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.subject sendNext:self.locationModel];
    }];
}

@end
