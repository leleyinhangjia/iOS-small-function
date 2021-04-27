//
//  ViewController.m
//  Demo_AttributedLable
//
//  Created by Ihefe_Hanrovey on 2016/10/27.
//  Copyright © 2016年 Ihefe_Hanrovey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建UILabel控件
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    lab.center = self.view.center;
    lab.backgroundColor = [UIColor grayColor];
    
    
    // 创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:@"嘿嘿嘿嘿嘿123456789"];
    
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 5)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 5)];
    
    // 设置数字为红色
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, 9)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(5, 9)];
    
    
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:@"023[困]@2x.png"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, 0, 32, 32);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:attri.length];// 插入某个位置
    
    // 用label的attributedText属性来使用富文本
    lab.attributedText = attri;
    
    [self.view addSubview:lab];
    
    
}


@end
