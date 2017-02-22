//
//  ZHNSlideToolView.m
//  slideToolView
//
//  Created by 张辉男 on 17/2/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ZHNSlideToolView.h"

@interface ZHNSlideToolView()
@property (nonatomic,assign) CGRect sliderFrame;
@property (strong,nonatomic) UIView *slider;
@property (strong,nonatomic) UIScrollView *titleScrollView;
@property (strong,nonatomic) UIScrollView *contentScollView;
@property (strong,nonatomic) NSMutableArray *titleLabelArray;
@property (strong,nonatomic) NSMutableArray *titleLabelSizeArray;
@property (strong,nonatomic) NSMutableArray *titleLabelFrameArray;
@end

@implementation ZHNSlideToolView

#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    [self p_initDefaultStatus];
    [self p_initAllUI];
    [self p_caluateTitleLabelFrame];
    self.titleScrollView.frame = self.bounds;
}

#pragma mark - 公共方法
+ (ZHNSlideToolView *)slideWithContentScrollView:(UIScrollView *)contentScrollView sliderTitleArray:(NSArray<NSString *> *)titleArray {
    ZHNSlideToolView *toolView = [[ZHNSlideToolView alloc]init];
    toolView.titleArray = titleArray;
    toolView.contentScollView = contentScrollView;
    return toolView;
}

#pragma mark - 私有方法
- (void)p_initAllUI {
    // 添加底部scrollview
    [self addSubview:self.titleScrollView];
    // 添加标题控件
    for (int i = 0; i<self.titleArray.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = self.titleArray[i];
        titleLabel.tag = i;
        [self.titleLabelArray addObject:titleLabel];
        [self.titleScrollView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:self.titleFont];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTitle:)];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel addGestureRecognizer:tapGesture];
        if (i == 0) {
            titleLabel.textColor = [self p_createColorWithColorScruct:self.highlightTitleColor];
        }else {
            titleLabel.textColor = [self p_createColorWithColorScruct:self.normalTitleColor];
        }
    }
    // 添加滑块
    [self.titleScrollView addSubview:self.slider];
    // 设置滑块的颜色
    self.slider.backgroundColor = self.sliderColor;
}

- (void)p_initDefaultStatus {
    self.sliderHeight = self.sliderHeight > 0 ? self.sliderHeight : 5;
    self.sliderWidth = self.sliderWidth > 0 ? self.sliderWidth : 30;
    self.titleFont = self.titleFont > 0 ? self.titleFont : 17;
    self.LeftRightcontentInset = self.LeftRightcontentInset > 0 ? self.LeftRightcontentInset : 20;
    self.sliderColor = self.sliderColor == nil? [UIColor blackColor] : self.sliderColor;
    self.padding = self.padding > 0 ? self.padding : 30;
}

- (void)p_caluateTitleLabelFrame {
    
    //计算标题的size
    CGFloat maxWidth = 0;
    for (NSString *title in self.titleArray) {
        CGSize currentButtonSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleFont]} context:nil].size;
        maxWidth += currentButtonSize.width;
        [self.titleLabelSizeArray addObject:[NSValue valueWithCGSize:currentButtonSize]];
    }
    
    //计算padding值
    CGFloat fitPadding = [self p_caluatePadding:maxWidth];
    NSAssert(fitPadding > 0, @"标题的宽度之和大于frame的宽度,不能设置isAutoPadding为yes 或者isAutoPaddingAndInset为yes");
    
    //计算标题的frame
    CGFloat sumWidth = self.LeftRightcontentInset;
    for (int index = 0; index < self.titleLabelSizeArray.count; index++) {
        CGSize buttonSize = [self.titleLabelSizeArray[index] CGSizeValue];
        UIButton *titleButton = self.titleLabelArray[index];
        CGFloat buttonX = sumWidth;
        CGFloat buttonY = 0;
        CGFloat buttonHeight = self.frame.size.height;
        CGFloat buttonWidth = buttonSize.width;
        CGRect buttonFrame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        titleButton.frame = buttonFrame;
        [self.titleLabelFrameArray addObject:[NSValue valueWithCGRect:buttonFrame]];
        if (index == self.titleLabelSizeArray.count - 1) {
            sumWidth += (buttonWidth+self.LeftRightcontentInset);
        }else {
            sumWidth += (fitPadding + buttonWidth);
        }
    }
    
    //计算滑块的位置
    CGRect firstTitleFrame = [self.titleLabelFrameArray.firstObject CGRectValue];
    CGFloat centerX = firstTitleFrame.size.width/2+self.LeftRightcontentInset;
    CGFloat centerY = firstTitleFrame.size.height - (self.sliderHeight/2);
    CGFloat height = self.sliderHeight;
    if (self.isSliderFitTitleSize) {
        CGFloat width = 2*self.sliderPadding + firstTitleFrame.size.width;
        CGRect sliderBounds = CGRectMake(0, 0, width, height);
        self.slider.bounds = sliderBounds;
        self.slider.center = CGPointMake(centerX, centerY);
    }else {
        CGFloat width = self.sliderWidth;
        CGRect sliderBounds = CGRectMake(0, 0, width, height);
        self.slider.bounds = sliderBounds;
        self.slider.center = CGPointMake(centerX, centerY);
    }
    
    // 计算底部scrollivew的contentSzie
    CGFloat contentWidth = sumWidth;
    CGFloat contentHeith = self.frame.size.height;
    self.titleScrollView.contentSize = CGSizeMake(contentWidth, contentHeith);
}

- (CGFloat)p_caluatePadding:(CGFloat)maxWidth {
    if (self.isAutoPaddingAndInset) {
        CGFloat paddingSum = self.frame.size.width - maxWidth;
        CGFloat currentPadding = paddingSum/(self.titleArray.count+1);
        self.LeftRightcontentInset = currentPadding;
        return currentPadding;
    }else if (self.isAutoPadding) {// 如果自动等分计算间距的情况
        CGFloat paddingSum = self.frame.size.width - maxWidth - 2*self.LeftRightcontentInset;
        return paddingSum/(self.titleArray.count-1);
    }else {// 设置了padding的情况
        return self.padding;
    }
}

- (CGPoint)p_caluateCenterUseFrame:(CGRect)frame {
    CGFloat centerX = frame.origin.x + (frame.size.width/2);
    CGFloat centerY = frame.origin.y + (frame.size.height/2);
    return CGPointMake(centerX, centerY);
}

#pragma mark - target action
- (void)clickTitle:(UITapGestureRecognizer *)gesture {
    NSInteger tag = [gesture view].tag;
    CGFloat maxOffsetX = self.contentScollView.contentSize.width - self.contentScollView.frame.size.width;
    CGFloat onpageOffsetX = maxOffsetX / (self.titleArray.count - 1);
    CGFloat currentOffsetX = onpageOffsetX * tag;
    [self.contentScollView setContentOffset:CGPointMake(currentOffsetX, 0) animated:YES];
}

#pragma mark - contentoffset KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat contentoffsetX = self.contentScollView.contentOffset.x;
        if (contentoffsetX < 0) {return;}
        CGFloat maxDelta = self.contentScollView.contentSize.width - self.contentScollView.frame.size.width;
        CGFloat onePageDelta = maxDelta/(self.titleArray.count-1);
        int page = contentoffsetX/onePageDelta;
        CGFloat floatPage = contentoffsetX/onePageDelta;
        CGFloat percent = floatPage - page;
        
        // 滑块的位置变化
        CGRect leftTitleRect;
        CGRect rightTitleRect;
        if (page > self.titleArray.count-2) {
            CGRect currentTitleRect = [self.titleLabelFrameArray.lastObject CGRectValue];
            CGFloat centerX = [self p_caluateCenterUseFrame:currentTitleRect].x;
            self.slider.center = CGPointMake(centerX, self.slider.center.y);
        }else {
            leftTitleRect = [self.titleLabelFrameArray[page] CGRectValue];
            rightTitleRect = [self.titleLabelFrameArray[page+1] CGRectValue];
            CGPoint leftCenter = [self p_caluateCenterUseFrame:leftTitleRect];
            CGPoint rightCenter = [self p_caluateCenterUseFrame:rightTitleRect];
            CGFloat centerY = self.slider.center.y;
            CGFloat centerX = leftCenter.x + (rightCenter.x - leftCenter.x)*percent;
            self.slider.center = CGPointMake(centerX, centerY);
        }
        // 是否需要自适应宽度
        if (self.isSliderFitTitleSize) {
            if(page > self.titleArray.count - 2) {
                CGRect currentTitleRect = [self.titleLabelFrameArray.lastObject CGRectValue];
                self.slider.bounds = CGRectMake(0, 0, currentTitleRect.size.width+2*self.sliderPadding, self.sliderHeight);
            }else {
                CGFloat width = (rightTitleRect.size.width - leftTitleRect.size.width)*percent + leftTitleRect.size.width + 2*self.sliderPadding;
                self.slider.bounds = CGRectMake(0, 0, width, self.sliderHeight);
            }
        }
        // 标题颜色改变
        CGFloat redDelta = (self.normalTitleColor.red - self.highlightTitleColor.red) * percent;
        CGFloat greenDelta = (self.normalTitleColor.green - self.highlightTitleColor.green) * percent;
        CGFloat blueDelta = (self.normalTitleColor.blue - self.highlightTitleColor.blue) * percent;
        UIColor *leftTitleColor = [UIColor colorWithRed:(self.highlightTitleColor.red+redDelta)/255.0 green:(self.highlightTitleColor.green+greenDelta)/255.0 blue:(self.highlightTitleColor.blue+blueDelta)/255.0 alpha:1];
        UIColor *rightTitleColor = [UIColor colorWithRed:(self.normalTitleColor.red-redDelta)/255.0 green:(self.normalTitleColor.green-greenDelta)/255.0 blue:(self.normalTitleColor.blue-blueDelta)/255.0 alpha:1];
        if (page > self.titleArray.count - 2) {
            UILabel *currentSelectedLabel = self.titleLabelArray.lastObject;
            currentSelectedLabel.textColor = [self p_createColorWithColorScruct:self.highlightTitleColor];
        }else {
            UILabel *leftTitleLabel = self.titleLabelArray[page];
            UILabel *rightTitleLabel = self.titleLabelArray[page+1];
            leftTitleLabel.textColor = leftTitleColor;
            rightTitleLabel.textColor = rightTitleColor;
        }
        // 标题需要滑动到中间的情况
        CGFloat maxOffsetX = self.titleScrollView.contentSize.width - self.titleScrollView.frame.size.width;
        if (maxOffsetX < 0) {return;}
        if (page > self.titleArray.count - 2) {
            [self.titleScrollView setContentOffset:CGPointMake(maxOffsetX, 0)];
        }else {
            CGFloat leftCenterOffsetX = leftTitleRect.origin.x - self.frame.size.width/2 + leftTitleRect.size.width/2;
            CGFloat rightCenterOffsetX = rightTitleRect.origin.x - self.frame.size.width/2 + rightTitleRect.size.width/2;
            leftCenterOffsetX = leftCenterOffsetX > 0 ? leftCenterOffsetX : 0;
            rightCenterOffsetX = rightCenterOffsetX > 0 ? rightCenterOffsetX : 0;
            leftCenterOffsetX = leftCenterOffsetX > maxOffsetX ? maxOffsetX : leftCenterOffsetX;
            rightCenterOffsetX = rightCenterOffsetX > maxOffsetX ? maxOffsetX : rightCenterOffsetX;
            CGFloat centerOffsetX = (rightCenterOffsetX - leftCenterOffsetX) * percent + leftCenterOffsetX;
            [self.titleScrollView setContentOffset:CGPointMake(centerOffsetX, 0)];
        }
    }
}

- (UIColor *)p_createColorWithColorScruct:(ZHNslideCustomColor)customColor {
    return [UIColor colorWithRed:customColor.red/255.0 green:customColor.green/255.0 blue:customColor.blue/255.0 alpha:1];
}

#pragma mark - setter getter
- (void)setContentScollView:(UIScrollView *)contentScollView {
    _contentScollView = contentScollView;
    [contentScollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

- (NSMutableArray *)titleLabelArray {
    if (_titleLabelArray == nil) {
        _titleLabelArray = [NSMutableArray array];
    }
    return _titleLabelArray;
}

- (NSMutableArray *)titleLabelSizeArray {
    if (_titleLabelSizeArray == nil) {
        _titleLabelSizeArray = [NSMutableArray array];
    }
    return _titleLabelSizeArray;
}

- (NSMutableArray *)titleLabelFrameArray {
    if (_titleLabelFrameArray == nil) {
        _titleLabelFrameArray = [NSMutableArray array];
    }
    return _titleLabelFrameArray;
}

- (UIScrollView *)titleScrollView {
    if (_titleScrollView == nil) {
        _titleScrollView = [[UIScrollView alloc]init];
        _titleScrollView.bounces = false;
        _titleScrollView.showsHorizontalScrollIndicator = false;
        _titleScrollView.showsVerticalScrollIndicator = false;
    }
    return _titleScrollView;
}

- (UIView *)slider {
    if (_slider == nil) {
        _slider = [[UIView alloc]init];
        _slider.backgroundColor = [UIColor blackColor];
    }
    return _slider;
}

@end
