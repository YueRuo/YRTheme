//
//  YRTheme.m
//  Pods
//
//  Created by wangxiaoyu on 16/6/14.
//
//

#import "YRTheme.h"
NSString *const kYRThemeChangeNotification = @"kYRThemeChangeNotification";

@implementation YRTheme
+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

#pragma mark private
- (void)setDefaultThemeName:(NSString *)defaultThemeName {
    _defaultThemeName = defaultThemeName;
    if (!_currentThemeName) {
        _currentThemeName = defaultThemeName;
    }
}

- (void)setCurrentThemeName:(NSString *)currentThemeName {
    if (_currentThemeName != currentThemeName) {
        _currentThemeName = currentThemeName;
        [[NSNotificationCenter defaultCenter] postNotificationName:kYRThemeChangeNotification object:currentThemeName];
    }
}

#pragma mark public
- (UIImage *)imageWithName:(NSString *)imageName {
    return [self imageWithName:imageName theme:self.currentThemeName];
}

- (UIImage *)imageWithName:(NSString *)imageName theme:(NSString *)themeName {
    if (themeName && self.getImageBlock) {
        return self.getImageBlock(themeName, imageName);
    }
    return [UIImage imageNamed:imageName];
}

- (UIColor *)colorWithName:(NSString *)colorName {
    return [self colorWithName:colorName theme:self.currentThemeName];
}

- (UIColor *)colorWithName:(NSString *)colorName theme:(NSString *)themeName {
    if (themeName && self.getColorBlock) {
        return self.getColorBlock(themeName, colorName);
    }
    return [UIColor redColor];
}
- (id)valueWithName:(NSString *)valueName{
    return [self valueWithName:valueName theme:self.currentThemeName];
}
- (id)valueWithName:(NSString *)valueName theme:(NSString *)themeName{
    if (themeName && self.getValueBlock) {
        return self.getValueBlock(themeName, valueName);
    }
    return [UIColor redColor];
}
@end
