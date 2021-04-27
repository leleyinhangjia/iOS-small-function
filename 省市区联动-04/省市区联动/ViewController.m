//
//  ViewController.m
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

#import "OVConfig.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) OVLocationModel *locationModel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)style:0];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    secondViewController.locationModel = _locationModel;
    [self presentViewController:secondViewController animated:YES completion:nil];
    @weakify(self)
    [secondViewController.subject subscribeNext:^(OVLocationModel *locationModel) {
        @strongify(self)
        self.locationModel = locationModel;
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"keboard";
            break;
            
        default:
            break;
    }
    return cell;
}

@end
