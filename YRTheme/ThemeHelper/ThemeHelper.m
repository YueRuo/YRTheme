//
//  ThemeHelper.m
//  YRTheme
//
//  Created by wangxiaoyu on 16/6/16.
//  Copyright © 2016年 wangxiaoyu. All rights reserved.
//

#import "ThemeHelper.h"
#import "YRTheme.h"
#import <Foundation/Foundation.h>

@implementation ThemeHelper

+ (UIImage *)getImage:(NSString*)imageThemeName theme:(NSString*)theme{
    //这里以打包在客户端内的素材为例，也可根据个人项目需要，修改代码为网上下载后的目录地址或文件地址
    NSString *fileName = [NSString stringWithFormat:@"%@Theme",theme];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *imageName = [dic objectForKey:imageThemeName];
    if (imageName) {
        return [UIImage imageNamed:imageName];
    }
    return nil;
}
+ (UIColor *)getColor:(NSString*)colorThemeName theme:(NSString*)theme{
    //这里以打包在客户端内的素材为例，也可根据个人项目需要，修改代码为网上下载后的目录地址或文件地址
    NSString *fileName = [NSString stringWithFormat:@"%@Theme",theme];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *colorHex = [dic objectForKey:colorThemeName];
    if (colorHex) {
        return [self colorWithHexString:colorHex];
    }
    return nil;
}
+ (id)getValue:(NSString*)valueThemeName theme:(NSString*)theme{
    //这里以打包在客户端内的素材为例，也可根据个人项目需要，修改代码为网上下载后的目录地址或文件地址
    NSString *fileName = [NSString stringWithFormat:@"%@Theme",theme];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    id value = [dic objectForKey:valueThemeName];
    return value;
}

+ (void)configTheme{
    //设置默认主题皮肤
    [[YRTheme shared]setDefaultThemeName:@"Default"];
    //设置获取图片方式
    [[YRTheme shared]setGetImageBlock:^UIImage *(NSString *themeName, NSString *imageName) {
        UIImage *resultImage = [self getImage:imageName theme:themeName];
        if (!resultImage) {
            resultImage = [self getImage:imageName theme:[[YRTheme shared] defaultThemeName]];
        }
        return resultImage;
    }];
    //设置获取颜色
    [[YRTheme shared]setGetColorBlock:^UIColor *(NSString *themeName, NSString *colorName) {
        UIColor *resultColor = [self getColor:colorName theme:themeName];
        if (!resultColor) {
            resultColor = [self getColor:colorName theme:[[YRTheme shared] defaultThemeName]];
        }
        return resultColor;
    }];
    //设置获取原始值
    [[YRTheme shared]setGetValueBlock:^id(NSString *themeName, NSString *valueName) {
        id value = [self getValue:valueName theme:themeName];
        if (!value) {
            value = [self getValue:valueName theme:[[YRTheme shared] defaultThemeName]];
        }
        return value;
    }];
}


+ (UIColor *)colorWithHexString:(NSString *)hexColorString {
    if ([hexColorString length] < 6) { //长度不合法
        return [UIColor blackColor];
    }
    NSString *tempString = [hexColorString lowercaseString];
    if ([tempString hasPrefix:@"0x"]) { //检查开头是0x
        tempString = [tempString substringFromIndex:2];
    } else if ([tempString hasPrefix:@"#"]) { //检查开头是#
        tempString = [tempString substringFromIndex:1];
    }
    if ([tempString length] != 6) {
        return [UIColor blackColor];
    }
    //分解三种颜色的值
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}
@end
