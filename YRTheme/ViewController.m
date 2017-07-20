//
//  ViewController.m
//  YRTheme
//
//  Created by wangxiaoyu on 16/6/15.
//  Copyright © 2016年 wangxiaoyu. All rights reserved.
//

#import "ViewController.h"
#import "YRThemeManager.h"

@interface ViewController (){
    YRThemeManager *_manager;
}
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _manager = [[YRThemeManager alloc]init];
    //配置控件色彩样式等等
    [_manager bindView:self.view bgColorName:@"commonBgColor"];
    [_manager bindImageView:self.imageView imageName:@"testImage1"];
    [_manager bindLabel:self.label titleColorName:@"labelTitleColor"];
    [_manager bindButton:self.button titleColorName:@"labelTitleColor" state:UIControlStateNormal];
    [_manager bindButton:self.button titleColorName:@"buttonHighlight" state:UIControlStateHighlighted];
    [_manager bindButton:self.button1 titleColorName:@"labelTitleColor" state:UIControlStateNormal];
    [_manager bindButton:self.button1 titleColorName:@"buttonHighlight" state:UIControlStateHighlighted];
    
    __weak typeof(self) selfWeak = self;
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    
    [_manager bindView:self.label block:^(id value) {
        selfWeak.label.layer.borderWidth = [value floatValue];
    } byName:@"commonBorderWidth"];

}
- (IBAction)changeTheme:(id)sender {
    //切换皮肤只需要这一句,所有界面都会生效
    [[YRTheme shared]setCurrentThemeName:@"Dark"];
//    //仅仅切换当前界面主题
    [_manager updateToTheme:@"Dark"];
}
- (IBAction)changeThemeBack:(id)sender {
    //切换皮肤只需要这一句,所有界面都会生效
    [[YRTheme shared]setCurrentThemeName:@"Default"];
    //仅仅切换当前界面主题
//    [_manager updateToTheme:@"Default"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
