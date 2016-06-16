//
//  YRThemeManager.m
//  Pods
//
//  Created by wangxiaoyu on 16/6/15.
//
//

#import "YRThemeManager.h"

static const NSString *kYRThemeObjViewBg = @"kYRThemeObjViewBg";
static const NSString *kYRThemeObjTitleColor = @"kYRThemeObjTitleColor";
static const NSString *kYRThemeObjImage = @"kYRThemeObjImage";

@interface YRThemeSafeObject : NSObject<NSCopying>
@property (weak, nonatomic) id obj;
@end
@implementation YRThemeSafeObject
- (void)setObj:(id)obj {
    _obj = obj;
}
- (id)copyWithZone:(nullable NSZone *)zone{
    return self;
}
@end

@implementation YRThemeManager {
    NSMutableDictionary *_themeObjDic;
    dispatch_queue_t _themeQueue;
}

- (instancetype)init {
    if (self = [super init]) {
        _themeObjDic = [[NSMutableDictionary alloc]init];
        _themeQueue = dispatch_queue_create("themeSynQueue", DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeNotification:) name:kYRThemeChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeChangeNotification:(NSNotification *)notification {
    [self updateToTheme:notification.object];
}

- (void)updateToTheme:(NSString *)themeName {
    NSArray *allKeys = [_themeObjDic allKeys];
    [allKeys enumerateObjectsUsingBlock:^(id _Nonnull key, NSUInteger idx, BOOL *_Nonnull stop) {
        NSDictionary *obj = [_themeObjDic objectForKey:key];
        UIView *view = [key obj];
        if (!view) {
            [_themeObjDic removeObjectForKey:key];
        } else {
            NSString *bgColorString = [obj objectForKey:kYRThemeObjViewBg];
            if (bgColorString) {
                [view setBackgroundColor:[[YRTheme shared]colorWithName:bgColorString theme:themeName]];
            }
            if ([view isKindOfClass:[UILabel class]]) {
                NSString *titleColorString = [obj objectForKey:kYRThemeObjTitleColor];
                if (titleColorString) {
                    [(UILabel *) view setTextColor:[[YRTheme shared]colorWithName:titleColorString theme:themeName]];
                }
            }
            if ([view isKindOfClass:[UIImageView class]]) {
                NSString *imageNameString = [obj objectForKey:kYRThemeObjImage];
                if (imageNameString) {
                    [(UIImageView *) view setImage:[[YRTheme shared]imageWithName:imageNameString theme:themeName]];
                }
            }
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *) view;
                [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull stateObj, id  _Nonnull dic, BOOL * _Nonnull stop) {
                    UIControlState state = [stateObj integerValue];
                    NSString *imageNameString = [dic objectForKey:kYRThemeObjImage];
                    NSString *titleColorString = [dic objectForKey:kYRThemeObjTitleColor];
                    NSString *bgImageNameString = [dic objectForKey:kYRThemeObjViewBg];
                    if (imageNameString) {
                        [button setImage:[[YRTheme shared]imageWithName:imageNameString theme:themeName] forState:state];
                    }
                    if (titleColorString) {
                        [button setTitleColor:[[YRTheme shared]colorWithName:titleColorString theme:themeName] forState:state];
                    }
                    if (bgImageNameString) {
                        [button setBackgroundImage:[[YRTheme shared]imageWithName:bgImageNameString theme:themeName] forState:state];
                    }
                }];
            }
        }
    }];
}

#pragma mark private
- (YRThemeSafeObject *)themeSafeObjectForView:(UIView *)view {
    __block YRThemeSafeObject *safeObj = nil;
    [_themeObjDic enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        if ([key obj] == view) {
            safeObj = key;
            *stop = true;
        }
    }];
    if (!safeObj) {
        safeObj = [[YRThemeSafeObject alloc] init];
        safeObj.obj = view;
    }
    return safeObj;
}
- (NSMutableDictionary *)dictionaryForSafeObj:(YRThemeSafeObject *)safeObj {
    NSMutableDictionary *objDic = [_themeObjDic objectForKey:safeObj];
    if (!objDic) {
        objDic = [[NSMutableDictionary alloc] initWithCapacity:6];
        [_themeObjDic setObject:objDic forKey:safeObj];
    }
    return objDic;
}
- (NSMutableDictionary *)stateDictionaryForSafeObj:(YRThemeSafeObject *)safeObj state:(UIControlState)state {
    NSMutableDictionary *objDic = [self dictionaryForSafeObj:safeObj];
    NSMutableDictionary *stateDic = [objDic objectForKey:@(state)];
    if (!stateDic) {
        stateDic = [[NSMutableDictionary alloc] initWithCapacity:6];
        [objDic setObject:stateDic forKey:@(state)];
    }
    return stateDic;
}

#pragma mark public
- (void)bindView:(UIView *)view bgColorName:(NSString *)colorThemeName {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:view];
        NSMutableDictionary *objDic = [self dictionaryForSafeObj:safeObj];
        [objDic setObject:colorThemeName forKey:kYRThemeObjViewBg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [view setBackgroundColor:YRThemeColor(colorThemeName)];
        });
    });
}
- (void)bindImageView:(UIImageView *)imageView imageName:(NSString *)imageThemeName {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:imageView];
        NSMutableDictionary *objDic = [self dictionaryForSafeObj:safeObj];
        [objDic setObject:imageThemeName forKey:kYRThemeObjImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [imageView setImage:YRThemeImage(imageThemeName)];
        });
    });
}
- (void)bindLabel:(UILabel *)label titleColorName:(NSString *)colorThemeName {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:label];
        NSMutableDictionary *objDic = [self dictionaryForSafeObj:safeObj];
        [objDic setObject:colorThemeName forKey:kYRThemeObjTitleColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setTextColor:YRThemeColor(colorThemeName)];
        });
    });
}
- (void)bindButton:(UIButton *)button imageName:(NSString *)imageThemeName state:(UIControlState)state {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:button];
        NSMutableDictionary *objDic = [self stateDictionaryForSafeObj:safeObj state:state];
        [objDic setObject:imageThemeName forKey:kYRThemeObjImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setImage:YRThemeImage(imageThemeName) forState:state];
        });
    });
}
- (void)bindButton:(UIButton *)button titleColorName:(NSString *)colorThemeName state:(UIControlState)state {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:button];
        NSMutableDictionary *objDic = [self stateDictionaryForSafeObj:safeObj state:state];
        [objDic setObject:colorThemeName forKey:kYRThemeObjTitleColor];
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setTitleColor:YRThemeColor(colorThemeName) forState:state];
        });
    });
}
- (void)bindButton:(UIButton *)button bgImageName:(NSString *)bgImageThemeName state:(UIControlState)state {
    dispatch_sync(_themeQueue, ^{
        YRThemeSafeObject *safeObj = [self themeSafeObjectForView:button];
        NSMutableDictionary *objDic = [self stateDictionaryForSafeObj:safeObj state:state];
        [objDic setObject:bgImageThemeName forKey:kYRThemeObjViewBg];
        dispatch_async(dispatch_get_main_queue(), ^{
            [button setBackgroundImage:YRThemeImage(bgImageThemeName) forState:state];
        });
    });
}
@end
