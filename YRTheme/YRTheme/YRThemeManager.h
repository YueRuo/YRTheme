//
//  YRThemeManager.h
//  Pods
//
//  Created by wangxiaoyu on 16/6/15.
//
//

/*!
 *	@brief	通过该管理类实现控件对主题素材的绑定，当主题变更时，控件自动调整到新样式
 *  @note 目前实现了最常用的UILabel、UIImageView和UIButton的自动绑定
 */
#import <Foundation/Foundation.h>
#import "YRTheme.h"

@interface YRThemeManager : NSObject

- (void)bindView:(UIView *)view bgColorName:(NSString *)colorThemeName;
- (void)bindImageView:(UIImageView *)imageView imageName:(NSString *)imageThemeName;
- (void)bindLabel:(UILabel *)label titleColorName:(NSString *)colorThemeName;
- (void)bindButton:(UIButton *)button imageName:(NSString *)imageThemeName state:(UIControlState)state;
- (void)bindButton:(UIButton *)button titleColorName:(NSString *)colorThemeName state:(UIControlState)state;
- (void)bindButton:(UIButton *)button bgImageName:(NSString *)bgImageThemeName state:(UIControlState)state;


/*!
 *	@brief	手动设置该管理类中控件的主题，一般情况下不需要使用该方法
 */
- (void)updateToTheme:(NSString *)themeName;

@end
