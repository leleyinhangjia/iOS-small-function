//
//  ToolBar.m
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "ToolBar.h"

#import "UIBarButtonItem+Item.h"

@interface ToolBar ()

@end

@implementation ToolBar

- (instancetype)makeToolBar
{
    ToolBar * toolBar = [[ToolBar alloc] init];
    toolBar.backgroundColor = [UIColor whiteColor];
    toolBar.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0);
    
    UIBarButtonItem *doneButton = [UIBarButtonItem barButtonItemWithTitle:@"完成" target:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelButton = [UIBarButtonItem barButtonItemWithTitle:@"取消" target:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixItem.width = 20;//用来设置宽度的属性width

    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];//自动把按钮推到最右边

    toolBar.items = @[flexItem, doneButton, fixItem, cancelButton];
    return toolBar;
}

+ (instancetype)makeToolBar
{
    return [[self alloc] makeToolBar];
}

#pragma mark - Click Action

- (void)doneButtonClick:(UIBarButtonItem *)button
{
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(toolBarDone:)]) {
        [_keyBoardDelegate toolBarDone:self];
    }
}

- (void)cancelButtonClick:(UIBarButtonItem *)button
{
    if (_keyBoardDelegate && [_keyBoardDelegate respondsToSelector:@selector(toolBarCancel)]) {
        [_keyBoardDelegate toolBarCancel];
    }
}

@end
