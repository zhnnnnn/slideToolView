//
//  ZHNSlideToolView.h
//  slideToolView
//
//  Created by 张辉男 on 17/2/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

struct ZHNslideCustomColor {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
};
typedef struct ZHNslideCustomColor ZHNslideCustomColor;

@interface ZHNSlideToolView : UIView

/**
 标题文字的默认颜色
 */
@property(nonatomic) ZHNslideCustomColor normalTitleColor;

/**
 标题文字的高亮颜色
 */
@property(nonatomic) ZHNslideCustomColor highlightTitleColor;

/**
 滑块的颜色
 */
@property (strong,nonatomic) UIColor *sliderColor;

/**
 标题文字的间距
 */
@property (nonatomic,assign) CGFloat padding;

/**
 titleView 左右的inset值
 */
@property (nonatomic,assign) CGFloat LeftRightcontentInset;

/**
 自动计算padding (优先级高于padding)
 */
@property (nonatomic,assign) BOOL isAutoPadding;

/**
 自动计算padding和LeftRightcontentInset （LeftRightcontentInset == padding 优先级高于 isAutoPadding）
 */
@property (nonatomic,assign) BOOL isAutoPaddingAndInset;

/**
 滑块是否自适应标题文字(默认是no)
 */
@property (nonatomic,assign) BOOL isSliderFitTitleSize;

/**
 滑块的宽度 (isSliderFitTitleSize设置为yes设置宽度没有效果)
 */
@property (nonatomic,assign) CGFloat sliderWidth;

/**
 滑块的高度
 */
@property (nonatomic,assign) CGFloat sliderHeight;

/**
 滑块相对标题的padding(默认是0)
 */
@property (nonatomic,assign) CGFloat sliderPadding;

/**
 标题数组
 */
@property (nonatomic,copy) NSArray<NSString *> *titleArray;

/**
 标题文字字体大小
 */
@property (nonatomic,assign) CGFloat titleFont;

/**
 初始化方法
 
 @param contentScrollView 滑动内容
 @return slider
 */
+ (ZHNSlideToolView *)slideWithContentScrollView:(UIScrollView *)contentScrollView sliderTitleArray:(NSArray<NSString *> *)titleArray;

@end
