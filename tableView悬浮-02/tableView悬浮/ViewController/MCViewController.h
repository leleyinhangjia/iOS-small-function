//
//  MCViewController.h
//  tableview悬浮userCenter
//
//  Created by lujh on 16/4/19.
//  Copyright © 2016年 MuChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MCViewController : UIViewController
// tablev的头视图
@property (nonatomic, strong) UIView *headerView;

// tableView
@property(nonatomic,strong)UITableView *tableView;

// 弹出遮罩层view
@property(nonatomic,strong)UIView *topCoverView;

// 弹出透明层view
@property(nonatomic,strong)UIView *bottomCoverView;

// tableview 的偏移量
@property(nonatomic,assign)CGFloat yOffset;


@end
