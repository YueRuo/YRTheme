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
- (UIImage *)imageWithName:(NSString *)imageThemeName {
    return [self imageWithName:imageThemeName theme:self.currentThemeName];
}

- (UIImage *)imageWithName:(NSString *)imageThemeName theme:(NSString *)themeName {
    if (themeName && self.getImageBlock) {
        return self.getImageBlock(themeName, imageThemeName);
    }
    return [UIImage imageNamed:imageThemeName];
}

- (UIColor *)colorWithName:(NSString *)colorThemeName {
    return [self colorWithName:colorThemeName theme:self.currentThemeName];
}

- (UIColor *)colorWithName:(NSString *)colorThemeName theme:(NSString *)themeName {
    if (themeName && self.getColorBlock) {
        return self.getColorBlock(themeName, colorThemeName);
    }
    return [UIColor whiteColor];
}
- (id)valueWithName:(NSString *)valueThemeName{
    return [self valueWithName:valueThemeName theme:self.currentThemeName];
}
- (id)valueWithName:(NSString *)valueThemeName theme:(NSString *)themeName{
    if (themeName && self.getValueBlock) {
        return self.getValueBlock(themeName, valueThemeName);
    }
    return [UIColor redColor];
}
@end
