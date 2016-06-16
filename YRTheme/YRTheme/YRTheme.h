//
//  YRTheme.h
//  Pods
//
//  Created by wangxiaoyu on 16/6/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define YRThemeImage(imageName) [[YRTheme shared] imageWithName:imageName]
#define YRThemeColor(colorName) [[YRTheme shared] colorWithName:colorName]

extern NSString *const kYRThemeChangeNotification;

@interface YRTheme : NSObject
/*!
 *	@brief	默认主题皮肤，该主题为基础主题，应当有所有素材
 */
@property (strong, nonatomic) NSString *defaultThemeName;

/*!
 *	@brief	当前主题皮肤,变更主题请设置该属性
 *  @note   需要注意的是，当某个素材无法查找到时，采用默认主题的素材
 */
@property (strong, nonatomic) NSString *currentThemeName;

///*!
// *	@brief	所有已支持的主题名称数组，方便枚举等
// */
//@property (strong, nonatomic) NSArray *themeNameArray;

//******************************
//*-begin-- 设置获取素材的方法
//          开发者需要提供这两个block，用于处理具体的theme获取素材功能
//          其实这里也可以设计成使用protocol来要求提供数据
//******************************
@property (copy, nonatomic) UIImage * (^getImageBlock)(NSString *themeName, NSString *imageName);
@property (copy, nonatomic) UIColor * (^getColorBlock)(NSString *themeName, NSString *colorName);
-(void)setGetColorBlock:(UIColor *(^)(NSString *themeName, NSString *colorName))getColorBlock;
-(void)setGetImageBlock:(UIImage *(^)(NSString *themeName, NSString *imageName))getImageBlock;
//----------------------------
//-end-- 设置获取素材的方法
//---------------------------

+ (instancetype)shared;
- (UIImage *)imageWithName:(NSString *)imageName;
- (UIImage *)imageWithName:(NSString *)imageName theme:(NSString *)themeName;

- (UIColor *)colorWithName:(NSString *)colorName;
- (UIColor *)colorWithName:(NSString *)colorName theme:(NSString *)themeName;
@end
