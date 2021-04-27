//
//  UIBarButtonItem+Item.m
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (instancetype)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *barButton = [UIButton buttonWithType:0];
    [barButton setTitle:title forState:0];
    if ([title isEqualToString:@"取消"]) {
        [barButton setTitleColor:[UIColor redColor] forState:0];
    } else {
        [barButton setTitleColor:[UIColor grayColor] forState:0];
    }
    [barButton sizeToFit];
    [barButton addTarget:target action:action forControlEvents:controlEvents];
    return [[UIBarButtonItem alloc] initWithCustomView:barButton];
}


@end
